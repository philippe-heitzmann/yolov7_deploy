FROM nvcr.io/nvidia/pytorch:21.08-py3

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR /app
COPY . /app

RUN apt-get update && apt-get install -y openssh-client vim zip htop screen libgl1-mesa-glx sudo

RUN pip install -r requirements.txt

EXPOSE 3000
CMD unicorn app.app:app --host 0.0.0.0 --port 3000