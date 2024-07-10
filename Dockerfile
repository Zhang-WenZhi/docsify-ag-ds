FROM node:18-alpine

WORKDIR /docsify-ag-ds

COPY docs /docsify-ag-ds/docs
COPY package.json/ /docsify-ag-ds/package.json
COPY package-lock.json/ /docsify-ag-ds/package-lock.json

RUN npm install

CMD [ "docsify", "serve", "docs" ]