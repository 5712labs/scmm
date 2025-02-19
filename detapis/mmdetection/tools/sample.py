# python tools/main.py configs/spinenet/class_spinenet_final_cycle.py work_dirs/final_cycle/spinenet/epoch_55.pth --show-dir results_dir
import argparse
import os
import mmcv
import torch
from mmcv import Config
from mmcv.parallel import collate, scatter
from mmcv.runner import load_checkpoint
from mmdet.apis import init_detector, inference_detector, show_result_pyplot
from mmdet.datasets import replace_ImageToTensor
from mmdet.datasets.pipelines import Compose
from mmdet.models import build_detector

def parse_args():
    parser = argparse.ArgumentParser(description='MMDetection single image inference')
    parser.add_argument('config', help='test config file path')
    parser.add_argument('checkpoint', help='checkpoint file path')
    parser.add_argument('--img-dir', help='Image directory', default='data/final_cycle/test')
    parser.add_argument('--show-dir', help='directory to save visualization results', default='results_dir')
    parser.add_argument('--score-thr', type=float, default=0.3, help='score threshold')
    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    # config 파일 로드
    cfg = Config.fromfile(args.config)
    
    # 모델 빌드
    model = init_detector(cfg, args.checkpoint, device='cuda:0' if torch.cuda.is_available() else 'cpu')
    
    # 결과 저장 디렉토리 생성
    mmcv.mkdir_or_exist(args.show_dir)
    
    # 이미지 디렉토리에서 이미지 파일 목록 가져오기
    img_files = []
    for img_name in os.listdir(args.img_dir):
        if img_name.lower().endswith(('.jpg', '.jpeg', '.png', '.bmp')):
            img_files.append(os.path.join(args.img_dir, img_name))
    
    # 각 이미지에 대해 추론 실행
    for img_file in img_files:
        # 추론 실행
        result = inference_detector(model, img_file)

        # 결과 시각화 및 저장
        out_file = os.path.join(args.show_dir, os.path.basename(img_file))
        model.show_result(
            img_file,
            result,
            score_thr=args.score_thr,
            show=True,
            out_file=out_file
        )
        print(f'Result saved to {out_file}')
        for i, res in enumerate(result[0]):
            if len(res) > 0:
              print(f'{i}: {len(res)} {model.CLASSES[i]}')

if __name__ == '__main__':
    main()