# 긍정적인 대답 리스트
positive_responses = [
    "응, 입을게.", "좋아, 입을게.", "당연하지.", "물론이야.", "그래, 입을게.", "입을 거야.", "그렇지, 입어야지.", 
    "그렇지, 입어야겠어.", "맞아, 입을게.", "그럼, 입지.", "꼭 입을게.", "당연히 입어야지.", "입고 싶어.", 
    "좋아, 입고 갈게.", "입기로 했어.", "그래, 마음에 들어.", "준비됐어, 입을게.", "그래, 입을 거야.", "맞아, 이 옷 좋아.", 
    "입어야겠어.", "입겠습니다.", "그래, 이거 입을게.", "좋아, 이거 입고 싶어.", "입을 준비 됐어.", "좋아, 입을게.", 
    "딱 맞아.", "그럼, 입고 갈게.", "입기로 했어.", "이 옷 마음에 들어.", "이거 입을게.", "꼭 입고 싶어.", 
    "이 옷 좋아.", "입고 싶어.", "이거 입을게.", "입고 갈게.", "입겠습니다.", "이거 마음에 들어.", "입고 싶어.", 
    "이거 입을게.", "이거 입고 싶어.", "이 옷 마음에 들어.", "이 옷 입을 거야.", "입기로 했어.", "이 옷 좋아.", 
    "입고 싶어.", "이거 입겠습니다.", "이 옷 좋아.", "이거 입고 싶어.", "이거 입겠습니다.", "이 옷 입을 거야.", 
    "이거 입기로 했어.", "이 옷 입겠습니다.", "이거 입을게.", "이거 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", 
    "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", 
    "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", "이거 입겠습니다.", "이 옷 마음에 들어.", 
    "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.", "이거 입고 싶어.", "이 옷 입기로 했어.", 
    "이거 입겠습니다.", "이 옷 마음에 들어.", "입고 싶어.", "이거 입고 갈게.", "이 옷 입겠습니다.", "이거 입을게.",
    "응 좋아", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "어", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "응 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "어 좋아", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그러지 뭐", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "그럴까 그럼", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아", "나도 좋은 것 같아"
]

# 부정적인 대답 리스트
negative_responses = [
    "싫어, 안 입어.",
    "다른 거 입을게.",
    "안 입을 거야.",
    "안 맞아.",
    "별로야.",
    "마음에 안 들어.",
    "안 어울려.",
    "다른 거 찾을게.",
    "입기 싫어.",
    "입기 불편해.",
    "이건 아니야.",
    "다른 거 있어.",
    "안 입고 싶어.",
    "다른 옷 입을게.",
    "안 예뻐.",
    "불편해.",
    "다른 옷 입고 싶어.",
    "별로 안 좋아.",
    "이거 안 좋아.",
    "다른 걸로 할래.",
    "취향 아니야.",
    "그냥 안 입을래.",
    "이건 싫어.",
    "내 스타일 아니야.",
    "입고 싶지 않아.",
    "이거 말고 다른 거.",
    "나랑 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이 옷 별로야.",
    "다른 옷이 나아.",
    "이거 불편해.",
    "이건 좀 그렇네.",
    "다른 옷이 더 좋아.",
    "다른 스타일이 나아.",
    "이건 내 취향 아냐.",
    "이거 말고 다른 거.",
    "입기 별로야.",
    "다른 거 선택할래.",
    "이건 내 스타일 아냐.",
    "좀 불편해 보이네.",
    "다른 옷이 더 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 안 어울려.",
    "다른 거 찾을래.",
    "이건 안 맞아.",
    "다른 스타일이 좋아.",
    "이건 싫어.",
    "다른 거 입고 싶어.",
    "별로 맘에 안 들어.",
    "다른 거 골라볼게.",
    "이건 아닌 것 같아.",
    "다른 옷이 좋아.",
    "이건 맘에 안 들어.",
    "다른 거 해볼래.",
    "이건 별로야.",
    "다른 스타일이 좋아.",
    "이건 좀 그렇다.",
    "다른 옷 입고 싶어.",
    "이건 내 취향 아니야.",
    "다른 걸로 할게.",
    "이건 별로인 것 같아.",
    "다른 옷을 골라볼게.",
    "이건 좀 별로야.",
    "다른 걸 찾고 싶어.",
    "이건 안 어울릴 것 같아.",
    "다른 스타일이 더 좋아.",
    "이건 마음에 안 든다.",
    "다른 거 선택할래.",
    "이건 좀 불편해.",
    "다른 옷이 더 좋아.",
    "이건 별로 안 좋아.",
    "다른 걸로 고를게.",
    "이건 내 스타일 아니야.",
    "다른 거 입고 싶어.",
    "이건 별로 맘에 안 들어.",
    "다른 옷을 찾을래.",
    "이건 좀 아닌 것 같아.",
    "다른 거 할래.",
    "이건 안 맞아.",
    "다른 스타일이 좋아.",
    "이건 좀 별로야.",
    "다른 거 입고 싶어.",
    "이건 내 취향 아니야.",
    "다른 거 선택할게.",
    "이건 맘에 안 든다.",
    "다른 옷이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "이건 맘에 안 들어.",
    "다른 옷 입고 싶어.",
    "이건 별로 안 좋아.",
    "다른 걸로 할게.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 좋아.",
    "이건 별로야.",
    "다른 거 골라볼래.",
    "이건 안 맞아.",
    "다른 걸 찾고 싶어.",
    "이건 좀 별로야.",
    "다른 거 선택할래.",
    "이건 내 취향 아니야.",
    "다른 거 입고 싶어.",
    "이건 좀 그렇다.",
    "다른 옷을 찾을래.",
    "이건 마음에 안 들어.",
    "다른 스타일이 더 좋아.",
    "이건 별로야.",
    "다른 걸로 할래.",
    "이건 안 어울려.",
    "다른 거 찾고 싶어.",
    "이건 좀 불편해 보이네.",
    "다른 스타일이 나아.",
    "이건 별로야.",
    "다른 거 할래.",
    "이건 내 스타일 아니야.",
    "다른 거 선택할래.",
    "마음에 안 들어.", "안 어울려.", "다른 거 찾을게.", "입기 싫어.", "입기 불편해.",

]

