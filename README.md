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

#### 远程关联git仓

```shell
git remote add origin https://github.com/xxx/docsify-ag-ds.git
```

#### Github Actions

```shell
on: push

jobs:
    job1:
        runs-on: ubuntu-latest
        steps:
        - run: pwd
        - run: ls
    job2:
        runs-on: windows-latest
        steps:
        - run: node --version
```

```shell
name: 打包docsify项目
on: push

permissions:
  contents: write

jobs:
  npm-build:
    name: npm-build工作
    runs-on: ubuntu-latest

    steps:
    - name: 读取仓库内容
      uses: actions/checkout@v4

    - name: 安装依赖和项目打包
      run:
        npm install

    - name: 部署
      uses: JamesIves/github-pages-deploy-action@v4
      with:
        ACCESS_TOKEN: ${{ secrets.ACCESS_TOKEN }}
        BRANCH: gh-pages
        FOLDER: docs
        BUILD_SCRIPT: docsify serve docs
```

#### Docker Hub镜像地址

```shell
https://hub.docker.com/
https://docker.mirrors.ustc.edu.cn
```
