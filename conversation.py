from konlpy.tag import Okt
from colors import colors, color_synonyms

class ClothingFeatureExtractor:
    def __init__(self):
        self.okt = Okt()

        self.sleeve_types = {
            "긴팔": ["긴팔", "긴소매", "롱슬리브", "긴팔 티셔츠", "긴팔티"],
            "반팔": ["반팔", "반소매", "반팔 티셔츠", "반팔티"]
        }

        self.pants_types = {
            "긴바지": ["긴바지", "바지", "롱팬츠", "긴 팬츠"],
            "반바지": ["반바지", "숏팬츠", "쇼츠", "반바지 팬츠"]
        }

        self.top_types = {
            "니트": ["니트", "스웨터", "니트 스웨터"],
            "셔츠": ["셔츠", "와이셔츠", "드레스 셔츠", "남방", "셔츠 남방"],
            "카라셔츠": ["카라티셔츠", "카라티", "폴로 셔츠", "폴로티","카라"],
            "후드티": ["후드티", "후드", "후드 스웨터", "후디"],
            "맨투맨": ["맨투맨", "맨투맨 티셔츠", "맨투맨 티"],
            "블라우스": ["블라우스", "셔츠 블라우스"],
            "면티": ["면티","면 티셔츠", "면"],
            "원피스": ["원피스", "드레스", "롱원피스", "짧은 원피스"]
        }

        self.bottom_types = {
            "청바지": ["청바지", "데님", "데님 팬츠"],
            "면바지": ["면바지", "면 팬츠"],
            "슬랙스": ["슬랙스", "정장 바지", "정장 슬랙스"],
            "치마": ["치마", "스커트", "롱스커트", "미니스커트"],
            "카고팬츠": ["카고팬츠", "카고", "카고바지", "카고 팬츠"],
            "트레이닝": ["트레이닝팬츠", "트레이닝", "운동 바지", "운동 팬츠"]
        }

        self.patterns = {
            "단색": ["단색", "무지", "솔리드"],
            "프린팅": ["드로잉", "그림", "일러스트","로고", "그래픽", "프린트"],
            "스트라이프": ["스트라이프", "줄무늬", "세로줄", "가로줄"],
            "도트": ["도트", "물방울", "땡땡이", "점무늬"],
            "체크": ["체크", "격자", "체크무늬", "체크 패턴"],
            "플라워": ["플라워", "꽃무늬", "꽃 패턴", "플라워 패턴"]
        }

    def find_closest_color(self, word):
        for color, synonyms in color_synonyms.items():
            if word == color or word in synonyms:
                return colors[color]
        return None

    def find_closest_brand(self, word):
        for brand, synonyms in self.brand_synonyms.items():
            if word == brand or word in synonyms:
                return brand
        return None

    def extract_clothing_features(self, sentence):
        tokens = self.okt.pos(sentence, norm=True, stem=True)
        
        extracted_colors = []
        extracted_sleeve_types = []
        extracted_pants_types = []
        extracted_top_types = []
        extracted_bottom_types = []
        extracted_patterns = []
        extracted_brands = []
        
        for word, pos in tokens:
            if pos == 'Noun':
                closest_color = self.find_closest_color(word)
                if closest_color:
                    extracted_colors.append(closest_color)
                closest_brand = self.find_closest_brand(word)
                if closest_brand:
                    extracted_brands.append(closest_brand)
                for sleeve_type, synonyms in self.sleeve_types.items():
                    if word in synonyms:
                        extracted_sleeve_types.append(sleeve_type)
                for pants_type, synonyms in self.pants_types.items():
                    if word in synonyms:
                        extracted_pants_types.append(pants_type)
                for top_type, synonyms in self.top_types.items():
                    if word in synonyms:
                        extracted_top_types.append(top_type)
                for bottom_type, synonyms in self.bottom_types.items():
                    if word in synonyms:
                        extracted_bottom_types.append(bottom_type)
                for pattern, synonyms in self.patterns.items():
                    if word in synonyms:
                        extracted_patterns.append(pattern)
        
        return (extracted_colors, extracted_sleeve_types, extracted_pants_types,
                extracted_top_types, extracted_bottom_types, extracted_patterns)
