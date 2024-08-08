from konlpy.tag import Okt
from Conversation_Analysis.data.Keyword_data import *

class ClothingFeatureExtractor:
    def __init__(self):
        self.okt = Okt()

    def find_closest_color(self, word):
        for color, synonyms in color_synonyms.items():
            if word == color or word in synonyms:
                return colors[color]
        return None

    def extract_clothing_features(self, sentence):
        tokens = self.okt.pos(sentence, norm=True, stem=True)
        
        extracted_colors = []
        extracted_sleeve_types = []
        extracted_pants_types = []
        extracted_top_types = []
        extracted_bottom_types = []
        extracted_patterns = []
        
        for word, pos in tokens:
            if pos == 'Noun':
                closest_color = self.find_closest_color(word)
                if closest_color:
                    extracted_colors.append(closest_color)
                
                for sleeve_type, synonyms in sleeve_types.items():
                    if word in synonyms:
                        extracted_sleeve_types.append(sleeve_type)
                for pants_type, synonyms in pants_types.items():
                    if word in synonyms:
                        extracted_pants_types.append(pants_type)
                for top_type, synonyms in top_types.items():
                    if word in synonyms:
                        extracted_top_types.append(top_type)
                for bottom_type, synonyms in bottom_types.items():
                    if word in synonyms:
                        extracted_bottom_types.append(bottom_type)
                for pattern, synonyms in patterns.items():
                    if word in synonyms:
                        extracted_patterns.append(pattern)
        
        return (extracted_colors, extracted_sleeve_types, extracted_pants_types,
                extracted_top_types, extracted_bottom_types, extracted_patterns)
