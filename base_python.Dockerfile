FROM ubuntu
MAINTAINER Aidan OFlannagain

RUN apt-get update
RUN apt-get install -y python-pip python-dev build-essential
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv

CMD ["/bin/bash"]