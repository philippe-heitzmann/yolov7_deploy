# yolov7_deploy

Objective:
- Deploy YOLOv7 model using Triton inference server per (ref)[https://github.com/WongKinYiu/yolov7/tree/main/deploy/triton-inference-server]

## Docker 
```
docker build -t yolov7:v1 .
docker run -it --shm-size=64G -p 8888:8888 --rm -e DEVICE=gpu -v C:\Users\phil0\DS\yolov7_deploy:/app --name yolov7_v1 yolov7:v1 jupyter notebook --port=8888 --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.token=''
# Tensorrt image
docker run --shm-size=64G -it --rm --gpus=all nvcr.io/nvidia/tensorrt:22.06-py3
docker cp ./yolov7/weights/yolov7.onnx <container_ID>:/workspace
example: docker cp ./yolov7/weights/yolov7.onnx bda96989d142d29a6a50856f4fdb5572309f2ebe311ed3d6234923c324f0abd6:/workspace/
./tensorrt/bin/trtexec --onnx=yolov7.onnx --minShapes=images:1x3x640x640 --optShapes=images:16x3x640x640 --maxShapes=images:16x3x640x640 --fp16 --workspace=4096 --saveEngine=yolov7-fp16-1x8x8.engine --timingCacheFile=timing.cache
./tensorrt/bin/trtexec --onnx=yolov7.onnx --fp16 --workspace=4096 --saveEngine=yolov7-fp16-1x8x8.engine --timingCacheFile=timing.cache

# Copy engine 
docker cp bda96989d142d29a6a50856f4fdb5572309f2ebe311ed3d6234923c324f0abd6:/workspace/yolov7-fp16-1x8x8.engine .
# Setup engine
mv ./yolov7/weights/yolov7-fp16-1x8x8.engine ./models/yolov7/1/model.plan

# Start server 
docker run --gpus all --rm --ipc=host --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -p 8000:8000 -p 8001:8001 -p 8002:8002 -v $(pwd)/models:/models nvcr.io/nvidia/tritonserver:22.06-py3 --name tritonserver --model-repository=/models --strict-model-config=false --log-verbose 1

#Windows powershell
docker run --gpus all --rm --ipc=host --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -p 8000:8000 -p 8001:8001 -p 8002:8002 -v C:\Users\phil0\DS\yolov7_deploy\models:/models nvcr.io/nvidia/tritonserver:22.06-py3 tritonserver --model-repository=/models --strict-model-config=false --log-verbose 1

# WSL
docker run --gpus all --rm --ipc=host --shm-size=1g --ulimit memlock=-1 --ulimit stack=67108864 -p 8000:8000 -p 8001:8001 -p 8002:8002 -v /mnt/c/Users/phil0/DS/yolov7_deploy/models:/models nvcr.io/nvidia/tritonserver:22.06-py3 tritonserver --model-repository=/models --strict-model-config=false --log-verbose 1

# Start client 
# following https://github.com/triton-inference-server/server
# Step 3: Sending an Inference Request 
# In a separate console, launch the image_client example from the NGC Triton SDK container
docker run -it --rm --net=host nvcr.io/nvidia/tritonserver:22.10-py3-sdk

/workspace/install/bin/image_client -m yolov7 -c 3 -s INCEPTION /workspace/images/mug.jpg

#  "C:\\Users\\phil0\\anaconda3\\envs\\py38_triton2\\python.exe"
```

## Export weights
!python 