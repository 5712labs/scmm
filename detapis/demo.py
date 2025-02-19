# docker build -t scmm .
# docker run -d -it --name scmmcon -p 8001:8001 -v .:/app scmm
# docker exec -it scmmcon /bin/bash
# python /app/demo.py

# https://www.aihub.or.kr/aihubdata/data/view.do?currMenu=115&topMenu=100&aihubDataSe=data&dataSetSn=71407
# docker load –i spinenet_final_cycle.tar
# docker run -d -it --name spinenetcon -p 8000:8000 -v .:/app spinenet
# docker exec -it spinenetcon /bin/bash

# cp -r app/mmdetection/work_dirs/ mmdetection/
# cp -r app/mmdetection/configs/ mmdetection/
# cp -r app/mmdetection/data/ mmdetection/
# cp -r spineNet/mmdet/ mmdetection/

# pip install --upgrade pip
# pip install -r requirements.txt 

# python /app/demo.py configs/spinenet/class_spinenet_final_test.py work_dirs/final_cycle/spinenet/epoch_55.pth --show --show-dir results_dir --format-only

from mmdet.apis import init_detector, inference_detector

# 경로 설정
config_file = '/app/mmdetection/configs/spinenet/class_spinenet_final_cycle.py'
checkpoint_file = '/app/mmdetection/work_dirs/final_cycle/spinenet/epoch_55.pth'  # 모델 체크포인트 경로
image_path = '/app/mmdetection/data/final_cycle/test/H-220607_B16_Y-14_001_0002.jpg'       # 테스트할 이미지 경로

# 모델 초기화
model = init_detector(config_file, checkpoint_file, device='cpu')

# 추론 실행
result = inference_detector(model, image_path)

# 결과 시각화 및 저장
output_file = '/app/result.jpg'
model.show_result(image_path, result, out_file=output_file)

print(f"결과가 저장되었습니다: {output_file}")