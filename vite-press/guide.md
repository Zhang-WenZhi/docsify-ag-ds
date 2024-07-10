# VitePress 介绍

> VitePress 是一个基于 Vite 的静态网站生成器。它允许你使用 Vue 组件来构建你的网站，并且支持 Markdown 语法。VitePress 的目标是提供一种快速、简单的方式来创建文档网站。

## 快速开始

### 安装

首先，你需要安装 Node.js 和 npm。然后，你可以使用 npm 来安装 VitePress：

```bash
npm install -g create-vitepress
```

### 创建项目

使用 create-vitepress 命令来创建一个新的 VitePress 项目：

```bash
create-vitepress my-project
```
### 启动开发服务器

进入项目目录，并启动开发服务器：

```bash
cd my-project
npm run dev
```

现在，你可以在浏览器中访问 http://localhost:3000 来查看你的网站。
## 文档结构

VitePress 的文档结构由一个 `docs` 目录组成，该目录包含一个 `index.md` 文件和一个 `guide` 目录。`index.md` 文件是网站的首页，而 `guide` 目录包含了一个名为 `index.md` 的文件和一个名为 `getting-started.md` 的文件。
## 使用 Markdown

VitePress 支持使用 Markdown 语法来编写文档。你可以在 `index.md` 和 `getting-started.md` 文件中使用 Markdown 语法来创建标题、列表、链接等。
例如，在 `index.md` 文件中，你可以使用以下 Markdown 语法来创建一个标题：

```markdown
# VitePress
```
在 `getting-started.md` 文件中，你可以使用以下 Markdown 语法来创建一个列表：

```markdown
- 安装 Node.js 和 npm
- 创建一个新的 VitePress 项目
- 启动开发服务器
```
你可以使用 VitePress 的 Markdown 语法来创建更复杂的文档，例如表格、代码块、引用等。
## 自定义主题

VitePress 允许你自定义主题，以适应你的网站需求。你可以通过修改 `docs/.vitepress/theme/index.js` 文件来自定义主题。
例如，你可以添加一个新的组件来显示网站的导航栏：

```javascript
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'MyTheme',
  setup() {
    return () => {
      return (
        <div>
          <nav>
            <a href="/">首页</a>
            <a href="/guide/">指南</a>
          </nav>
          <Content />
        </div>
      )
    }
  }
})
```
然后，你可以在 `docs/.vitepress/theme/index.js` 文件中导入并使用这个组件：

```javascript
import MyTheme from './MyTheme.vue'

export default {
  theme: MyTheme
}
```
现在，你的网站将显示一个自定义的导航栏。你可以根据自己的需求来修改和扩展这个主题。
## 结论

VitePress 是一个强大的静态网站生成器，它允许你使用 Vue 组件和 Markdown 语法来创建文档网站。通过自定义主题，你可以轻松地适应你的网站需求。希望这个介绍能帮助你开始使用 VitePress 来创建你的文档网站。