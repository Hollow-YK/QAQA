<div align="center">

# QAQA 问答问答

一个答题应用

<div>
    <img alt="platform" src="https://img.shields.io/badge/platform-Windows-blueviolet">
</div>
<div>
    <img alt="license" src="https://img.shields.io/github/license/Hollow-YK/QAQA">
    <img alt="commit" src="https://img.shields.io/github/commit-activity/m/Hollow-YK/QAQA">
</div>
<div>
    <img alt="stars" src="https://img.shields.io/github/stars/Hollow-YK/QAQA?style=social">
    <img alt="GitHub all releases" src="https://img.shields.io/github/downloads/Hollow-YK/QAQA/total?style=social">
</div>
<br>

<!-- markdownlint-restore -->

</div>

## 下载与安装

请前往[Release](https://github.com/Hollow-YK/QAQA/releases)下载最新安装包并安装。

建议在安装时选择“安装示例题库”。

## 功能

- 文字题目问答
- 三分钟倒计时，会在倒计时即将结束时变成红色
- 答案可以是图片

### 画饼

*这些功能计划在将来实现，但是现在还没做

- 导入题库
- 题库编辑器
- 自定义倒计时时长
- 题目带图

## 使用说明

### 初次使用

现阶段，你需要先将支持的题库放入`%APPDATA%/Hollow/QAQA`文件夹内。

如果你是题目制作者，可以将题库打包为一个自释放压缩包，或者使用NSIS等工具将其制作为安装向导。

### 题库格式

题库至少包含一个CSV文件。要求第一列为问题，第二列为答案。

下面是一个最简单的示例：

example.csv
```
问题,答案
```

#### 图片的使用

目前仅允许在答案中使用图片。

当你要在答案中使用图片时，你不能再在答案中加入文本。

使用图片的答案需在答案处填写相应图片的完整文件名，如`001.png`。每道题仅允许一张图片，且仅支持png格式。

使用的图片应放于与CSV文件同名（不含后缀名）的文件夹内。

下面是一个例子：

文件树
```
%APPDATA%/Hollow/QAQA
|   example.csv
\---example
        001.png
```

example.csv
```
这是文本问题,这是文本答案
这是答案是图片的问题,001.png
```

## 致谢

### 开源项目

参考了一些开源Flutter项目的代码结构

### 其它

- 使用Flutter进行开发
- ~~`README.md`照抄了我的另一个仓库的README~~
- `README.md`参考了[MaaAssistantArknights](https://github.com/MaaAssistantArknights/MaaAssistantArknights/)
- `README.md`使用了[shields.io](https://shields.io/)、[contrib.rocks](https://contrib.rocks/)提供的内容

### 贡献/参与者

感谢所有参与到开发/测试中的朋友们(\*´▽｀)ノノ

~~好像只有我自己~~

[![Contributors](https://contrib.rocks/image?repo=Hollow-YK/Yunhu_MinecraftStatus_Bot&max=105&columns=15)](https://github.com/Hollow-YK/Yunhu_MinecraftStatus_Bot/graphs/contributors)

## 声明

- 本软件使用 [GNU Affero General Public License v3.0 only](https://spdx.org/licenses/AGPL-3.0-only.html) 开源。
- 本软件开源、免费，仅供学习交流使用。

## 广告

如果觉得软件对你有帮助，帮忙点个 Star 吧！~（网页最上方右上角的小星星），这就是对我们最大的支持了！