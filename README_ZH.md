语言：[简体中文](https://github.com/asjqkkkk/markdown_widget/blob/master/README_ZH.md) | [English](https://github.com/asjqkkkk/markdown_widget/blob/master/README.md) | [日本語](https://github.com/asjqkkkk/markdown_widget/blob/master/README_JP.md)

![screen](https://github.com/asjqkkkk/asjqkkkk.github.io/assets/30992818/4185bf1a-0be3-460d-ba12-9e4764f5c035)

# 📖markdown_widget

[![Coverage Status](https://coveralls.io/repos/github/asjqkkkk/markdown_widget/badge.svg?branch=dev)](https://coveralls.io/github/asjqkkkk/markdown_widget?branch=dev) [![pub package](https://img.shields.io/pub/v/markdown_widget.svg)](https://pub.dartlang.org/packages/markdown_widget) [![demo](https://img.shields.io/badge/demo-online-brightgreen)](https://asjqkkkk.github.io/markdown_widget/)

一个简单易用的markdown渲染组件

- 支持TOC功能，可以通过Heading快速定位
- 支持代码高亮
- 支持全平台

## 🚀使用

在开始之前,你可以先体验一下在线 demo [点击体验](https://asjqkkkk.github.io/markdown_widget/)

```
import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class MarkdownPage extends StatelessWidget {
  final String data;

  MarkdownPage(this.data);

  @override
  Widget build(BuildContext context) => Scaffold(body: buildMarkdown());

  Widget buildMarkdown() => MarkdownWidget(data: data);
}
```

如果你想使用自己的 Column 或者其他列表 Widget, 你可以使用 `MarkdownGenerator`

```
  Widget buildMarkdown() =>
      Column(children: MarkdownGenerator().buildWidgets(data));
```

或者直接使用 `MarkdownBlock`

```
  Widget buildMarkdown() =>
      SingleChildScrollView(child: MarkdownBlock(data: data));
```

## 📁 更多示例

更多高级用法示例，请参考仓库中的 [example/lib/markdown_custom](https://github.com/asjqkkkk/markdown_widget/tree/dev/example/lib/markdown_custom) 文件夹：

- **video.dart** - 自定义 video 标签支持
- **latex.dart** - LaTeX 数学公式渲染
- **mermaid.dart** - Mermaid 图表支持（流程图、时序图等）
- **html_support.dart** - HTML 标签扩展
- **custom_node.dart** - 自定义节点实现示例

这些示例展示了如何通过自定义标签和功能来扩展本包。

## 🌠夜间模式

`markdown_widget` 默认支持夜间模式，只需要使用不同的 `MarkdownConfig` 即可
```
  Widget buildMarkdown(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final config = isDark
        ? MarkdownConfig.darkConfig
        : MarkdownConfig.defaultConfig;
    final codeWrapper = (child, text, language) =>
        CodeWrapperWidget(child, text, language);
    return MarkdownWidget(
        data: data,
        config: config.copy(configs: [
        isDark
        ? PreConfig.darkConfig.copy(wrapper: codeWrapper)
        : PreConfig().copy(wrapper: codeWrapper)
    ]));
  }
```

默认模式 | 夜间模式
---|---
<img src="https://user-images.githubusercontent.com/30992818/211159232-92efbbb0-dd01-4970-8ff1-33a47c133b1f.png" width=400> | <img src="https://user-images.githubusercontent.com/30992818/211159236-570fca93-a5f4-403f-94ba-986272d1207e.png" width=400>


## 🔗链接

你可以自定义链接样式和点击事件，比如下面这样

```
  Widget buildMarkdown() => MarkdownWidget(
      data: data,
      config: MarkdownConfig(configs: [
        LinkConfig(
          style: TextStyle(
            color: Colors.red,
            decoration: TextDecoration.underline,
          ),
          onTap: (url) {
            ///TODO:on tap
          },
        )
      ]));
      
```

## 🎨自定义标题与加粗

`MarkdownConfig.configs` 按 **tag** 覆盖默认样式，数组顺序无关；同一个 tag 出现两次时，后面的会覆盖前面的。

### 标题 padding（h1–h6）

`H1Config`–`H6Config` 都支持 `padding`。默认是 `EdgeInsets.only(top: 8, bottom: 4)`。只改间距时不必重写 `style`。

```dart
MarkdownWidget(
  data: data,
  config: MarkdownConfig(configs: [
    H1Config(padding: EdgeInsets.only(top: 16, bottom: 8)),
    H2Config(padding: EdgeInsets.only(top: 16, bottom: 8)),
    H3Config(padding: EdgeInsets.only(top: 16, bottom: 8)),
    H4Config(padding: EdgeInsets.only(top: 16, bottom: 8)),
    H5Config(padding: EdgeInsets.only(top: 4, bottom: 2)),
    H6Config(padding: EdgeInsets.only(top: 4, bottom: 2)),
  ]),
)
```

h4–h6 默认没有分割线，但 padding 仍然生效。不想要额外间距时设 `padding: EdgeInsets.zero`。

标题与标题之间还有 `MarkdownGenerator.linesMargin`（默认上下各 8），那是块间距，和这里的 padding 是两层。

### 加粗 `**xx**`

用 `StrongConfig` 覆盖 `**bold**` / `__bold__` 的样式，默认仍是 `FontWeight.bold`。

```dart
MarkdownWidget(
  data: data,
  config: MarkdownConfig(configs: [
    StrongConfig(
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F2328),
      ),
    ),
  ]),
)
```

### 一起覆盖

```dart
final config = MarkdownConfig(configs: [
  H1Config(
    style: TextStyle(
      fontSize: 28,
      height: 36 / 28,
      fontWeight: FontWeight.w600,
    ),
    padding: EdgeInsets.only(top: 16, bottom: 8),
  ),
  H2Config(padding: EdgeInsets.only(top: 16, bottom: 8)),
  StrongConfig(style: TextStyle(fontWeight: FontWeight.w600)),
  PConfig(textStyle: TextStyle(fontSize: 16)),
]);

MarkdownWidget(data: data, config: config);
```

## 📜TOC功能

使用TOC非常的简单

```
  final tocController = TocController();

  Widget buildTocWidget() => TocWidget(controller: tocController);

  Widget buildMarkdown() => MarkdownWidget(data: data, tocController: tocController);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
          children: <Widget>[
            Expanded(child: buildTocWidget()),
            Expanded(child: buildMarkdown(), flex: 3)
          ],
        ));
  }
```

## 🎈代码高亮

代码高亮支持多种主题
```
import 'package:flutter_highlight/themes/a11y-light.dart';

  Widget buildMarkdown() => MarkdownWidget(
      data: data,
      config: MarkdownConfig(configs: [
        PreConfig(theme: a11yLightTheme),
      ]));
```

## 🧬全选与复制

支持全平台的全选和复制功能

![image](https://user-images.githubusercontent.com/30992818/226107076-f32a919e-9a0c-4138-8a0b-266c6337e0af.png)

## 🌐html 标签

由于当前 package 只实现了对于 Markdown tag 的转换，所以默认不支持转换 html 标签。但可以通过扩展的方式来支持这个功能，具体可以参考这里的使用 [html_support.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/html_support.dart)

以及 [在线html demo展示](https://asjqkkkk.github.io/markdown_widget/#/sample_html)

## 🧮Latex 支持

在例子中实现了对于Latex的简单支持，具体可以参考这里的实现 [latex.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/latex.dart)

以及 [在线latex demo展示](https://asjqkkkk.github.io/markdown_widget/#/sample_latex)

## 🔷Mermaid 图表支持

示例中包含了对 Mermaid 图表的支持，可以渲染流程图、时序图、状态图等。具体实现可以参考 [mermaid.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/mermaid.dart)

特性：
- 支持多种图表类型（流程图、时序图、状态图、ER 图等）
- 支持主题切换（自动跟随明暗模式）
- 交互式显示模式（仅代码、仅图表、或两者）
- 全屏查看器，支持平移和缩放
- 宽图表独立水平滚动
- 智能缓存和防抖，优化性能

以及 [在线Mermaid demo展示](https://asjqkkkk.github.io/markdown_widget/#/sample_mermaid)

```dart
import 'package:markdown_widget/markdown_widget.dart';
import 'markdown_custom/mermaid.dart';

// 基本用法
final isDark = Theme.of(context).brightness == Brightness.dark;
final preConfig = PreConfig(
  wrapper: createMermaidWrapper(
    config: const MermaidConfig(),
    isDark: isDark,
    preConfig: preConfig,
  ),
);

MarkdownWidget(
  data: markdown,
  config: config.copy(configs: [preConfig]),
)

// 自定义配置
final preConfig = PreConfig(
  wrapper: createMermaidWrapper(
    config: MermaidConfig(
      displayMode: MermaidDisplayMode.codeAndDiagram,
      diagramPadding: EdgeInsets.all(16.0),
      showLoadingIndicator: true,
    ),
    isDark: isDark,
    preConfig: preConfig,
  ),
);
```


## 🍑自定义tag与实现

通过向 `MarkdownGeneratorConfig` 传递 `SpanNodeGeneratorWithTag` ，可以增加新的 tag，以及这个 tag 所对应的 `SpanNode`；也可以使用已有的 tag 来对它所对应的 `SpanNode` 进行覆盖

同时也可以通过 `InlineSyntax` 与 `BlockSyntax` 自定义 markdown 字符串的解析规则，并生成新的 tag

可以参考 [这个issue](https://github.com/asjqkkkk/markdown_widget/issues/79) 是如何去实现一个自定义tag的

如果你由什么好的想法或者建议,以及使用上的问题, [欢迎来提pr或issue](https://github.com/asjqkkkk/markdown_widget)

# 🧾附录

这里是 markdown_widget 中使用到的其他库

库 | 描述
---|---
[markdown](https://pub.dev/packages/markdown) | 解析markdown数据
[flutter_highlight](https://pub.dev/packages/flutter_highlight) | 代码高亮
[highlight](https://pub.dev/packages/highlight) | 代码高亮
[url_launcher](https://pub.dev/packages/url_launcher) | 用于打开链接
[visibility_detector](https://pub.dev/packages/visibility_detector) | 监听Widget是否可见
[scroll_to_index](https://pub.dev/packages/scroll_to_index) | 让Listview可以根据index来跳转
