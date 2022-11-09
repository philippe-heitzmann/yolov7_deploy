# yolov7_deploy

Objective:
- Deploy YOLOv7 model using Triton inference server per (ref)[https://github.com/WongKinYiu/yolov7/tree/main/deploy/triton-inference-server]

## Docker run
```
docker build -t yolov7:v1 .
docker run -it --shm-size=64G -p 8888:8888 --rm -e DEVICE=gpu -v .:/app --name yolov7_v1 yolov7:v1
# Run a jupyter notebook within container:
jupyter notebook --port=8888 --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.token=''
```

## Export weights
!python 