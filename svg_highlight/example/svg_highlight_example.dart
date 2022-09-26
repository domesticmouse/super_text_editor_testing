import 'package:svg_highlight/svg_highlight.dart';
import 'package:timing/timing.dart';

void main() {
  // From https://developer.mozilla.org/en-US/docs/Web/SVG/Tutorial/Getting_Started
  const simpleSVG = '''
<svg version="1.1"
     width="300" height="200"
     xmlns="http://www.w3.org/2000/svg">

  <rect width="100%" height="100%" fill="red" />

  <circle cx="150" cy="100" r="80" fill="green" />

  <text x="150" y="125" font-size="60" text-anchor="middle" fill="white">SVG</text>

</svg>
''';

  final tracker = SyncTimeTracker();
  final tokens = <Token>[];
  tracker.track(() {
    tokens.addAll(tokenize(svg: simpleSVG));
  });
  for (final token in tokens) {
    print('''
${token.startIndex},${token.stopIndex} ${token.type.name}: '${token.text?.replaceAll('\r', '\\r').replaceAll('\n', '\\n')}\'''');
  }
  print('Time to tokenize: ${tracker.duration.inMilliseconds}ms');
}
