FROM node:16.3.0-alpine

WORKDIR /usr/src/file-server

COPY . .

RUN npm install --force

RUN mkdir videos

ENV API_SERVER_URL=https://api.storagechain.io/api
ENV APP_PORT=3008
ENV ENV=production

EXPOSE 3008

CMD [ "npm", "start" ]
