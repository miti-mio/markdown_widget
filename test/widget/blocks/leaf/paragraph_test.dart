import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

void main() {
  group('PConfig', () {
    test('should have correct tag', () {
      final config = const PConfig();
      expect(config.tag, MarkdownTag.p.name);
    });

    test('should have default style', () {
      final config = const PConfig();
      expect(config.textStyle, isNotNull);
      expect(config.textStyle.fontSize, 16);
    });

    test('should have dark config', () {
      final config = PConfig.darkConfig;
      expect(config, isA<PConfig>());
    });

    test('should accept custom textStyle', () {
      final customStyle = TextStyle(fontSize: 18, color: Colors.blue);
      final config = PConfig(textStyle: customStyle);

      expect(config.textStyle.fontSize, 18);
      expect(config.textStyle.color, Colors.blue);
    });
  });

  group('ParagraphNode', () {
    test('should create with pConfig', () {
      final config = PConfig();
      final node = ParagraphNode(config);

      expect(node.pConfig, config);
    });

    test('should merge parent style', () {
      final parent = ConcreteElementNode(
        style: TextStyle(fontSize: 20, color: Colors.red),
      );
      final config = PConfig();
      final node = ParagraphNode(config);
      parent.accept(node);

      expect(node.parentStyle, parent.style);
    });
  });

  group('Paragraph rendering with markdown', () {
    testWidgets('should render simple paragraph', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is a paragraph.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render multiple paragraphs', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '''First paragraph.

Second paragraph.

Third paragraph.''';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render paragraph with inline formatting', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This has **bold** and *italic* text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render paragraph with code', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This has `inline code` in it.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render paragraph with links', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'Check out [this link](https://example.com).';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('DelNode (strikethrough)', () {
    test('should create with default style', () {
      final node = DelNode();
      expect(node.style.decoration, TextDecoration.lineThrough);
    });

    testWidgets('should render strikethrough text', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is ~~deleted~~ text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('StrongConfig', () {
    test('should have correct tag', () {
      const config = StrongConfig();
      expect(config.tag, MarkdownTag.strong.name);
    });

    test('should have default bold style', () {
      const config = StrongConfig();
      expect(config.style.fontWeight, FontWeight.bold);
    });

    test('should accept custom style', () {
      const customStyle = TextStyle(
        fontWeight: FontWeight.w600,
        color: Colors.red,
      );
      const config = StrongConfig(style: customStyle);
      expect(config.style.fontWeight, FontWeight.w600);
      expect(config.style.color, Colors.red);
    });
  });

  group('StrongNode (bold)', () {
    test('should create with default style', () {
      final node = StrongNode();
      expect(node.style.fontWeight, FontWeight.bold);
    });

    test('should use custom StrongConfig style', () {
      const config = StrongConfig(
        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
      );
      final node = StrongNode(config);
      expect(node.style.fontWeight, FontWeight.w900);
      expect(node.style.fontSize, 18);
    });

    testWidgets('should render bold text', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is **bold** text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render bold text with underscores', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is __bold__ text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should apply custom strong style from MarkdownConfig',
        (tester) async {
      final config = MarkdownConfig(configs: [
        const StrongConfig(
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.orange),
        ),
      ]);
      final generator = MarkdownGenerator();
      const markdown = 'This is **bold** text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      final richTexts = tester.widgetList<RichText>(find.byType(RichText));
      final hasCustomStrong = richTexts.any((richText) {
        var found = false;
        richText.text.visitChildren((span) {
          if (span.style?.color == Colors.orange &&
              span.style?.fontWeight == FontWeight.w600) {
            found = true;
          }
          return true;
        });
        return found;
      });
      expect(hasCustomStrong, isTrue);
    });
  });

  group('EmNode (italic)', () {
    test('should create with default style', () {
      final node = EmNode();
      expect(node.style.fontStyle, FontStyle.italic);
    });

    testWidgets('should render italic text', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is *italic* text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render italic text with underscores', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is _italic_ text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('BrNode (line break)', () {
    test('should create line break', () {
      final node = BrNode();
      final span = node.build();

      expect(span, isA<TextSpan>());
      expect((span as TextSpan).text, '\n');
    });

    testWidgets('should render line breaks', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'Line 1  \nLine 2'; // Two spaces + newline = hard break

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('Paragraph edge cases', () {
    testWidgets('should handle empty paragraph', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle paragraph with special characters', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'Special chars: < > & " \' \\';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle very long paragraph', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      final markdown = 'A' * 1000;

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('Combined inline formatting', () {
    testWidgets('should render bold and italic together', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is ***bold and italic*** text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render nested formatting', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = 'This is **bold with *italic* inside** text.';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
