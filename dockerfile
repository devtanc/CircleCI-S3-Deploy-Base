FROM circleci/node:chakracore

USER root

RUN apt-get update && apt-get install -y python3 python3-pip

RUN pip3 install awscli --upgrade --user
