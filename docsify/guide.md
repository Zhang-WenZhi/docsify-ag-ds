# docsify 介绍

> docsify 是一个动态生成文档网站的工具。不同于 GitBook、Hexo 之类的工具，它不会生成静态的 `.html` 文件，而是运行一个本地服务器动态生成。

## 简单上手

```bash
# 初始化项目
npx docsify init ./docs

# 然后开始写作吧！
docsify serve docs
```
## 项目结构

```
.
├── docs
│   ├── guide.md
│   └── README.md
└── index.html
```

## 项目结构 解释

- `docs` 目录用来存放文档内容，`.md` 文件即文档源文件。
- `index.html` 是文档的入口文件，你可以把它理解为一个导航页，通过它可以进入各个文档页面。

## 项目结构 生成

```
.
├── docs
│   ├── guide.md
│   └── README.md
└── index.html
```
## 项目结构 生成 解释

- `docs` 目录用来存放文档内容，`.md` 文件即文档源文件。
- `index.html` 是文档的入口文件，你可以把它理解为一个导航页，通过它可以进入各个文档页面。