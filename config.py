# config.py
from dotenv import load_dotenv
import os

load_dotenv()  # .env 파일에서 환경 변수를 로드

class Config:
    PYANNOTE_TOKEN = os.getenv('PYANNOTE_TOKEN', 'default_token_value')
