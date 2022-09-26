import 'package:svg_highlight/svg_highlight.dart';
import 'package:test/test.dart';

void main() {
  group('Tokenization tests', () {
    test('Tokenize simpleSVG', () {
      final tokens = tokenize(svg: simpleSVG);
      expect(tokens.length, 74);

      expect(tokens[0].startIndex, 0);
      expect(tokens[0].stopIndex, 0);
      expect(tokens[0].text, '<');
      expect(tokens[0].type, TokenType.open);

      expect(tokens[1].startIndex, 1);
      expect(tokens[1].stopIndex, 3);
      expect(tokens[1].text, 'svg');
      expect(tokens[1].type, TokenType.name);

      expect(tokens[2].startIndex, 5);
      expect(tokens[2].stopIndex, 11);
      expect(tokens[2].text, 'version');
      expect(tokens[2].type, TokenType.name);

      expect(tokens[3].startIndex, 12);
      expect(tokens[3].stopIndex, 12);
      expect(tokens[3].text, '=');
      expect(tokens[3].type, TokenType.equals);

      expect(tokens[4].startIndex, 13);
      expect(tokens[4].stopIndex, 17);
      expect(tokens[4].text, '"1.1"');
      expect(tokens[4].type, TokenType.string);

      final tokenTypes = <TokenType>{};

      for (final token in tokens) {
        tokenTypes.add(token.type);
      }
      expect(tokenTypes.length, 9);
      expect(tokenTypes, {
        TokenType.open,
        TokenType.name,
        TokenType.equals,
        TokenType.string,
        TokenType.close,
        TokenType.seaWs,
        TokenType.slashClose,
        TokenType.text,
        TokenType.slash,
      });
    });
  });
}

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
