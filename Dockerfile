FROM nvcr.io/nvidia/pytorch:21.08-py3
# FROM nvcr.io/nvidia/tritonserver:22.06-py3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y openssh-client vim zip htop screen libgl1-mesa-glx sudo

RUN pip install -r requirements.txt

# EXPOSE 8000 8001 8002
# CMD tritonserver --model-repository=/models --strict-model-config=false --log-verbose 1