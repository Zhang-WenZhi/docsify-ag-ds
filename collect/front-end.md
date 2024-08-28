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