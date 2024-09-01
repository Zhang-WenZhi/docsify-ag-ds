




## 空.git项目上传远程仓库

指定 git init 的分支名
1. 可以指定初始化的分支：git init -b master

2. 还可以全局设置：
git config --global init.defaultBranch master


```shell
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git branch -m main
致命错误：不是 git 仓库（或者任何父目录）：.git
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git init
提示： 使用 'master' 作为初始分支的名称。这个默认分支名称可能会更改。要在新仓库中
提示： 配置使用初始分支名，并消除这条警告，请执行：
提示：
提示：  git config --global init.defaultBranch <名称>
提示：
提示： 除了 'master' 之外，通常选定的名字有 'main'、'trunk' 和 'development'。
提示： 可以通过以下命令重命名刚创建的分支：
提示：
提示：  git branch -m <name>
已初始化空的 Git 仓库于 /Users/zhangwenzhi/NewProjects/preact-vite-wenzhi/.git/
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git branch -m main
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git branch
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git remote add origin https://gitee.com/loyalty-code/preact-vite-wenzhi.git
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git pull origin main:main
remote: Enumerating objects: 5, done.
remote: Counting objects: 100% (5/5), done.
remote: Compressing objects: 100% (5/5), done.
remote: Total 5 (delta 0), reused 0 (delta 0), pack-reused 0
展开对象中: 100% (5/5), 2.73 KiB | 399.00 KiB/s, 完成.
来自 https://gitee.com/loyalty-code/preact-vite-wenzhi
 * [新分支]          main       -> main
 * [新分支]          main       -> origin/main
错误：工作区中下列未跟踪的文件将会因为合并操作而被覆盖：
        README.md
请在合并前移动或删除。
正在终止
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git pull origin main:main
已经是最新的。
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git branch
* main
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git push --set-upstream origin main
分支 'main' 设置为跟踪 'origin/main'。
Everything up-to-date
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git add .
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git commit -m "INIT"
[main 50316a4] INIT
 19 files changed, 3674 insertions(+), 96 deletions(-)
 create mode 100644 .gitignore
 delete mode 100644 LICENSE
 create mode 100644 README-preact.md
 delete mode 100644 README.en.md
 delete mode 100644 README.md
 create mode 100644 README.zh-CN.md
 create mode 100644 index.html
 create mode 100644 package.json
 create mode 100644 pnpm-lock.yaml
 create mode 100644 public/vite.svg
 create mode 100644 src/assets/preact.svg
 create mode 100644 src/components/Header.tsx
 create mode 100644 src/index.tsx
 create mode 100644 src/pages/Home/index.tsx
 create mode 100644 src/pages/Home/style.css
 create mode 100644 src/pages/_404.tsx
 create mode 100644 src/style.css
 create mode 100644 tsconfig.json
 create mode 100644 vite.config.ts
zhangwenzhi@zhangwezhideMBP preact-vite-wenzhi % git push --set-upstream origin main
枚举对象中: 25, 完成.
对象计数中: 100% (25/25), 完成.
使用 8 个线程进行压缩
压缩对象中: 100% (21/21), 完成.
写入对象中: 100% (24/24), 42.41 KiB | 10.60 MiB/s, 完成.
总共 24（差异 0），复用 0（差异 0），包复用 0（来自  0 个包）
remote: Powered by GITEE.COM [1.1.5]
remote: Set trace flag f747e996
To https://gitee.com/loyalty-code/preact-vite-wenzhi.git
   2c8eda5..50316a4  main -> main
分支 'main' 设置为跟踪 'origin/main'。
```

## vite 创建preact项目

npm init preact/pnpm creat preact

```shell
zhangwenzhi@zhangwezhideMBP NewProjects % pnpm init preact
 ERR_PNPM_INIT_ARG  init command does not accept any arguments

Maybe you wanted to run "pnpm create preact"
zhangwenzhi@zhangwezhideMBP NewProjects % pnpm create  preact
.../191ab165f1e-1407                     | Progress: resolved 1, reused 0, downl.../191ab165f1e-1407                     | Progress: resolved 16, reused 7, down.../191ab165f1e-1407                     |  +23 ++
.../191ab165f1e-1407                     | Progress: resolved 16, reused 7, down.../191ab165f1e-1407                     | Progress: resolved 23, reused 14, dow.../191ab165f1e-1407                     | Progress: resolved 23, reused 14, downloaded 9, added 23, done
┌  Preact - Fast 3kB alternative to React with the same modern API
│
◇  Project directory:
│  preact-vite-wenzhi
│
◇  Project language:
│  TypeScript
│
◇  Use router?
│  Yes
│
◇  Prerender app (SSG)?
│  No
│
◇  Use ESLint?
│  Yes
│
◇  Set up project directory
│
◇  Installed project dependencies
│
◇  Getting Started ─────────╮
│                           │
│  $ cd preact-vite-wenzhi  │
│  $ pnpm dev               │
│                           │
├───────────────────────────╯
│
└  You're all set!

zhangwenzhi@zhangwezhideMBP NewProjects % cd preact-vite-wenzhi
```

```shell
pnpm dev
pnpm build
pnpm preview
```

## 一文搞懂：什么是SSR、SSG、CSR？前端渲染技术全解析

https://segmentfault.com/a/1190000044882791

`一、CSR（客户端渲染）`

示例（使用React）：
```jsx
// 假设有一个React组件
import React from 'react';

function MyComponent() {
  const [message, setMessage] = React.useState('Hello, CSR!');

  const handleClick = () => {
    setMessage('Clicked!');
  };

  return (
    <div>
      <p>{message}</p>
      <button onClick={handleClick}>Click Me</button>
    </div>
  );
}

// 在HTML文件中引入React和组件的JavaScript文件
// 浏览器加载并执行这些JavaScript，从而渲染页面
```

`二、SSR（服务器端渲染）`

示例（使用React的服务器端渲染）：
```js
// 服务器端代码（Node.js）
const React = require('react');
const ReactDOMServer = require('react-dom/server');
const MyComponent = require('./MyComponent').default; // 假设MyComponent是上面定义的React组件

// 渲染组件为HTML字符串
const html = ReactDOMServer.renderToString(<MyComponent />);

// 将HTML字符串发送给客户端
// ...（这里省略了HTTP服务器和响应发送的代码）
```

`三、SSG（静态站点生成）`

示例（使用Nunjucks模板引擎）：
模板文件（index.njk）：
```html
<!DOCTYPE html>
<html>
<head>
  <title>My Static Site</title>
</head>
<body>
  <h1>{{ message }}</h1>
</body>
</html>
```

构建脚本（Node.js）：
```js
const nunjucks = require('nunjucks');
const fs = require('fs');

// 配置Nunjucks模板引擎
nunjucks.configure('views', { autoescape: true });

// 渲染模板
const res = nunjucks.render('index.njk', { message: 'Hello, SSG!' });

// 将渲染结果写入HTML文件
fs.writeFileSync('dist/index.html', res);

// 现在你可以将生成的`dist/index.html`部署到服务器上
```


对于需要丰富`交互效果和实时数据`的场景，可以选择`CSR`；对于需要`优化首屏加载速度和SEO效果`的场景，可以选择`SSR`；而对于`内容更新不频繁、对性能要求高`的场景，可以选择`SSG`。同时，也可以结合使用多种技术来实现更好的用户体验和性能优化。

## @ vite项目设置

`安装依赖 @types/node`
```shell
import path from 'path'; // @types/node
```

`vite.config.ts`

```ts
resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    }
  },
```

`tsconfig.json`

```json
/* @别名配置 */
    "baseUrl": ".",
    "paths": {
      "@/*": [
        "src/*"
      ]
    },
```

## 分块加载大数据

```js
async function loadNovel() {
  const url = 'https://example.com/novel.txt';
  const response = await fetch(url);
  const reader = response.body.getReader();
  
  // 解码
  const decoder = new TextDecoder('utf-8');
  // 死循环
  for (;;) {
    const [value ,done] = await reader.read();
    console.log(value); // 字节数组 文字编码
    if (done) {
      break;
    }
    const text = decoder.decode(value);
    console.log(text); // 文本
    // console.log(text.slice(-5)); // 可能乱码，需要处理
  }
  
}

loadNovel();
```

```js
async function loadNovel() {
  const url = 'https://example.com/novel.txt';
  const response = await fetch(url);
  const reader = response.body.getReader();
  
  // 解码
  const decoder = new TextDecoder('utf-8');

  let remainChunk = new Uint8Array(0);

  // 死循环
  for (;;) {
    const [value ,done] = await reader.read();
    // console.log(value); // 字节数组 文字编码
    if (done) {
      break;
    }
    
    // 查找最后一个换行符
    const lastIndex = value.lastIndexOf(0x0a);

    const chunk = value.slice(0, lastIndex);
    const readChunk = new Uint8Array(remainChunk.length + chunk.length);
    readChunk.set(remainChunk);
    readChunk.set(chunk, remainChunk.length);
    remainChunk = value.slice(lastIndex);
    const text = decoder.decode(readChunk);

    // const text = decoder.decode(value);
    console.log(text); // 文本
    // console.log(text.slice(-5)); // 可能乱码，需要处理
  }
  
}

loadNovel();
```


使用 mergedChunk 来合并剩余的字节数组和新读取的字节数组。
使用 lastIndexOf 方法来查找最后一个换行符。
在处理完所有数据后，处理剩余的字节数组。
这样可以确保逐块读取和解码文本时，正确处理每一行，并避免乱码问题。
```js
async function loadNovel() {
  const url = 'https://example.com/novel.txt';
  const response = await fetch(url);

  const body = response.body;
  if (!body) {
    throw new Error('Response body is null');
  }
  const reader = body.getReader();
  
  // 解码
  const decoder = new TextDecoder('utf-8');

  let remainChunk = new Uint8Array(0);

  // 死循环
  for (;;) {
    const { value, done } = await reader.read();
    if (done) {
      break;
    }
    
    // 合并剩余的字节数组和新读取的字节数组
    const mergedChunk = new Uint8Array(remainChunk.length + value.length);
    mergedChunk.set(remainChunk);
    mergedChunk.set(value, remainChunk.length);

    // 查找最后一个换行符
    const lastIndex = mergedChunk.lastIndexOf(0x0a);

    // 处理完整的行
    if (lastIndex !== -1) {
      const chunk = mergedChunk.slice(0, lastIndex);
      const text = decoder.decode(chunk);
      console.log(text); // 文本

      // 更新剩余的字节数组
      remainChunk = mergedChunk.slice(lastIndex + 1);
    } else {
      // 如果没有找到换行符，则将所有字节数组保留为剩余字节数组
      remainChunk = mergedChunk;
    }
  }

  // 处理剩余的字节数组
  if (remainChunk.length > 0) {
    const text = decoder.decode(remainChunk);
    console.log(text); // 文本
  }
}

loadNovel();

```


ai插件生成：
```js
async function loadNovel() {
  const url = 'https://example.com/novel.txt';
  const response = await fetch(url);
  const reader = response.body.getReader();
  const decoder = new TextDecoder('utf-8');
  let result;
  let chunkSize = 1024;
  let novel = '';

  while (!result.done) {
    result = await reader.read();
    const chunk = decoder.decode(result.value, { stream: !result.done });
    novel += chunk;
    if (novel.length >= chunkSize) {
      // 处理小说数据
      console.log(novel);
      novel = '';
    }
  }
}
```

## turborepo 和 monorepo有啥区别？

turborepo 和 monorepo 是两个相关但不同的概念。以下是它们的区别：

Monorepo
定义：
Monorepo（单一代码库）是一种将多个项目存储在同一个版本控制仓库中的方法。这些项目可以是不同的应用程序、库或服务。

特点：

统一管理：相同的代码库可以共享代码和依赖项，简化管理和协调。
简化版本控制：所有项目在同一个版本历史中，方便追踪和回溯。
跨项目协作：促使团队更容易进行跨项目的协作。
适用场景：

有多个相关项目需要紧密集成时。
需要共享代码或库的情况下。
Turborepo
定义：
Turborepo 是一个用于构建和管理 Monorepo 的工具，它旨在提高大型代码库的构建速度和效率。

特点：
增量构建：Turborepo 允许只构建已更改的部分，减少不必要的构建时间。
缓存：支持缓存构建结果，以加速后续的构建过程。
并行执行：可以并行执行多个任务，提高效率。
集成多种工具：与 npm、Yarn、Webpack、Babel 等工具兼容。
适用场景：

当 monorepo 变得庞大且复杂时，Turborepo 可以优化构建和开发流程。
需要更快地迭代和构建项目的情况下。
总结
Monorepo 是一种管理多个相关项目的仓库结构，而 Turborepo 则是一个工具，用于高效地管理和构建 Monorepo 中的项目。
可以把 `Turborepo 看作是 Monorepo 的一种增强工具，旨在解决构建速度慢和复杂度高的问题`。

## 微前端：wujie 无界框架（腾讯） 基于 WebComponent 容器 + iframe 沙箱

https://wujie-micro.github.io/doc/

演示：https://github.com/Tencent/wujie
vue3主应用：https://wujie-micro.github.io/demo-main-vue/home
react主应用：https://wujie-micro.github.io/demo-main-react/


各个微前端框架优缺点介绍：https://juejin.cn/post/7212603829572911159

```shell
开发环境配置:

Node.js 版本 < 18.0.0 # 16版本
pnpm 脚手架示例模版基于 pnpm + turborepo 管理项目
```





## 微前端：webComponents 样式隔离

```shell
npm install typescript -g
tsc --init # 初始化 tsconfig.json
# 生成一个index.ts文件
tsc -w # 监听文件变化，自动编译成index.js
# 新建index.html文件，引入index.js
# 浏览器打开index.html文件，即可看到效果

```

index.ts
```ts
window.onload = () => {
  class Wujie extends HTMLElement {
    constructor() {
      super();
      // shadowdom // 打开后，就可以进行样式隔离
      let dom = this.attachShadow({ mode: "open" });
      let template = document.querySelector('#wujie') as HTMLTemplateElement
      // 跟dom进行绑定 // true深度克隆
      dom.appendChild(template.content.cloneNode(true))
      // 打印接收的参数
      console.log(this.getAttr('url'), this.getAttr('age'))
    }
    // 接收参数
    private getAttr(attr: string) {
      return this.getAttribute(attr)
    }

    // 生命周期，和vue差不多，常见有下面3个：
    //生命周期自动触发有东西插入
    connectedCallback () {
       console.log('类似于vue 的mounted');
    }
    //生命周期卸载
    disconnectedCallback () {
          console.log('类似于vue 的destory');
    }
    //跟watch类似
    attributeChangedCallback (name:any, oldVal:any, newVal:any) {
        console.log('跟vue 的watch 类似 有属性发生变化自动触发');
    }

    //connectedCallback() {
    //  this.shadowRoot.innerHTML = `
    //    <style>
    //      .wujie {
    //        color: red;
    //      }
    //    </style>
    //    <div class="wujie">wujie</div>
    //  `;
    //}
  }
  // 挂载 // 类似于vue组件，原生js写的组件
    window.customElements.define("wu-jie", Wujie) // 不能用驼峰命名 
}
```

index.html
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Document</title>
  <script src="./index.js"></script>
</head>
<body>
  <!-- 传参 -->
  <wu-jie age="18" url="https://www.baidu.com/"></wu-jie>

  <div>我是外层的div</div>
  
  <template id="wujie">
    <style>
      div {
        background: red;
      }
    </style>
    <div>我是template里面的div</div>
  </template>
</body>
</html>
```

浏览器打开index.html,样式只影响template里面的div，不影响外层的div



## weakMap weakSet用法 弱引用

WeakMap 和 WeakSet 是 JavaScript 中的两种集合类型，它们提供了对对象的弱引用，这意味着如果没有其他引用指向那个对象，它就可以被垃圾回收。

`WeakMap`
特性：
WeakMap 的键必须是对象。
对键的引用是弱引用，这意味着如果没有其他引用指向这个键，相关的键值对将被自动垃圾回收。
不可迭代，这意味着不能使用 for...of 循环遍历它。
使用示例：
```js
// 创建 WeakMap
const weakMap = new WeakMap();

// 创建一个对象作为键
const objKey = { id: 1 };

// 设置键值对
weakMap.set(objKey, 'Value 1');

// 获取值
console.log(weakMap.get(objKey)); // 输出: 'Value 1'

// 删除键值对
weakMap.delete(objKey);

// 检查键是否存在
console.log(weakMap.has(objKey)); // 输出: false

// 如果 objKey 没有其他引用，则它会被垃圾回收

```

`WeakSet`
特性：
WeakSet 的元素必须是对象。
对元素的引用是弱引用，意味着如果没有其他引用指向这个对象，它就会被垃圾回收。
不可迭代。
使用示例：
```js
// 创建 WeakSet
const weakSet = new WeakSet();

// 创建一个对象
const obj = { id: 2 };

// 添加对象到 WeakSet
weakSet.add(obj);

// 检查对象是否存在
console.log(weakSet.has(obj)); // 输出: true

// 删除对象
weakSet.delete(obj);

// 检查对象是否存在
console.log(weakSet.has(obj)); // 输出: false

// 如果 obj 没有其他引用，则它会被垃圾回收

```

总结
WeakMap 用于存储键值对，键是对象，值可以是任何类型。
WeakSet 用于存储对象集合，元素为对象。
由于弱引用的特性，WeakMap 和 WeakSet 可以有效地避免内存泄漏，特别是在处理大量对象时。

## `pnpm import` 转换npm/yarn的lock文件为pnpm的lock文件 git 切换分支

`git push --set-upstream origin fix-apple-20240831` 新建分支并推送远程仓库（远程仓库没有）


切换到远程的分支，并更新：
```shell
zhangwenzhi@zhangwezhideMBP dependency-parse-react % git checkout fix-lenovo-20240620
切换到分支 'fix-lenovo-20240620'
zhangwenzhi@zhangwezhideMBP dependency-parse-react % git pull
当前分支没有跟踪信息。
请指定您要合并哪一个分支。
详见 git-pull(1)。

    git pull <远程> <分支>

如果您想要为此分支创建跟踪信息，您可以执行：

    git branch --set-upstream-to=origin/<分支> fix-lenovo-20240620

zhangwenzhi@zhangwezhideMBP dependency-parse-react % git branch --set-upstream-to=origin/fix-lenovo-20240620 fix-lenovo-20240620
分支 'fix-lenovo-20240620' 设置为跟踪 'origin/fix-lenovo-20240620'。
zhangwenzhi@zhangwezhideMBP dependency-parse-react % git pull
```


## 微前端：qiankun+vite+monorepo+vite-plugin-qiankun+pnpm-workspace

硬连接：`mklink /H ying.js index.js` index.js修改，ying.js也会跟着修改

软连接：`mklink ruan.js index.js` 0k 类似快捷方式，跳转

`pnpm store path` 电脑里存的所有依赖的目录

`pnpm import` 转换npm/yarn的lock文件为pnpm的lock文件

`pnpm store prune` 清理缓存

```shell
# 创建yml文件
pnpm-workspace.yml

# 写入
packages:
  - 'main'
  - 'web/**'

# 主子依赖安装
pnpm install

# 运行子应用
pnpm -F react-demo dev

# 子模块复用技术
common 目录新建
pnpm init
pnpm-workspace.yml 加入 - 'common'
# 给主应用添加common
pnpm -F main add common

```


## vite 打包目录 头条搜索

```ts
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [
    vue(),
  ],
  build: {
    rollupOptions:{
      output: {
        // entryFileNames: 'js/[name].js', // 入口文件
        entryFileNames: 'js/[name]-[hash].js', // 入口文件
        // chunkFileNames: 'js/[name].js', // 分包引入文件
        chunkFileNames: 'js/[name]-[hash].js', // 分包引入文件
        // assetFileNames: '[ext]/[name]-[hash].[ext]', // 静态文件
        assetFileNames(assetInfo){
          console.log(assetInfo)
          // 文件名称
          if (assetInfo.name.endsWith('.css')) {
            return 'css/[name].css'
            // return 'css/[name]-[hash].css'
          }
          // 图片名称
          // 定义图片后缀
          const imgExts= ['.png', '.jpg', '.jpeg', '.webp', '.gif', '.svg', '.ico']
          if(imgExts.some(ext => assetInfo.name.endsWith(ext))){
            return 'imgs/[name].[ext]'
            // return 'imgs/[name]-[hash].[ext]'
          }
          //  remaining assets 剩余资源文件
          return 'assets/[name].[ext]'
          // return 'assets/[name]-[hash].[ext]'
        },
      }
    }
  }
})

```

## vite中手动分包 第三方库打包和自己的代码分开

vite 构建工具：esbuild(开发环境)、rollup(生产环境)(manualChunks手动分包)

```ts

export default defineConfig(
  {
    build: {
      rollupOptions: {
        // manualChunks: {
        //   vendor: ['vue', 'vue-router', 'pinia', 'axios'], // 第三方库打包成一个js文件
        // }
        // 报错不在rollupOptions中，加个output: {}
        manualChunks(id) {
          if (id.includes('node_modules')) {
            console.log("打包的第三方库", id);
            return 'vendor'
          }
        }
      }
    }
  }
)
```

## vite中配置别名

```ts

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'
      }
    }
  }
)
```


## 前端设计模式网站 https://www.patterns.dev/

https://www.patterns.dev/



## js 无法预测的大数运算（number 64位浮点数）

存储：符号+指数+尾数（科学计数法，比如 -108 => -1.08 * 10^2）

最大2^53-1 == Integer.MAX_VALUE 不损失精度的情况最大的整数，超过就不安全了

```js
var start = 2 ** 53; // var start = BigInt(2 ** 53) // 用BigInt可以，支持的范围更大
var end = start + 100; // var end = start + 100n;
// i++ 没用，死循环
for (var i=start; i<end; i++) {
  console.log('loop');
}

// 会运行多少次？ // 不可预测
```

## js 高阶函数

`有函数作为参数；返回值为函数`

- map // 遍历数组，返回新数组 // 例子：map((item, index) => item + index)
- filter // 遍历数组，返回符合条件的元素组成的新数组 // 例子：filter((item, index) => item > 0)
- reduce // 遍历数组，返回一个值 // 例子：reduce((prev, item) => prev + item, 0)
- slice // 截取数组的一部分，返回一个新的数组 // 例子：slice(1, 3)
- bind() // 创建一个新的函数，当这个新函数被调用时，原来的函数会以创建新函数时传入的第一个参数作为 this，后面的参数依次传入原函数 // 例子：bind(this, arg1, arg2) // 延续到外层，在将来的某个时刻运行，也就是运算的延续
- call() // 调用函数，并指定 this 的值 // 例子：call(this, arg1, arg2)
- apply() // 调用函数，并指定 this 的值，参数以数组形式传入 // 例子：apply(this, [arg1, arg2])

## css 属性值 initial unset revert

- initial：设置属性值为其初始值
- unset：如果属性是继承属性，则值为inherit，否则值为initial
- inherit：设置属性值为其父元素的计算值

`属性的默认值 initial`

```css
.ln-default {
  line-height: normal; // 很难记得住每个属性的默认值是啥，就用 initial
}
```

`清除浏览器的默认样式 unset` 

```css
ul {
  margin: unset;
  padding: unset;
  font-size: unset;
}
```

```css
ul {
  /* margin: unset;
  padding: unset;
  font-size: unset; */
  all: unset;
}
```

`回归到浏览器的默认样式 revert`
```css
.defualt {
  /* all: initial; // 回归到w3c的默认样式 */
  all: revert; // 回归到浏览器的默认样式
}
```

## 判断是不是数组？

1、`Array.isArray()`

2、`obj instanceof Array`

3、`Object.prototype.toString.call(obj) === '[object Array]'`

4、`obj.constructor === Array`

5、`Array.prototype.isPrototypeOf(obj)`


`Object.prototype.toString.call(obj) 判断， 不一定就是数组`

```js
const arr = [1, 2, 3, 4];
const obj = {
  // [Symbol.toStringTag]: 'Array',
  [Symbol.toStringTag]: 'abc',
}
console.log(Object.prototype.toString.call(obj)); // [object abc] // 非数组
```

`obj intanceof Array 判断，不一定就是是数组`

```js
class A extends Array {}

const arr = [1, 2, 3, 4];
const obj = {};
Object.setPrototype(obj, Array.prototype);
console.log(obj intanceof Array); // true // 非数组，但是判断是数组

```

```js
const Array1 = window.Array; // 当前页
const iframe = document.querySelector('iframe'); // 框架页
const Array2 = iframe.contentWindow.Array;
console.log(Array1 === Array2); // false // 都是数组，但是在不同的window环境下面，不相等
const arr = new Array2();
console.log(arr instanceof Array); // false // 非当前页，是框架页，所以false

```

·要用Array.isArray(arr), 通过有没有通过构造函数 f Array() [native code] （c++写的）， 建出数组这种特殊存储结构的对象·

## 判断是不是对象？

1、`typeof obj === 'object'`

2、`obj instanceof Object`

3、`Object.prototype.toString.call(obj) === '[object Object]'`

4、`obj.constructor === Object`

5、`obj.__proto__ === Object.prototype`

## 判断是不是空对象？

1、`Object.keys(obj).length === 0`

## 如何防截屏防录制？Encrypted Media Extension API 浏览器的原生功能

肯定是浏览器的原生功能，叫做Encrypted Media Extension API = EME

第三方库：NoPring.js，监控快捷键的

## 为什么需要虚拟DOM？

不是为了提升性能，性能并没有提升，反而因为多了一层虚拟DOM的计算，性能可能还降低了

1、`通用框架`，设计的核心理念是把页面和数据对应，当数据变化时，能够正确地去渲染界面

通用框架很难知道数据与界面的对应关系的，所以采取一种简单粗暴的方法，数据一变，界面全部重新生成一次

为了减少对真实DOM的操作，不得不引入虚拟DOM

2、`抽象`，vue3 定位为一个UI库，页面才有DOM，小程序、桌面端、移动端没有DOM，为了消除不同平台的差异，于是抽象了一个UI的表达方式，使用了一个普通对象来表达UI界面，根据不同的平台，去具体生成真实的界面


## 编码顺序和字典顺序.js

```js
const names = ['上海', '北京', '广州', '深圳', '杭州', '南京', '武汉'];
names.sort(); // 默认排序时编码的方式
'上' < '北' // 编码的方式 true
'上'.localCompare('北') // 1 // 字典排序
names.sort((a, b) => a.localCompare(b)); // 字典排序
```


## 自动检测更新.js 编译后文件指纹

浏览器文件指纹
```js
// auto-update.js
let lastSrcs; // 上一次获取到的script地址
const scriptReg = \/<script.*src=["'](?<src>[^"']+)/gm;
/**
 * 获取刷新页面中的script链接
 */
async function extractNewScripts() {
  const html = await fetch('/?_timestamp=' + Date.now()).then((resp) => {
    resp.text();
  });
  scriptReg.lastIndex = 0;
  let result = [];
  let match;
  while ((match = scriptReg.exec(html))) {
    result.push(match.groups.src);
  }
  return result;
}
/**
 * 检查页面是否有更新
 */
async function needUpdate() {
  const newScripts = await extractNewScripts();
  if (!lastSrcs) {
    lastSrcs = newScripts;
    return false;
  }
  let result = false;
  if (lastSrcs.length !== newScripts.length) {
    result = true;
  }
  for (let i=0; i<lastSrcs.length; i++) {
    if (lastSrcs[i] != newScripts[i]) {
      result = true;
      break;
    }
  }
  lastSrcs = newScripts;
  return result;
}

```

```js
const DURATION = 2000;
function autoRefresh() {
  setTimeout(async () => {
    const willUpdate = await needUpdate();
    if (willUpdate) {
      const result = confirm('页面有更新，点击确定刷新页面');
      if (result) {
        location.reload();
      }
    }
    autoRefresh();
  }, DURATION);
}

autoRefresh();
// 如果不用这个，在生产环境下要开启热更新，或者自行使用 web socket，都是比较麻烦的，而且要改动服务器，这种做法完全不用动服务器
```

## 妙用TS中的 keyof 联合类型 泛型

```ts
interface Point {
  x: number;
  y: number;
  z: number;
}

type Keys = keyof Point; // "x" | "y" | "z"

const k: Keys = 'x';
```

```ts
const cat = {
  name: 'Kitty',
  age: 3,
  love: 'flower',
};

const user = {
  loginId = 'abc',
  loginPwd: '123456',
};

// 获取某个对象的某个属性
function getValue<T extends object, K extends keyof T>(obj: T, name: K): T[K] {
  return obj[name];
}

getValue(cat, 'name'); // string
```




## 前置的不定量参数.ts

```ts
type JSTypeMap = {
    "number": number,
    "string": string,
    "boolean": boolean,
    "object": object,
    "symbol": symbol,
    "undefined": undefined,
    "null": null,
    "bigint": bigint
}

type JSTypeNames = keyof JSTypeMap;

type ArgsType<T extends JSTypeNames[]> = {
    [I in keyof T]: JSTypeMap[T[I]]
}

declare function addImpl<T extends JSTypeNames[]>(...args: [
    ...T,
    (...args: ArgsType<T>) => any
]): void;

addImpl("number", "boolean", "string", (a, b, c) => {

    console.log(a, b, c);
});

```

## 防抖函数类型标注.ts

```ts
function handler(a: number, b: number) {
    return a + b;
}

declare function debounce<A extends any[], R>(
    fn: (...args: A) => R, delay: number
): (...args: A) => void;

const debouncedHandler = debounce(handler, 1000);

```

## 深拷贝的循环引用问题

使用WeakMap来记录已经拷贝过的对象，避免循环引用导致的死循环。

```js
function deepClone(obj, map = new WeakMap()) {
  if (typeof obj !== 'object' || obj === null) {
    return obj;
  }
  if (map.has(obj)) {
    return map.get(obj);
  }
  const cloneObj = Array.isArray(obj) ? [] : {};
  map.set(obj, cloneObj);
  for (const key in obj) {
    if (obj.hasOwnProperty(key)) {
      cloneObj[key] = deepClone(obj[key], map);
    }
  }
  return cloneObj;
}
```

使用MessageChannel来异步拷贝，避免阻塞主线程。

```js
function deepClone(obj) {
  return new Promise((resolve) => {
    const { port1, port2 } = new MessageChannel();
    port1.postMessage(obj);
    port2.onmessage = (e) => resolve(e.data);
  });
}
```

使用JSON.stringify和JSON.parse来实现深拷贝，但这种方法无法拷贝函数、Symbol、Date等特殊对象。

```js
function deepClone(obj) {
  return JSON.parse(JSON.stringify(obj));
}
```

## JavaScript 面试合集

`基础知识`
什么是JavaScript？

JavaScript是一种高级编程语言，主要用于网页开发，使网页具有交互性。它是一种解释型语言，广泛用于客户端和服务器端开发。

JavaScript和ECMAScript有什么区别？

ECMAScript是JavaScript的标准，定义了语言的语法和特性。JavaScript是ECMAScript的一种实现。


JavaScript的数据类型有哪些？

JavaScript有七种基本数据类型：Number, String, Boolean, Null, Undefined, Symbol（ES6新增）, BigInt（ES10新增）。

什么是变量提升（Hoisting）？

变量提升是指JavaScript在执行代码之前会将变量和函数声明提升到其作用域的顶部。


let, const和var的区别是什么？

var是函数作用域，存在变量提升。
let和const是块级作用域，不存在变量提升。const声明的变量不能重新赋值。

什么是闭包（Closure）？

闭包是指函数能够记住并访问其词法作用域，即使函数在其词法作用域之外执行。


JavaScript中的this关键字是什么？

this关键字在JavaScript中指向调用当前函数的对象。它的值取决于函数的调用方式。


什么是原型（Prototype）？

原型是JavaScript中实现继承的一种机制。每个对象都有一个原型，可以从原型继承属性和方法。


什么是事件循环（Event Loop）？

事件循环是JavaScript处理异步操作的机制。它持续检查调用栈和任务队列，将任务队列中的任务推入调用栈执行。

`高级概念`
什么是Promise？

Promise是用于处理异步操作的对象，表示一个尚未完成但预期将来会完成的操作。

什么是async/await？

async/await是基于Promise的异步编程语法糖，使异步代码看起来更像同步代码。

什么是模块（Module）？

模块是JavaScript中用于组织代码的机制，可以将代码分割成独立的文件，并通过import和export语句进行导入和导出。

什么是箭头函数（Arrow Function）？

箭头函数是ES6引入的一种简洁的函数语法，没有自己的this，继承自外层作用域。

什么是深拷贝和浅拷贝？

浅拷贝只复制对象的第一层属性，深拷贝则递归复制对象的所有层级属性。


什么是防抖（Debounce）和节流（Throttle）？

防抖和节流是优化高频率事件处理的技术。防抖在事件触发后延迟执行函数，如果在此期间事件再次触发，则重新计时。节流则限制函数的执行频率，确保在一定时间内只执行一次。

什么是Web Worker？

Web Worker是JavaScript中用于在后台线程中运行脚本的API，使主线程不被阻塞。

什么是跨域请求（CORS）？

跨域请求是指在浏览器中，从一个域名的网页去请求另一个域名的资源。CORS（Cross-Origin Resource Sharing）是一种机制，服务器通过设置HTTP头允许浏览器进行跨域请求。

什么是RESTful API？

RESTful API是一种基于HTTP协议的API设计风格，使用HTTP方法（如GET、POST、PUT、DELETE）来操作资源。

`实际应用`

如何实现一个简单的JavaScript模块系统？

可以使用立即执行函数表达式（IIFE）来创建模块，通过返回对象来暴露接口。

如何优化JavaScript代码的性能？

可以使用Web Worker来分担主线程的工作，减少DOM操作，使用防抖和节流技术，避免全局变量污染等。

如何处理JavaScript中的错误？

可以使用try...catch语句来捕获和处理运行时错误，使用Promise.catch来处理Promise的错误。

如何实现一个简单的Promise？

可以通过构造函数创建一个Promise对象，实现resolve和reject方法来处理异步操作的结果。

## HTML 面试合集

`基础知识`

什么是HTML？

HTML（HyperText Markup Language）是一种用于创建网页的标准标记语言。它使用标签来描述网页的结构和内容。


HTML5有哪些新特性？

HTML5引入了许多新特性，包括语义化标签（如<header>, <footer>, <article>, <section>）、音频和视频标签（<audio>, <video>）、Canvas绘图、本地存储（localStorage, sessionStorage）、新的表单控件（如<input type="date">）等。


什么是DOCTYPE？

DOCTYPE是文档类型声明，用于告诉浏览器当前HTML文档使用的HTML版本。例如，HTML5的DOCTYPE声明是<!DOCTYPE html>。

什么是语义化标签？

语义化标签是指那些具有明确含义的HTML标签，如<header>, <footer>, <article>, <section>等。使用语义化标签可以提高代码的可读性和可维护性，也有助于搜索引擎优化（SEO）。


HTML标签有哪些基本结构？

一个基本的HTML标签通常包括开始标签、内容和结束标签。例如：<tagname>内容</tagname>。有些标签是自闭合的，如<img />。


什么是HTML实体（Entities）？

HTML实体是用于表示特殊字符的代码，如&lt;表示小于号（<），&amp;表示和号（&）。

`表单和控件`

HTML表单有哪些常用控件？

常用的表单控件包括<input>, <textarea>, <select>, <button>等。<input>标签有多种类型，如text, password, radio, checkbox, submit等。

如何验证表单输入？

可以使用HTML5的表单验证特性，如required, pattern, min, max等属性。也可以使用JavaScript进行自定义验证。

什么是<label>标签？

<label>标签用于定义表单控件的标签文本，可以提高表单的可访问性。通过for属性与控件的id关联。


`布局和样式`

什么是块级元素和行内元素？

块级元素（如<div>, <p>, <h1>）占据其父容器的整个宽度，并且前后会换行。行内元素（如<span>, <a>, <strong>）只占据其内容的宽度，不会换行。

什么是盒模型（Box Model）？

盒模型是CSS中用于布局的基本概念，每个HTML元素都被看作一个矩形盒子，包括内容区域、内边距（padding）、边框（border）和外边距（margin）。

什么是响应式网页设计（Responsive Web Design）？

响应式网页设计是一种设计方法，使网页能够根据不同设备的屏幕大小和分辨率自动调整布局和样式。常用的技术包括媒体查询（Media Queries）、流式布局（Fluid Grid）和弹性图片（Flexible Images）。

`高级概念`

什么是Web组件（Web Components）？

Web组件是一组标准，允许开发者创建可重用的自定义元素，并通过Shadow DOM隔离其样式和行为。

什么是Shadow DOM？

Shadow DOM是Web组件的一部分，用于将HTML和CSS封装在组件内部，使其与主文档隔离，避免样式冲突。

什么是Canvas和SVG？

Canvas是HTML5中的一个元素，用于通过JavaScript绘制图形。SVG（Scalable Vector Graphics）是一种基于XML的矢量图形格式，用于描述二维图形和图形应用程序。

什么是Web存储（Web Storage）？

Web存储是HTML5提供的一种客户端存储机制，包括localStorage和sessionStorage。localStorage用于长期存储数据，sessionStorage用于会话期间存储数据。

`实际应用`

如何创建一个简单的HTML页面？

可以通过编写基本的HTML结构，包括<!DOCTYPE html>声明、<html>, <head>, <body>等标签，并在<body>中添加内容。

如何优化HTML页面的加载速度？

可以通过压缩HTML代码、使用外部CSS和JavaScript文件、优化图片大小和格式、使用内容分发网络（CDN）等方法来优化页面加载速度。

如何处理HTML页面的可访问性（Accessibility）？

可以通过使用语义化标签、提供替代文本（alt text）、使用ARIA属性、确保键盘导航等方式来提高页面的可访问性。

## CSS 面试合集

`基础知识`
什么是CSS？

CSS（Cascading Style Sheets）是一种用于描述HTML或XML（包括SVG、XHTML等）文档外观和格式的样式表语言。

CSS选择器有哪些？

常见的CSS选择器包括元素选择器（如p）、类选择器（如.classname）、ID选择器（如#idname）、属性选择器（如[type="text"]）、伪类选择器（如:hover）、伪元素选择器（如::before）等。

什么是盒模型（Box Model）？

盒模型是CSS中用于布局的基本概念，每个HTML元素都被看作一个矩形盒子，包括内容区域、内边距（padding）、边框（border）和外边距（margin）。

什么是层叠顺序（Cascade Order）？

层叠顺序是指CSS规则的应用顺序，决定了当多个规则冲突时哪个规则优先。顺序通常是：浏览器默认样式 < 用户定义样式 < 外部样式表 < 内部样式表 < 行内样式。

什么是继承（Inheritance）？

继承是指某些CSS属性会自动应用到子元素上，如color, font-family等。可以通过inherit关键字强制继承。

`布局和定位`
什么是浮动（Float）？

浮动是一种布局技术，使元素脱离正常文档流并向左或向右移动，直到其边缘接触到包含块或另一个浮动元素的边缘。

什么是定位（Positioning）？

定位是指通过position属性控制元素的位置。常见的定位类型包括：
static（默认值，正常文档流）
relative（相对定位，相对于元素在正常文档流中的位置）
absolute（绝对定位，相对于最近的非static定位祖先元素）
fixed（固定定位，相对于视口）
sticky（粘性定位，结合相对定位和固定定位的特性）

什么是Flexbox？

Flexbox（Flexible Box Layout）是一种一维布局模型，用于创建灵活的布局。通过display: flex或display: inline-flex启用，可以方便地控制子元素的对齐、方向和顺序。

什么是Grid布局？

CSS Grid Layout是一种二维布局模型，通过display: grid启用，可以创建复杂的网格布局，控制行和列的大小和位置。

`响应式设计和媒体查询`
什么是响应式网页设计（Responsive Web Design）？

响应式网页设计是一种设计方法，使网页能够根据不同设备的屏幕大小和分辨率自动调整布局和样式。常用的技术包括媒体查询（Media Queries）、流式布局（Fluid Grid）和弹性图片（Flexible Images）。

什么是媒体查询（Media Queries）？

媒体查询是CSS3引入的一种技术，允许根据设备的特性（如屏幕宽度、高度、分辨率等）应用不同的样式规则。

`高级概念`
什么是CSS预处理器？

CSS预处理器是一种脚本语言，用于扩展CSS的功能，常见的有Sass、Less和Stylus。它们提供了变量、嵌套、混合（Mixins）、函数等功能，使CSS更易于维护和复用。

什么是CSS模块化？

CSS模块化是一种组织和管理CSS代码的方法，通过将样式分割成独立的模块，避免全局命名冲突，提高代码的可维护性。

什么是CSS动画？

CSS动画是通过@keyframes规则和animation属性创建的动画效果，可以在不使用JavaScript的情况下实现复杂的动画。

什么是CSS变量（Custom Properties）？

CSS变量（也称为自定义属性）是一种在CSS中定义和使用的变量，通过--variable-name语法定义，通过var(--variable-name)语法使用。

`实际应用`
如何清除浮动？

可以通过在浮动元素的父元素上添加clearfix类，使用伪元素（如::after）清除浮动。

如何实现水平居中和垂直居中？

水平居中可以通过margin: 0 auto（块级元素）或text-align: center（行内元素）实现。垂直居中可以使用Flexbox、Grid布局、绝对定位结合transform等方法。

如何优化CSS性能？

可以通过压缩CSS代码、使用外部样式表、避免使用昂贵的选择器、减少重绘和重排等方法来优化CSS性能。