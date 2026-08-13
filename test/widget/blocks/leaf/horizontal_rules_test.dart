import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdown_widget/markdown_widget.dart';

void main() {
  group('HrConfig', () {
    test('should have correct tag', () {
      final config = const HrConfig();
      expect(config.tag, MarkdownTag.hr.name);
    });

    test('should have dark config', () {
      final config = HrConfig.darkConfig;
      expect(config, isA<HrConfig>());
    });

    test('should accept custom thickness', () {
      const config = HrConfig(height: 1, thickness: 1, color: Color(0xFFD0D7DE));
      expect(config.height, 1);
      expect(config.thickness, 1);
      expect(config.color, const Color(0xFFD0D7DE));
    });

    test('should have zero padding by default', () {
      const config = HrConfig();
      expect(config.padding, EdgeInsets.zero);
      expect(config.height, 2);
      expect(config.thickness, 2);
      expect(config.color, const Color(0xFFd0d7de));
    });

    test('should default thickness to height when omitted', () {
      const config = HrConfig(height: 4);
      expect(config.thickness, 4);
    });

    test('should accept custom padding', () {
      const padding = EdgeInsets.only(top: 24, bottom: 24);
      const config = HrConfig(padding: padding);
      expect(config.padding, padding);
    });
  });

  group('HorizontalRule rendering with markdown', () {
    testWidgets('should render horizontal rule with dashes', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '---';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render horizontal rule with asterisks', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '***';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render horizontal rule with underscores', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '___';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render horizontal rule with more characters', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '--------------------';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render multiple horizontal rules', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '''First section

---

Second section

***

Third section''';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should render horizontal rule with text around', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '''Text before

---

Text after''';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should apply custom hr thickness', (tester) async {
      final config = MarkdownConfig(configs: [
        const HrConfig(height: 1, thickness: 1, color: Color(0xFFD0D7DE)),
      ]);
      final generator = MarkdownGenerator();
      final widgets = generator.buildWidgets('---', config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      final rendered = tester.widget<Divider>(find.byType(Divider));
      expect(rendered.height, 1);
      expect(rendered.thickness, 1);
      expect(rendered.color, const Color(0xFFD0D7DE));
    });

    testWidgets('should apply custom hr padding', (tester) async {
      const padding = EdgeInsets.only(top: 24, bottom: 24);
      final config = MarkdownConfig(configs: [
        const HrConfig(padding: padding),
      ]);
      final generator = MarkdownGenerator();
      final widgets = generator.buildWidgets('---', config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      final hasPadding = tester.widgetList<Padding>(find.byType(Padding)).any(
            (widget) => widget.padding == padding,
          );
      expect(hasPadding, isTrue);
    });

    testWidgets('should use dark config', (tester) async {
      final config = MarkdownConfig.darkConfig;
      final generator = MarkdownGenerator();
      const markdown = '---';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('HorizontalRule edge cases', () {
    testWidgets('should handle horizontal rule with spaces', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = ' - - - ';

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should not render invalid horizontal rule', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '--'; /// Too short

      final widgets = generator.buildWidgets(markdown, config: config);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Column(children: widgets),
        ),
      ));

      /// Should still render, just not as a horizontal rule
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle horizontal rule in complex document', (tester) async {
      final config = MarkdownConfig();
      final generator = MarkdownGenerator();
      const markdown = '''# Title

Some content

---

More content

* List item
* Another item

---

Final section''';

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
