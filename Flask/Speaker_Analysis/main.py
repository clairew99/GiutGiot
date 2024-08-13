import whisper
from pyannote.audio import Pipeline
from pydub import AudioSegment
from collections import defaultdict
import numpy as np
import torch
from pyannote.core import Segment
import librosa
import librosa.display
import math
import heapq
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
import tempfile

class AudioProcessor:
    def __init__(self, hf_token):
        self.hf_token = hf_token

    def preprocess_audio(self, file):
        audio = AudioSegment.from_file(file)
        audio = audio + 8  # 볼륨 높이기
        audio = audio.low_pass_filter(5000)  # 노이즈 제거
        
        processed_path = tempfile.NamedTemporaryFile(delete=False, suffix='.wav').name
        audio.export(processed_path, format="wav")
        return processed_path

    def transcribe_audio(self, file_path):
        model = whisper.load_model("base")
        result = model.transcribe(file_path)
        return result['segments']

    def predict_number_of_speakers(self, file_path):
        y, sr = librosa.load(file_path)
        mfcc = librosa.feature.mfcc(y=y, sr=sr, n_mfcc=13)
        mfcc_mean = np.mean(mfcc.T, axis=0)
        mfcc_std = np.std(mfcc.T, axis=0)
        features = np.hstack([mfcc_mean, mfcc_std])
        
        distortions = []
        silhouette_scores = []
        K = range(2, 10)
        for k in K:
            kmeans = KMeans(n_clusters=k)
            kmeans.fit(features.reshape(-1, 1))
            distortions.append(kmeans.inertia_)
            silhouette_scores.append(silhouette_score(features.reshape(-1, 1), kmeans.labels_))
        
        optimal_k = K[silhouette_scores.index(max(silhouette_scores))]
        return optimal_k

    def diarize_audio(self, file_path, min_speakers, max_speakers):
        try:
            pipeline = Pipeline.from_pretrained("pyannote/speaker-diarization", use_auth_token=self.hf_token)
            diarization = pipeline({"audio": file_path}, min_speakers=min_speakers, max_speakers=max_speakers)
            diarization_result = []
            for turn, _, speaker in diarization.itertracks(yield_label=True):
                diarization_result.append((turn.start, turn.end, speaker))
            return diarization_result
        except Exception as e:
            print("Error during diarization:", str(e))
            return None

    def match_speakers(self, diarization_result, whisper_segments):
        ListA = []
        for segment in whisper_segments:
            start, end = segment['start'], segment['end']
            ListA.append([start, end])
        
        speaker_dict = defaultdict(list)
        for start, end, speaker in diarization_result:
            speaker_dict[speaker].append([start, end])

        areas = {speaker: [[0, 0] for _ in range(math.ceil(ListA[-1][1]) + 1)] for speaker in speaker_dict.keys()}

        result = ['Unknown' for _ in range(len(ListA))]

        for speaker, intervals in speaker_dict.items():
            heapq.heapify(intervals)
            area = areas[speaker]

            while intervals:
                start, end = heapq.heappop(intervals)
                area[math.floor(start) + 1:min(math.floor(end), math.floor(ListA[-1][0]))] = [[0.5, 0.5] for _ in range(min(math.floor(end), math.floor(ListA[-1][0])) - math.floor(start) - 1)]
                if (start - int(start)) > 0.5:
                    area[math.floor(start)][1] = max(0.5 - (start - int(start)), area[math.floor(start)][1])
                else:
                    area[math.floor(start)][1] = 0.5
                    area[math.floor(start)][0] = max((start - int(start)), area[math.floor(start)][0])
                if (end - int(end)) < 0.5:
                    area[math.floor(end)][0] = max((end - int(end)), area[math.floor(end)][1])
                else:
                    area[math.floor(end)][0] = 0.5
                    area[math.floor(end)][1] = max((end - int(end)) - 0.5, area[math.floor(end)][1])

        for j in range(len(ListA)):
            start, end = ListA[j][0], ListA[j][1]
            max_prob = 0
            best_speaker = 'Unknown'

            for speaker, area in areas.items():
                temp_prob = 0
                for i in range(math.floor(start), math.ceil(end)):
                    temp_prob += sum(area[i])
                if temp_prob > max_prob:
                    max_prob = temp_prob
                    best_speaker = speaker

            result[j] = best_speaker

        return result
    

    def calculate_speaker_times(self, diarization_result):
        speaker_times = defaultdict(float)
        for start, end, speaker in diarization_result:
            speaker_times[speaker] += end - start
        return dict(speaker_times)
    

    def process_audio(self, file):
        print("음성 전처리 중...")
        preprocessed_audio_path = self.preprocess_audio(file)
        
        print("화자 수 예측 중...")
        predicted_speakers = self.predict_number_of_speakers(preprocessed_audio_path)
        print(f"예상 화자 수: {predicted_speakers}")
        
        print("화자 분리 중...")
        diarization_result = self.diarize_audio(preprocessed_audio_path, min_speakers=predicted_speakers, max_speakers=10)
        if diarization_result is None:
            print("화자 분리에 실패했습니다.")
            return {}

        print(diarization_result)

        print("화자별 대화 시간 계산 중...")
        speaker_times = self.calculate_speaker_times(diarization_result)
        
            # 모든 화자의 대화 시간을 더함
        total_time = sum(speaker_times.values())
        
        # 화자 수만큼 리스트에 동일한 값을 넣음
        speaker_count = len(speaker_times)
        result_list = [total_time] * speaker_count

        return result_list