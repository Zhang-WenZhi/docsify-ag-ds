# docsify-ag-ds
数据结构与算法

#### docsify 创建启动

```text
npm 方式：
npm i docsify-cli -g
docsify init ./docs
docsify serve docs

手动建立.html的方式启动：
cd docs && python -m SimpleHTTPServer 3000 ---- SimpleHTTPServer pypi.org 已经搜不到
cd docs && python -m http.server 3000 ---- pypi.org 已经搜不到，但是http进入标准库了
```

#### ci.yml

```shell
git push --set-upstream origin gh-pages
```

```text
name: docsify-ag-ds

on:
  push:
    branches:
      - gh-pages
  pull_request:
    branches:
      - gh-pages

jobs:
  build:

    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2
    - name: Use Node.js
      uses: actions/setup-node@v1
      with:
        node-version: '12'
    - name: Install dependencies
      run: npm ci
    - name: Build
      run: npm install && npm build
    - name: Deploy
      uses: Zhang-WenZhi/docsify-ag-ds@gh-pages
      with:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        BRANCH: gh-pages # The branch the action should deploy to.
        FOLDER: docs/.vuepress/dist # The folder the action should deploy.
        run: docsify serve docs
```

#### npm init -y

```json
{
  "name": "docsify-ag-ds",
  "version": "1.0.0",
  "description": "数据结构与算法",
  "main": "index.js",
  "directories": {
    "doc": "docs"
  },
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "keywords": [],
  "author": "",
  "license": "ISC"
}
```

#### 合并

```shell
git checkout main
git merge gh-pages
git push --set-upstream origin main
```

