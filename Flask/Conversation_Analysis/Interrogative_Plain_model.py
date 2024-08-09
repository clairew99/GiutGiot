from Conversation_Analysis.Interrogative_Plain import *
# 저장된 모델 불러오기
classifier = QuestionStatementClassifier()
classifier.load_model('svc_model.pkl', 'tfidf_vectorizer.pkl')

# # 예시 텍스트에 대한 예측
# sample_text1 = "이걸로 입을게"
# sample_text2 = "어떤 신발이 좋아"
# print(f"'{sample_text1}' => {classifier.predict(sample_text1)}")
# print(f"'{sample_text2}' => {classifier.predict(sample_text2)}")
