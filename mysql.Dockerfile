FROM mysql
MAINTAINER Aidan OFlannagain

RUN apt-get update
ENV MYSQL_ROOT_PASSWORD=my-secret-pw

CMD ["/bin/bash"]