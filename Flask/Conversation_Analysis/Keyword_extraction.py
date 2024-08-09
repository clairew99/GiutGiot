from konlpy.tag import Okt
from Conversation_Analysis.data.Keyword_data import *

class ClothingFeatureExtractor:
    def __init__(self):
        self.okt = Okt()
        self.compound_words = {
            "긴팔": ["기다", "팔"],
            "반팔": ["반", "팔"],
            "긴바지": ["기다", "바지"],
            "긴팬츠": ["기다", "팬츠"],
            "반바지": ["반", "바지"],
            "후드티": ["후드", "티"],
            "맨투맨": ["맨", "투", "맨"]
        }
        self.top_items = set(sum([synonyms for synonyms in top_types.values()], []) + 
                             sum([synonyms for synonyms in sleeve_types.values()], []))
        self.bottom_items = set(sum([synonyms for synonyms in bottom_types.values()], []) + 
                                sum([synonyms for synonyms in pants_types.values()], []))

    def preprocess_sentence(self, sentence):
        for compound, parts in self.compound_words.items():
            sentence = sentence.replace("".join(parts), compound)
        return sentence

    def postprocess_tokens(self, tokens):
        processed_tokens = []
        i = 0
        while i < len(tokens):
            current_word, current_pos = tokens[i]
            for compound, parts in self.compound_words.items():
                if i + len(parts) <= len(tokens) and all(tokens[i+j][0] == part for j, part in enumerate(parts)):
                    processed_tokens.append((compound, 'Noun'))
                    i += len(parts)
                    break
            else:
                processed_tokens.append((current_word, current_pos))
                i += 1
        return processed_tokens

    def find_closest_color(self, word):
        for color, synonyms in color_synonyms.items():
            if word == color or word in synonyms:
                return colors[color]
        return None

    def is_top(self, word):
        if word in self.top_items:
            return True
        if word in self.bottom_items:
            return False
        return None

    def extract_clothing_features(self, sentence):
        sentence = self.preprocess_sentence(sentence)
        tokens = self.okt.pos(sentence, norm=True, stem=True)
        tokens = self.postprocess_tokens(tokens)
        print(tokens)  # 토큰화된 결과를 출력하여 확인합니다.
        
        top_features = {
            'color': None,
            'sleeve_type': None,
            'top_type': None,
            'pattern': None
        }
        
        bottom_features = {
            'color': None,
            'pants_type': None,
            'bottom_type': None,
            'pattern': None
        }
        
        current_part = None
        current_color = None
        current_pattern = None
        
        for i, (word, pos) in enumerate(tokens):
            if pos in ['Noun', 'Adjective']:
                is_top = self.is_top(word)
                color = self.find_closest_color(word)
                
                if color:
                    current_color = color
                
                # Pattern recognition
                for pattern, synonyms in patterns.items():
                    if word in synonyms:
                        current_pattern = pattern
                
                if is_top is not None:
                    if current_color:
                        if is_top:
                            top_features['color'] = current_color
                        else:
                            bottom_features['color'] = current_color
                        current_color = None
                    if current_pattern:
                        if is_top:
                            top_features['pattern'] = current_pattern
                        else:
                            bottom_features['pattern'] = current_pattern
                        current_pattern = None
                    current_part = 'top' if is_top else 'bottom'
                
                if current_part == 'top' or (current_part is None and is_top is None):
                    for sleeve_type, synonyms in sleeve_types.items():
                        if word in synonyms:
                            top_features['sleeve_type'] = sleeve_type
                    for top_type, synonyms in top_types.items():
                        if word in synonyms:
                            top_features['top_type'] = top_type
                            if current_color:
                                top_features['color'] = current_color
                                current_color = None
                            if current_pattern:
                                top_features['pattern'] = current_pattern
                                current_pattern = None
                
                if current_part == 'bottom' or (current_part is None and is_top is None):
                    for pants_type, synonyms in pants_types.items():
                        if word in synonyms or '팬츠' in word or '바지' in word:
                            bottom_features['pants_type'] = pants_type
                            if current_color:
                                bottom_features['color'] = current_color
                                current_color = None
                            if current_pattern:
                                bottom_features['pattern'] = current_pattern
                                current_pattern = None
                    for bottom_type, synonyms in bottom_types.items():
                        if word in synonyms:
                            bottom_features['bottom_type'] = bottom_type
                            if current_color:
                                bottom_features['color'] = current_color
                                current_color = None
                            if current_pattern:
                                bottom_features['pattern'] = current_pattern
                                current_pattern = None
        
        # If there's a remaining color or pattern, assign it to the last known part
        if current_color or current_pattern:
            if current_part == 'top' or (current_part is None and bottom_features['pants_type'] is None):
                if current_color:
                    top_features['color'] = current_color
                if current_pattern:
                    top_features['pattern'] = current_pattern
            elif current_part == 'bottom' or (current_part is None and bottom_features['pants_type'] is not None):
                if current_color:
                    bottom_features['color'] = current_color
                if current_pattern:
                    bottom_features['pattern'] = current_pattern

        return {'top': top_features, 'bottom': bottom_features}

