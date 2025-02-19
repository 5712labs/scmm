from fastapi import APIRouter, UploadFile
import os
import base64
import numpy as np
import cv2
from mmdet.apis import init_detector, inference_detector
from openai import OpenAI
from configuration.config import settings
import json

v1_router = APIRouter(
    prefix="/api/v1/mmdet",
)

# =========================================
# 1. 앱 시작 시 모델 한 번만 초기화하기
# =========================================
CONFIG_FILE = '/app/mmdetection/configs/spinenet/class_spinenet_final_cycle.py'
CHECKPOINT_FILE = '/app/mmdetection/work_dirs/final_cycle/spinenet/epoch_55.pth'
DEVICE = 'cpu'

CLIENT_IP = settings.CLIENT_IP

# 전역으로 모델 로딩 (앱 기동 시에만 불러옴)
model = init_detector(CONFIG_FILE, CHECKPOINT_FILE, device=DEVICE)

# 시나리오 매핑 딕셔너리
scenario_mapping = {

    "WO-01": {"class": "작업자", "소분류": "작업자", "대분류": "이동객체"},
    "WO-02": {"class": "신호수", "소분류": "신호수", "대분류": "이동객체"},
    "WO-03": {"class": "사다리", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-04": {"class": "안전 난간이 설치된 이동식 비계", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-05": {"class": "안전 난간이 설치되지 않은 이동식 비계", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-06": {"class": "레미콘", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-07": {"class": "굴삭기", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-08": {"class": "전도방지대가 설치된 이동식 크레인", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-09": {"class": "과상승방지봉이 미설치된 시저형 고소작업대", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-10": {"class": "과상승방지봉이 설치된 시저형 고소작업대", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-11": {"class": "말비계", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-12": {"class": "전도 방지대가 설치된 콘크리트 펌프카", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-13": {"class": "전도 방지대가 미설치된 콘크리트 펌프카", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-14": {"class": "지게차", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-15": {"class": "덤프트럭", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-16": {"class": "항타기", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-17": {"class": "롤러", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-18": {"class": "타워크레인", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-19": {"class": "전도방지대가 설치된 사다리차", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-20": {"class": "전도방지대가 설치된 오거크레인", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-21": {"class": "전도방지대가 미설치된 오거크레인", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-22": {"class": "화물트럭", "소분류": "이동식장비", "대분류": "이동객체"},
    "WO-23": {"class": "용접면을 쓴 작업자", "소분류": "작업자", "대분류": "이동객체"},

    "SO-01": {"class": "개구부 안전난간", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-02": {"class": "안전 난간이 설치된 단부", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-03": {"class": "정상 작업발판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-04": {"class": "비정상 작업발판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-05": {"class": "해치가 닫혀 있는 개폐형 작업발판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-06": {"class": "해치가 열려 있는 개폐형 작업발판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-07": {"class": "개구부 덮개", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-08": {"class": "수직방지망", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-09": {"class": "낙하물방지망", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-11": {"class": "출입구 방호선반", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-12": {"class": "거푸집", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-13": {"class": "쐐기목이 미설치된 동바리 받침판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-14": {"class": "안전 난간이 미설치된 단부", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-15": {"class": "쐐기목이 미설치된 버팀대", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-16": {"class": "쐐기목이 설치된 버팀대", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-17": {"class": "쐐기목이 설치된 동바리 받침판", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-18": {"class": "낙하물 방지망 설치 미흡", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-19": {"class": "개구부 덮개 미흡", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-20": {"class": "불티비산방지막", "소분류": "안전 시설물", "대분류": "정적 객체"},
    "SO-21": {"class": "우레탄 폼건", "소분류": "공구", "대분류": "정적 객체"},
    "SO-22": {"class": "에어 스프레이건", "소분류": "공구", "대분류": "정적 객체"},
    "SO-23": {"class": "산소절단기", "소분류": "공구", "대분류": "정적 객체"},
    "SO-24": {"class": "용접기", "소분류": "공구", "대분류": "정적 객체"},
    "SO-25": {"class": "원형톱", "소분류": "공구", "대분류": "정적 객체"},
    "SO-26": {"class": "공구박스", "소분류": "공구", "대분류": "정적 객체"},
    "SO-27": {"class": "롤러 브러쉬", "소분류": "공구", "대분류": "정적 객체"},
    "SO-28": {"class": "불꽃이 발생하는 원형톱", "소분류": "공구", "대분류": "정적 객체"},
    "SO-30": {"class": "페인트 통", "소분류": "자재", "대분류": "정적 객체"},
    "SO-31": {"class": "시멘트 포대", "소분류": "자재", "대분류": "정적 객체"},
    "SO-32": {"class": "단열재", "소분류": "자재", "대분류": "정적 객체"},
    "SO-33": {"class": "관", "소분류": "자재", "대분류": "정적 객체"},
    "SO-34": {"class": "벽돌", "소분류": "자재", "대분류": "정적 객체"},
    "SO-35": {"class": "PE 안전 펜스", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-36": {"class": "고체 연료", "소분류": "보조 장비", "대분류": "정적 객체"},
    "SO-37": {"class": "철제 인양박스", "소분류": "보조 장비", "대분류": "정적 객체"},
    "SO-38": {"class": "항공마대", "소분류": "보조 장비", "대분류": "정적 객체"},
    "SO-39": {"class": "이동형 환풍기", "소분류": "보조 장비", "대분류": "정적 객체"},
    "SO-40": {"class": "소화기", "소분류": "보조 장비", "대분류": "정적 객체"},
    "SO-41": {"class": "라바콘", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-42": {"class": "유도봉", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-43": {"class": "방독면", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-44": {"class": "가스경보기", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-45": {"class": "타포린형 안전표지판", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-46": {"class": "위험테이프", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "SO-47": {"class": "벤딩형 가림막 펜스", "소분류": "안전 보조 장비", "대분류": "정적 객체"},
    "DO-01": {"class": "위험물 저장소", "소분류": "영역", "대분류": "영역 객체"},
    "DO-02": {"class": "수직방지망 설치 불량인 갱폼", "소분류": "영역", "대분류": "영역 객체"},
    "DO-03": {"class": "개구부", "소분류": "영역", "대분류": "영역 객체"},
    "DO-04": {"class": "출입구", "소분류": "영역", "대분류": "영역 객체"},
    "DO-06": {"class": "방수 페인트", "소분류": "영역", "대분류": "영역 객체"},

    "Y-01": {"scenario": "시스템 비계 작업 발판 설치", "process": "비계 공사", "accident_type": "추락"},
    "Y-02": {"scenario": "개폐형 발판이 닫혀 있는 상황", "process": "비계 공사", "accident_type": "추락"},
    "Y-03": {"scenario": "개구부 덮개 설치", "process": "개구부 공사", "accident_type": "추락"},
    "Y-04": {"scenario": "개구부 안전난간 설치", "process": "개구부 공사", "accident_type": "추락"},
    "Y-05": {"scenario": "단부에서 안전난간 설치", "process": "외벽 공사", "accident_type": "추락"},
    "Y-06": {"scenario": "단부에서 수직 방지망 설치", "process": "외벽 공사", "accident_type": "추락"},
    "Y-07": {"scenario": "이동식 비계 안전난간 설치", "process": "조적, 미장, 방수공사", "accident_type": "추락"},
    "Y-08": {"scenario": "이동식 비계 발판 위 간이 사다리 미설치", "process": "조적, 미장, 방수공사", "accident_type": "추락"},
    "Y-09": {"scenario": "사다리 정상 설치", "process": "사다리 공사", "accident_type": "추락"},
    "Y-10": {"scenario": "작업자가 사다리 최상단 밑단에서 작업", "process": "사다리 공사", "accident_type": "추락"},
    "Y-11": {"scenario": "시스템 비계 위 낙하 위험물 미배치", "process": "비계 공사", "accident_type": "낙하"},
    "Y-12": {"scenario": "시스템 비계 상단(또는 하단)만 작업", "process": "비계 공사", "accident_type": "낙하"},
    "Y-13": {"scenario": "출입구 방호선반 설치", "process": "외벽 공사", "accident_type": "낙하"},
    "Y-14": {"scenario": "낙하물 방지망 설치", "process": "외벽 공사", "accident_type": "낙하"},
    "Y-15": {"scenario": "거푸집 단부 위 적재물 미배치", "process": "거푸집 공사", "accident_type": "낙하"},
    "Y-16": {"scenario": "거푸집 설치 및 해체 상단(또는 하단)만 작업", "process": "거푸집 공사", "accident_type": "낙하"},
    "Y-17": {"scenario": "사다리차 정상 적재", "process": "화물 운반 공사", "accident_type": "낙하"},
    "Y-18": {"scenario": "사다리차 작업 시 신호수 배치", "process": "화물 운반 공사", "accident_type": "낙하"},
    "Y-19": {"scenario": "이동식 크레인 작업 시 신호수 배치", "process": "양중 작업", "accident_type": "낙하"},
    "Y-20": {"scenario": "이동식 크레인 작업 시 철제 인양박스 사용", "process": "양중 작업", "accident_type": "낙하"},
    "Y-21": {"scenario": "관로공사 시 신호수 배치", "process": "관로 공사", "accident_type": "협착"},
    "Y-22": {"scenario": "굴삭기 자재 양중 시 신호수 배치", "process": "관로 공사", "accident_type": "협착"},
    "Y-23": {"scenario": "시저형 고소작업대 과상승방지봉 설치높이 준수", "process": "고소작업대 공사", "accident_type": "협착"},
    "Y-24": {"scenario": "시저형 고소작업대 위험 반경 외 근로자 작업", "process": "고소작업대 공사", "accident_type": "협착"},
    "Y-25": {"scenario": "덤프 트럭 작업 시 신호수 배치", "process": "화물 운반 공사", "accident_type": "협착"},
    "Y-26": {"scenario": "덤프 트럭 위험 반경 외 근로자 작업", "process": "화물 운반 공사", "accident_type": "협착"},
    "Y-27": {"scenario": "굴삭기 작업 시 신호수 배치", "process": "토공사", "accident_type": "협착"},
    "Y-28": {"scenario": "굴삭기 수평 위험 반경 외 작업", "process": "토공사", "accident_type": "협착"},
    "Y-29": {"scenario": "레미콘 작업 시 신호수 배치", "process": "콘크리트 타설 공사", "accident_type": "협착"},
    "Y-30": {"scenario": "레미콘 위험 반경 외 근로자 작업", "process": "콘크리트 타설 공사", "accident_type": "협착"},
    "Y-31": {"scenario": "실내 마감 작업 시 이동형 환풍기 설치", "process": "실내 마감 공사", "accident_type": "화재"},
    "Y-32": {"scenario": "실내 마감 작업 시 근처 난로 미설치", "process": "실내 마감 공사", "accident_type": "화재"},
    "Y-33": {"scenario": "용접기 옆 소화기 배치", "process": "용접 공사", "accident_type": "화재"},
    "Y-34": {"scenario": "불연성 자재 옆 용접 작업", "process": "용접 공사", "accident_type": "화재"},
    "Y-35": {"scenario": "자재야적장 내 난로 설치 시 소화기 배치", "process": "기타 공사", "accident_type": "화재"},
    "Y-36": {"scenario": "자재야적장 내 산소절단기 배치 시 소화기 배치", "process": "기타 공사", "accident_type": "화재"},
    "Y-37": {"scenario": "위험물 저장소 외부 소화기 배치", "process": "기타 공사", "accident_type": "화재"},
    "Y-38": {"scenario": "위험물 저장소 외부 불연성 자재 배치", "process": "기타 공사", "accident_type": "화재"},
    "Y-39": {"scenario": "원형톱 작업 시 소화기 배치 (불티비산방지막)", "process": "절삭 공사", "accident_type": "화재"},
    "Y-40": {"scenario": "불연성 자재 옆 원형톱 작업", "process": "절삭 공사", "accident_type": "화재"},
    "Y-41": {"scenario": "동바리 버팀 장치 설치", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "Y-42": {"scenario": "거푸집 버팀 장치 설치", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "Y-43": {"scenario": "말비계 위 자재 및 공구 정상 적치", "process": "조적, 미장, 방수공사", "accident_type": "전도"},
    "Y-44": {"scenario": "말비계 정상 설치", "process": "조적, 미장, 방수공사", "accident_type": "전도"},
    "Y-45": {"scenario": "콘크리트 펌프카 안전 장치 설치", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "Y-46": {"scenario": "콘크리트 펌프카 작업 시 신호수 배치", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "Y-47": {"scenario": "오거 크레인 작업 시 안전 장치 설치", "process": "토공사", "accident_type": "전도"},
    "Y-48": {"scenario": "오거 크레인 작업 시 신호수 배치", "process": "토공사", "accident_type": "전도"},
    "Y-49": {"scenario": "지게차 신호수 배치", "process": "화물 운반 공사", "accident_type": "전도"},
    "Y-50": {"scenario": "지게차 운전자 시야 미만 자재 적재", "process": "화물 운반 공사", "accident_type": "전도"},
    "N-01": {"scenario": "시스템 비계 작업발판 설치 불량", "process": "비계 공사", "accident_type": "추락"},
    "N-02": {"scenario": "개폐형 발판이 열려 있는 상황", "process": "비계 공사", "accident_type": "추락"},
    "N-03": {"scenario": "개구부 덮개 설치 불량", "process": "개구부 공사", "accident_type": "추락"},
    "N-04": {"scenario": "개구부 안전난간 설치 불량", "process": "개구부 공사", "accident_type": "추락"},
    "N-05": {"scenario": "단부에서 안전난간 설치 불량", "process": "외벽 공사", "accident_type": "추락"},
    "N-06": {"scenario": "단부에서 수직 방지망 설치 불량", "process": "외벽 공사", "accident_type": "추락"},
    "N-07": {"scenario": "이동식 비계 안전난간 설치 불량", "process": "조적, 미장, 방수공사", "accident_type": "추락"},
    "N-08": {"scenario": "이동식 비계 발판위 간이 사다리 설치", "process": "조적, 미장, 방수공사", "accident_type": "추락"},
    "N-09": {"scenario": "사다리 적재물 위 설치", "process": "사다리 공사", "accident_type": "추락"},
    "N-10": {"scenario": "사다리 최상단에서 작업", "process": "사다리 공사", "accident_type": "추락"},
    "N-11": {"scenario": "시스템 비계 위 낙하 위험물 배치", "process": "비계 공사", "accident_type": "낙하"},
    "N-12": {"scenario": "시스템 비계 상하 위치 동시작업(2인 작업)", "process": "비계 공사", "accident_type": "낙하"},
    "N-13": {"scenario": "출입구 방호선반 설치 불량", "process": "외벽 공사", "accident_type": "낙하"},
    "N-14": {"scenario": "낙하물 방지망 설치 불량", "process": "외벽 공사", "accident_type": "낙하"},
    "N-15": {"scenario": "거푸집 단부 위 적재물 배치", "process": "거푸집 공사", "accident_type": "낙하"},
    "N-16": {"scenario": "거푸집 설치 및 해체 상하 위치 동시작업(2인 작업)", "process": "거푸집 공사", "accident_type": "낙하"},
    "N-17": {"scenario": "사다리차 비정상 과적재", "process": "화물 운반 공사", "accident_type": "낙하"},
    "N-18": {"scenario": "사다리차 작업 시 신호수 미배치", "process": "화물 운반 공사", "accident_type": "낙하"},
    "N-19": {"scenario": "이동식 크레인 작업 시 신호수 미배치", "process": "양중 작업", "accident_type": "낙하"},
    "N-20": {"scenario": "이동식 크레인 작업 시 철제 인양박스 미사용", "process": "양중 작업", "accident_type": "낙하"},
    "N-21": {"scenario": "관로공사 시 신호수 미배치", "process": "관로 공사", "accident_type": "협착"},
    "N-22": {"scenario": "굴삭기 자재 양중 시 신호수 미배치", "process": "관로 공사", "accident_type": "협착"},
    "N-23": {"scenario": "시저형 고소작업대 과상승방지봉 설치높이 미준수", "process": "고소작업대 공사", "accident_type": "협착"},
    "N-24": {"scenario": "고소작업대 위험 반경 내 근로자 작업", "process": "고소작업대 공사", "accident_type": "협착"},
    "N-25": {"scenario": "덤프 트럭 작업 시 신호수 미배치", "process": "화물 운반 공사", "accident_type": "협착"},
    "N-26": {"scenario": "덤프 트럭 위험 반경 내 근로자 작업", "process": "화물 운반 공사", "accident_type": "협착"},
    "N-27": {"scenario": "굴삭기 작업 시 신호수 미배치", "process": "토공사", "accident_type": "협착"},
    "N-28": {"scenario": "굴삭기 수평 위험 반경 내 작업", "process": "토공사", "accident_type": "협착"},
    "N-29": {"scenario": "레미콘 작업 시 신호수 미배치", "process": "콘크리트 타설 공사", "accident_type": "협착"},
    "N-30": {"scenario": "레미콘 위험 반경 내 근로자 작업", "process": "콘크리트 타설 공사", "accident_type": "협착"},
    "N-31": {"scenario": "실내 마감 작업 시 이동형 환풍기 미설치", "process": "실내 마감 공사", "accident_type": "화재"},
    "N-32": {"scenario": "실내 마감 작업 시 근처 난로 설치", "process": "실내 마감 공사", "accident_type": "화재"},
    "N-33": {"scenario": "용접기 옆 소화기 미배치", "process": "용접 공사", "accident_type": "화재"},
    "N-34": {"scenario": "인화성 자재 옆 용접 작업", "process": "용접 공사", "accident_type": "화재"},
    "N-35": {"scenario": "자재야적장 내 난로 설치 시 소화기 미배치", "process": "기타 공사", "accident_type": "화재"},
    "N-36": {"scenario": "자재야적장 내 산소절단기 배치 시 소화기 미배치", "process": "기타 공사", "accident_type": "화재"},
    "N-37": {"scenario": "위험물 저장소 외부 소화기 미배치", "process": "기타 공사", "accident_type": "화재"},
    "N-38": {"scenario": "위험물 저장소 외부 인화성 자재 배치", "process": "기타 공사", "accident_type": "화재"},
    "N-39": {"scenario": "원형톱 작업 시 소화기 미배치 (불티비산방지막)", "process": "절삭 공사", "accident_type": "화재"},
    "N-40": {"scenario": "원형톱 작업시 인화성 자재 배치", "process": "절삭 공사", "accident_type": "화재"},
    "N-41": {"scenario": "동바리 버팀 장치 설치 불량", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "N-42": {"scenario": "거푸집 버팀 장치 설치 불량", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "N-43": {"scenario": "말비계 위 적재물 끝단 적치", "process": "조적, 미장, 방수공사", "accident_type": "전도"},
    "N-44": {"scenario": "말비계 적재물 위 설치", "process": "조적, 미장, 방수공사", "accident_type": "전도"},
    "N-45": {"scenario": "콘크리트 펌프카 안전 장치 불량", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "N-46": {"scenario": "콘크리트 펌프카 작업 시 신호수 미배치", "process": "콘크리트 타설 공사", "accident_type": "전도"},
    "N-47": {"scenario": "오거 크레인 작업 시 안전 장치 불량", "process": "토공사", "accident_type": "전도"},
    "N-48": {"scenario": "오거 크레인 작업시 신호수 미배치", "process": "토공사", "accident_type": "전도"},
    "N-49": {"scenario": "지게차 신호수 미배치", "process": "화물 운반 공사", "accident_type": "전도"},
    "N-50": {"scenario": "지게차 운전자 시야 초과 자재 과적재", "process": "화물 운반 공사", "accident_type": "전도"},
    "C-01": {"scenario": "타워크레인 양중 작업", "process": "양중 작업", "accident_type": "주의 요망 작업"},
    "C-02": {"scenario": "롤러 차량 작업", "process": "토공사", "accident_type": "주의 요망 작업"},
    "C-03": {"scenario": "상하차 하역 작업", "process": "화물 운반 공사", "accident_type": "주의 요망 작업"},
    "C-04": {"scenario": "방수 작업(페인트 작업)", "process": "조적, 미장, 방수공사", "accident_type": "주의 요망 작업"},
    "C-05": {"scenario": "항타기 작업", "process": "토공사", "accident_type": "주의 요망 작업"},
}

@v1_router.post("/detect")
async def detect(file : UploadFile):
    """
    원본 이미지를 유지하고, 추론 결과(박스 등)를 그려 넣은 이미지를
    좌우로 합쳐 반환하는 예시입니다.
    """
    
    # 1. 이미지 불러오기
    contents = await file.read()
    np_arr = np.frombuffer(contents, np.uint8)
    original_image = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

    # 2. 추론 실행
    result = inference_detector(model, original_image)

    # 3. 결과 시각화
    temp_input_path = f"images/{file.filename}"
    temp_output_path = f"images/{file.filename.split('.')[0]}_AI.jpg"
    cv2.imwrite(temp_input_path, original_image)
    model.show_result(temp_input_path, result, out_file=temp_output_path)

    # 4. 결과 이미지 로드
    overlay_image = cv2.imread(temp_output_path)

    # 5. 원본과 추론 결과 이미지를 좌우로 결합
    # hconcat: 좌우로 붙이기, vconcat: 위아래로 붙이기
    combined_image = cv2.hconcat([original_image, overlay_image])
    
    # 6. 결합된 이미지를 JPEG로 인코딩해 반환
    _, buffer = cv2.imencode(".jpg", combined_image)
    
    # 7. images 폴더에 저장
    temp_buffer_path = f"images/{file.filename.split('.')[0]}_AI_COMBINED.jpg"
    cv2.imwrite(temp_buffer_path, combined_image)

    # 8. 바운딩박스 / 클래스 등의 정보 추출 후 images/ 폴더에 저장
    detection_info = []
    for class_idx, bboxes in enumerate(result[0]):
        class_name = model.CLASSES[class_idx]
        for bbox in bboxes:
            x1, y1, x2, y2, score = bbox
            # score가 일정 threshold 이상일 때만 추가하고 싶다면 조건문 사용
            if score >= 0.5:  # 예: confidence threshold=0.3
                detection_info.append({
                    "class": class_name,
                    "scenario": scenario_mapping.get(class_name),
                    "bbox": [float(x1), float(y1), float(x2), float(y2)],
                    "score": float(score)
                })

    json_str = json.dumps(detection_info, ensure_ascii=False, indent=4)
    temp_txt_path = f"images/{file.filename.split('.')[0]}_AI.txt"
    with open(temp_txt_path, "w", encoding='utf-8') as f:
        f.write(json_str + '\n')  # 마지막에 줄바꿈 추가

    encoded_file = base64.b64encode(contents).decode('utf-8')
    client = OpenAI(api_key=settings.OPENAI_CHAT_API_KEY)
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": "건설현장 이미지입니다. 건설현장 위험 분석을 시도하고 있습니다. 위험요소가 있으면 설명하고 없으면 없다고 말해주세요."},
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{encoded_file}",
                        }
                    },
                ],
            }
        ],
        max_tokens=300,
    )

    # html 만들기
    # 상단에 temp_input_path 다음에 temp_output_path 이미지를 넣어서 보여주고 다음에 temp_txt_path에 있는 내용을 보여주기
    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Detection Results</title>
    </head>
    <body>
        <h3>Detection Results</h3>
        <img src="http://{CLIENT_IP}/{temp_buffer_path}" alt="Original Image" style="max-width:1200px; height:auto;">
        <h4>Vistion Information</h4>
        {response.choices[0].message.content}
        <h4>Detection Information</h4>
        <pre>{json_str}</pre>
        
    </body>
    </html>
    """
    # html_content를 파일로 저장
    html_file_path = f"images/{file.filename.split('.')[0]}_AI.html"
    with open(html_file_path, "w", encoding='utf-8') as f:
        f.write(html_content)

    # image_extensions = ['.jpg', '.jpeg', '.png', '.gif', '.bmp', '.svg']
    image_extensions = ['_COMBINED.jpg']

    # 현재 폴더에서 모든 파일을 찾고 이미지 파일만 필터링
    image_files = [f for f in os.listdir('images') if any(f.endswith(ext) for ext in image_extensions)]

    # HTML 파일 생성
    html_content = """
    <!DOCTYPE html>
    <html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>모든 이미지 파일</title>
    </head>
    <body>
        <h1>이미지 파일</h1>
        <div>
    """

    # 이미지 태그 생성
    for image in image_files:
        image_name = image.split('.')[0]
        image_name2 = image_name.replace('_AI_COMBINED', '')
        image_name3 = image_name2.replace('_AI', '')
        html_content += f'<a href="{image_name3}_AI.html" target="_self"><img src="{image}" alt="{image}" width="1200px"></a><br>\n'
    html_content += """
        </div>
    </body>
    </html>
    """

    # HTML 파일 저장
    photos_file_path = f"images/photos.html"
    with open(photos_file_path, "w", encoding='utf-8') as f:
        f.write(html_content)

    return {"url1": f'{CLIENT_IP}/{photos_file_path}',
            "url2": f'{CLIENT_IP}/{temp_output_path}',
            "url3": f'{CLIENT_IP}/{temp_txt_path}',
            "url4": f'{CLIENT_IP}/{html_file_path}',
            "url4": f'{CLIENT_IP}/{html_file_path}',
            }

# @v1_router.post("/imageal")
# async def imageal(file : UploadFile):
# # file : UploadFile 에서 사용자에게 이미지를 받은 후 해당 이미지를 model에 넣어서 결과를 반환하는 함수

#     # 업로드된 파일을 읽어서 메모리에 로드
#     contents = await file.read()

#     # NumPy 배열로 변환 후 OpenCV 이미지를 디코딩
#     np_arr = np.frombuffer(contents, np.uint8)
#     img = cv2.imdecode(np_arr, cv2.IMREAD_COLOR)

#     # =========================================
#     # 3. 추론 실행
#     # =========================================
#     result = inference_detector(model, img)

#     # =========================================
#     # 4. 결과 시각화: 결과 이미지를 임시 파일로 저장
#     # =========================================
#     # show_result의 첫 번째 인자로 파일 경로 대신 이미지를 바로 넣으려면
#     # 일부 버전에서 np.ndarray 처리가 안 될 수 있으므로,
#     # model.show_result(..., show=False) 형태로 사용이 필요합니다.
#     # 혹은 아래처럼 임시 파일 경로로 cv2.imwrite 한 뒤에 불러오는 방식을 쓰셔도 됩니다.
#     temp_input_path = "temp_input.jpg"
#     temp_output_path = "temp_output.jpg"
#     temp_input_path = f"images/{file.filename}"
#     temp_output_path = f"images/{file.filename.split('.')[0]}_AI.jpg"

#     cv2.imwrite(temp_input_path, img)

#     # show_result에서 ndarray 사용이 가능하다면 다음처럼 직접 사용도 가능합니다.
#     # model.show_result(img, result, out_file=temp_output_path, show=False)

#     # 만약 show_result가 파일 경로만 받을 경우:
#     # model.show_result(temp_input_path, result, out_file=temp_output_path)
#     model.show_result(temp_input_path, result, out_file=temp_output_path, score_thr=0.5)

#     # 추론 결과가 그려진 이미지를 다시 읽어서 바이너리로 만들기
#     with open(temp_output_path, "rb") as f:
#         result_img = f.read()

#     # 결과 이미지를 스트림 형태로 반환
#     for i, res in enumerate(result[0]):
#         if len(res) > 0:
#             print(f'{i}: {len(res)} {model.CLASSES[i]}')
#     # model.CLASSES[i]를 텍스트로 반환
#     # 최종반환: 모델 결과 이미지 + model.CLASSES[i]를 텍스트

#     return StreamingResponse(io.BytesIO(result_img), media_type="image/jpeg")

# from mmdet.apis import init_detector, inference_detector

# # 경로 설정
# config_file = '/app/mmdetection/configs/spinenet/class_spinenet_final_cycle.py'
# checkpoint_file = '/app/mmdetection/work_dirs/final_cycle/spinenet/epoch_55.pth'  # 모델 체크포인트 경로
# image_path = '/app/mmdetection/data/final_cycle/test/H-220607_B16_Y-14_001_0002.jpg'       # 테스트할 이미지 경로

# # 모델 초기화
# model = init_detector(config_file, checkpoint_file, device='cpu')

# # 추론 실행
# result = inference_detector(model, image_path)

# # 결과 시각화 및 저장
# output_file = '/app/result.jpg'
# model.show_result(image_path, result, out_file=output_file)

# print(f"결과가 저장되었습니다: {output_file}")