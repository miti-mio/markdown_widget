言語：[簡体中文](https://github.com/asjqkkkk/markdown_widget/blob/master/README_ZH.md) | [英語](https://github.com/asjqkkkk/markdown_widget/blob/master/README.md) | [日本語](https://github.com/asjqkkkk/markdown_widget/blob/master/README_JP.md)

![画面](https://github.com/asjqkkkk/asjqkkkk.github.io/assets/30992818/4185bf1a-0be3-460d-ba12-9e4764f5c035)

# 📖markdown_widget

[![カバレッジステータス](https://coveralls.io/repos/github/asjqkkkk/markdown_widget/badge.svg?branch=dev)](https://coveralls.io/github/asjqkkkk/markdown_widget?branch=dev) [![pubパッケージ](https://img.shields.io/pub/v/markdown_widget.svg)](https://pub.dartlang.org/packages/markdown_widget) [![デモ](https://img.shields.io/badge/demo-online-brightgreen)](https://asjqkkkk.github.io/markdown_widget/)

シンプルで使いやすいマークダウンレンダリングコンポーネント。

- 見出しを通じてTOC（目次）機能をサポートし、迅速な位置決めが可能
- コードのハイライトをサポート
- すべてのプラットフォームをサポート

## 🚀使用方法

始める前に、[デモ](https://asjqkkkk.github.io/markdown_widget/)をクリックしてオンラインデモを試すことができます。

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
独自のColumnや他のリストウィジェットを使用したい場合は、`MarkdownGenerator`を使用できます。

```
  Widget buildMarkdown() =>
      Column(children: MarkdownGenerator().buildWidgets(data));
```

または`MarkdownBlock`を使用します。

```
  Widget buildMarkdown() =>
      SingleChildScrollView(child: MarkdownBlock(data: data));
```

## 📁 その他の例

高度な使用例については、リポジトリの [example/lib/markdown_custom](https://github.com/asjqkkkk/markdown_widget/tree/dev/example/lib/markdown_custom) フォルダを参照してください：

- **video.dart** - カスタムvideoタグのサポート
- **latex.dart** - LaTeX数式レンダリング
- **mermaid.dart** - Mermaid図のサポート（フローチャート、シーケンス図など）
- **html_support.dart** - HTMLタグの拡張
- **custom_node.dart** - カスタムノードの実装例

これらの例は、カスタムタグと機能を使用してパッケージを拡張する方法を示しています。

## 🌠ナイトモード

`markdown_widget`はデフォルトでナイトモードをサポートしています。異なる`MarkdownConfig`を使用するだけで有効にできます。

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

デフォルトモード | ナイトモード
---|---
<img src="https://user-images.githubusercontent.com/30992818/211159089-ec4acd11-ee02-46f2-af4f-f8c47eb28410.png" width=400> | <img src="https://user-images.githubusercontent.com/30992818/211159108-4c20de2d-fb1d-4bcb-b23f-3ceb91291661.png" width=400>


## 🔗リンク

リンクのスタイルとクリックイベントをカスタマイズできます。例えば次のように

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

## 🎨見出しと太字のカスタマイズ

`MarkdownConfig.configs` は **tag** 単位で上書きします。配列の順序は関係ありません。同じ tag が2回出た場合は後のものが勝ちます。

### 見出しの padding（h1–h6）

`H1Config`–`H6Config` はすべて `padding` を受け取れます。デフォルトは `EdgeInsets.only(top: 8, bottom: 4)` です。`style` を書き直さなくても余白だけ変えられます。

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

h4–h6 はデフォルトで分割線がありませんが、padding は効きます。余白が不要なら `padding: EdgeInsets.zero` を指定してください。

見出し同士のブロック間隔は別層です。`MarkdownGenerator.linesMargin` のデフォルトは上下 8 です。

### 太字 `**xx**`

`StrongConfig` で `**bold**` / `__bold__` のスタイルを上書きできます。デフォルトは `FontWeight.bold` のままです。

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

## 📜TOC（目次）機能

TOCの使用は非常に簡単です。

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

## 🎈コードのハイライト

コードのハイライトは複数のテーマをサポートしています。

```
import 'package:flutter_highlight/themes/a11y-light.dart';

  Widget buildMarkdown() => MarkdownWidget(
      data: data,
      config: MarkdownConfig(configs: [
        PreConfig(theme: a11yLightTheme),
      ]));
```

## 🧬全選択とコピー

全プラットフォームで全選択とコピー機能をサポートしています。

![image](https://user-images.githubusercontent.com/30992818/226107076-f32a919e-9a0c-4138-8a0b-266c6337e0af.png)

## 🌐Htmlタグ

現在のパッケージはMarkdownタグの変換のみを実装しているため、デフォルトではHTMLタグの変換をサポートしていません。ただし、この機能は拡張によってサポートできます。詳細については、[html_support.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/html_support.dart)の使用方法を参照してください。

こちらが[オンラインHTMLデモショーケース](https://asjqkkkk.github.io/markdown_widget/#/sample_html)です。

## 🧮Latexサポート

例にはLaTeXの簡単なサポートも含まれており、[latex.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/latex.dart)の実装を参照することで実装できます。

こちらが[オンラインlatexデモショーケース](https://asjqkkkk.github.io/markdown_widget/#/sample_latex)です。

## 🔷Mermaid図サポート

例にはMermaid図のサポートが含まれており、フローチャート、シーケンス図、状態図などをレンダリングできます。実装については[mermaid.dart](https://github.com/asjqkkkk/markdown_widget/blob/dev/example/lib/markdown_custom/mermaid.dart)を参照してください。

機能：
- 複数の図タイプ（フローチャート、シーケンス図、状態図、ER図など）
- テーマサポート（自動ライト/ダークモード）
- インタラクティブな表示モード（コードのみ、図のみ、または両方）
- フルスクリーンビューア（パンとズームをサポート）
- 幅の広い図の独立した水平スクロール
- パフォーマンス最適化のためのスマートキャッシュとデバウンス

こちらが[オンラインMermaidデモショーケース](https://asjqkkkk.github.io/markdown_widget/#/sample_mermaid)です。

```dart
import 'package:markdown_widget/markdown_widget.dart';
import 'markdown_custom/mermaid.dart';

// 基本的な使い方
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

// カスタム設定
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

## 🍑カスタムタグの実装

`MarkdownGeneratorConfig`に`SpanNodeGeneratorWithTag`を渡すことで、新しいタグとそのタグに対応する`SpanNode`を追加できます。また、既存のタグを使用して対応する`SpanNode`を上書きすることもできます。

また、`InlineSyntax`と`BlockSyntax`を使用してMarkdown文字列の解析ルールをカスタマイズし、新しいタグを生成することもできます。

カスタムタグの実装方法については、[このissue](https://github.com/asjqkkkk/markdown_widget/issues/79)を参照してください。

このパッケージを使用していて、良いアイデアや提案がある場合、または問題がある場合は、[プルリクエストやissueを開いてください](https://github.com/asjqkkkk/markdown_widget)。

# 🧾付録

`markdown_widget`で使用されている他のライブラリは次のとおりです。

パッケージ | 説明
---|---
[markdown](https://pub.dev/packages/markdown) | マークダウンデータの解析
[flutter_highlight](https://pub.dev/packages/flutter_highlight) | コードのハイライト
[highlight](https://pub.dev/packages/highlight) | コードのハイライト
[url_launcher](https://pub.dev/packages/url_launcher) | リンクのオープン
[visibility_detector](https://pub.dev/packages/visibility_detector) | ウィジェットの可視性のリスニング
[scroll_to_index](https://pub.dev/packages/scroll_to_index) | ListViewがインデックスにジャンプできるようにする
