FROM node:16.3.0-alpine

WORKDIR /usr/src/file-server

COPY ./file-server .

RUN npm install --force

RUN mkdir videos

ENV API_SERVER_URL=https://storagechain-stg-be.invo.zone/api
ENV APP_PORT=3008
ENV TOTAL_STORAGE=100

EXPOSE 3008

CMD [ "npm", "start" ]