FROM node:9.11.1-slim

COPY ./package.json /app/package.json
COPY ./wait-for-it.sh /tmp/wait-for-it.sh
COPY ./runtest.sh /app/runtest.sh

RUN cd /app && yarn install \
    && chmod +x /tmp/wait-for-it.sh \
    && chmod +x /app/runtest.sh

WORKDIR /app
EXPOSE 4567
