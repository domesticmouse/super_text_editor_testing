import 'package:flutter/material.dart';
import 'package:super_editor/super_editor.dart';
import 'package:svg_highlight/svg_highlight.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SuperTextField testing',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.green),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

const commentAttribution = NamedAttribution('comment');
const cdataAttribution = NamedAttribution('cdata');
const dtdAttribution = NamedAttribution('dtd');
const entityRefAttribution = NamedAttribution('entityRef');
const charRefAttribution = NamedAttribution('charRef');
const seaWsAttribution = NamedAttribution('seaWs');
const openAttribution = NamedAttribution('open');
const xmlDeclOpenAttribution = NamedAttribution('xmlDeclOpen');
const textAttribution = NamedAttribution('text');
const closeAttribution = NamedAttribution('close');
const specialCloseAttribution = NamedAttribution('specialClose');
const slashCloseAttribution = NamedAttribution('slashClose');
const slashAttribution = NamedAttribution('slash');
const equalsAttribution = NamedAttribution('equals');
const stringAttribution = NamedAttribution('string');
const nameAttribution = NamedAttribution('name');
const sAttribution = NamedAttribution('s');
const piAttribution = NamedAttribution('pi');

NamedAttribution _tokenTypeAttributions(TokenType type) {
  switch (type) {
    case TokenType.comment:
      return commentAttribution;
    case TokenType.cdata:
      return cdataAttribution;
    case TokenType.dtd:
      return dtdAttribution;
    case TokenType.entityRef:
      return entityRefAttribution;
    case TokenType.charRef:
      return charRefAttribution;
    case TokenType.seaWs:
      return seaWsAttribution;
    case TokenType.open:
      return openAttribution;
    case TokenType.xmlDeclOpen:
      return xmlDeclOpenAttribution;
    case TokenType.text:
      return textAttribution;
    case TokenType.close:
      return closeAttribution;
    case TokenType.specialClose:
      return specialCloseAttribution;
    case TokenType.slashClose:
      return slashCloseAttribution;
    case TokenType.slash:
      return slashAttribution;
    case TokenType.equals:
      return equalsAttribution;
    case TokenType.string:
      return stringAttribution;
    case TokenType.name:
      return nameAttribution;
    case TokenType.s:
      return sAttribution;
    case TokenType.pi:
      return piAttribution;
  }
}

List<SpanMarker> _syntaxHighlight(String svg) {
  final tokens = tokenize(svg: svg);
  final spans = <SpanMarker>[
    ...tokens.map((token) => SpanMarker(
        attribution: _tokenTypeAttributions(token.type),
        offset: token.startIndex,
        markerType: SpanMarkerType.start)),
    ...tokens.map((token) => SpanMarker(
        attribution: _tokenTypeAttributions(token.type),
        offset: token.stopIndex,
        markerType: SpanMarkerType.end))
  ];
  spans.sort(((a, b) => a.offset.compareTo(b.offset)));
  return spans;
}

class _MyHomePageState extends State<MyHomePage> {
  late AttributedTextEditingController textController;

  @override
  void initState() {
    textController = AttributedTextEditingController(
      text: AttributedText(
        text: '',
        spans: AttributedSpans(
          attributions: const [],
        ),
      ),
    );
    textController.addListener(() async {
      final textToHighlight = textController.text.text;
      final attributions = await compute(_syntaxHighlight, textToHighlight);
      if (textController.text.text == textToHighlight) {
        textController.text = AttributedText(
            text: textController.text.text,
            spans: AttributedSpans(attributions: attributions));
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SuperTextField testing'),
      ),
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SuperTextField(
            controlsColor: Theme.of(context).focusColor,
            lineHeight: 24,
            minLines: 1,
            maxLines: 10,
            textController: textController,
            textStyleBuilder: (attributes) {
              final base = Theme.of(context).textTheme.bodyMedium!;
              if (attributes.contains(stringAttribution)) {
                return base.copyWith(color: Colors.blue[300]);
              }
              if (attributes.contains(nameAttribution)) {
                return base.copyWith(color: Colors.green[600]);
              }
              return base;
            },
          ),
        ),
      ),
    );
  }
}
