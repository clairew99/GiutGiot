import pandas as pd
from konlpy.tag import Okt
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
import joblib

class QuestionStatementClassifier:
    def __init__(self):
        self.okt = Okt()
        self.vectorizer = TfidfVectorizer()
        self.model = None

    def preprocess(self, text):
        return ' '.join(self.okt.morphs(text))

    def fit(self, X, y):
        X = X.apply(self.preprocess)
        X_tfidf = self.vectorizer.fit_transform(X)
        X_train, X_test, y_train, y_test = train_test_split(X_tfidf, y, test_size=0.2, random_state=42)
        
        param_grid = {
            'C': [0.1, 1, 10, 100],
            'gamma': [1, 0.1, 0.01, 0.001],
            'kernel': ['linear', 'rbf', 'poly', 'sigmoid']
        }
        
        grid = GridSearchCV(SVC(), param_grid, refit=True, verbose=2)
        grid.fit(X_train, y_train)
        
        self.model = grid
        print("Best parameters found: ", grid.best_params_)
        grid_predictions = grid.predict(X_test)
        print(f"Accuracy: {accuracy_score(y_test, grid_predictions) * 100}%")
    
    def predict(self, text):
        text_processed = self.preprocess(text)
        text_tfidf = self.vectorizer.transform([text_processed])
        prediction = self.model.predict(text_tfidf)
        return 'Question' if prediction[0] == 1 else 'Statement'

    def save_model(self, model_path, vectorizer_path):
        joblib.dump(self.model, model_path)
        joblib.dump(self.vectorizer, vectorizer_path)
    
    def load_model(self, model_path, vectorizer_path):
        self.model = joblib.load(model_path)
        self.vectorizer = joblib.load(vectorizer_path)

# 데이터 로드 및 모델 학습
df = pd.read_csv(r"S11P12A409\Flask\Conversation_Analysis\data\Interrogative_Plain_data.csv", encoding='euc-kr')
X = df['reviews']
y = df['label']

classifier = QuestionStatementClassifier()
classifier.fit(X, y)

# 모델 저장
classifier.save_model('svc_model.pkl', 'tfidf_vectorizer.pkl')
