import pandas as pd
from konlpy.tag import Okt
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score

# 데이터 로드
df = pd.read_csv(r"C:\Users\SSAFY\Desktop\A409\GIUTGIOT_flask_app\data.csv", encoding='euc-kr')

# 의문문과 평문 데이터 분리
X = df['reviews']
y = df['label']

# 형태소 분석기 설정
okt = Okt()
X = X.apply(lambda x: ' '.join(okt.morphs(x)))

# TF-IDF 벡터화
vectorizer = TfidfVectorizer()
X_tfidf = vectorizer.fit_transform(X)

# 학습 및 테스트 데이터 분리
X_train, X_test, y_train, y_test = train_test_split(X_tfidf, y, test_size=0.2, random_state=42)

# 하이퍼파라미터 설정
param_grid = {
    'C': [0.1, 1, 10, 100],
    'gamma': [1, 0.1, 0.01, 0.001],
    'kernel': ['linear', 'rbf', 'poly', 'sigmoid']
}

# Grid Search 객체 생성
grid = GridSearchCV(SVC(), param_grid, refit=True, verbose=2)
grid.fit(X_train, y_train)

# 최적의 하이퍼파라미터 출력
print("Best parameters found: ", grid.best_params_)

# 모델 평가
grid_predictions = grid.predict(X_test)
print(f"Accuracy: {accuracy_score(y_test, grid_predictions) * 100}%")

# 새로운 문장에 대한 예측 함수
def predict_question_or_statement(text):
    text_processed = ' '.join(okt.morphs(text))
    text_tfidf = vectorizer.transform([text_processed])
    prediction = grid.predict(text_tfidf)
    return 'Question' if prediction[0] == 1 else 'Statement'

# 예시 텍스트에 대한 예측
sample_text1 = "이걸로 입을게"
sample_text2 = "어떤 신발이 좋아"
print(f"'{sample_text1}' => {predict_question_or_statement(sample_text1)}")
print(f"'{sample_text2}' => {predict_question_or_statement(sample_text2)}")
