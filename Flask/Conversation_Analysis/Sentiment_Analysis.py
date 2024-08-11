import nltk
from konlpy.tag import Okt
from nltk.classify import NaiveBayesClassifier
from nltk.classify.util import accuracy
import random
from Conversation_Analysis.data.Sentiment_data import *

# 형태소 분석기 설정
okt = Okt()

# 특징 추출 함수 정의
def extract_features(words):
    return dict([(word, True) for word in words])

# 리뷰 데이터를 특징으로 변환
positive_features = [(extract_features(okt.morphs(review)), '긍정') for review in positive_responses]
negative_features = [(extract_features(okt.morphs(review)), '부정') for review in negative_responses]

# 데이터셋 결합 및 셔플
dataset = positive_features + negative_features
random.shuffle(dataset)

# 학습 및 테스트 데이터 분리
train_data = dataset[:int(len(dataset)*0.8)]
test_data = dataset[int(len(dataset)*0.2):]

# 나이브 베이즈 분류기 학습
classifier = NaiveBayesClassifier.train(train_data)

# 모델 평가
print(f"Accuracy: {accuracy(classifier, test_data) * 100}%")

# 가장 정보량이 많은 특징 10개 출력
classifier.show_most_informative_features(10)

# 텍스트 감정 예측 함수
def predict_sentiment(text):
    words = okt.morphs(text)
    features = extract_features(words)
    return classifier.classify(features)


print(predict_sentiment('응 입을게'))
