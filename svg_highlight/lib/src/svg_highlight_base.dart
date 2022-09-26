// For an in depth discussion on using ANTLR to parse XML, please
// see https://medium.com/@pragprog/parsing-and-lexing-xml-71836df5b8b2

// Or, for the full text, see Terrrence Parr's Definitie AMTLR4 Reference
// https://pragprog.com/titles/tpantlr2/the-definitive-antlr-4-reference/

import 'package:antlr4/antlr4.dart';

// XML Lexer derived from https://github.com/antlr/grammars-v4/blob/master/xml/XMLLexer.g4

// For detail on how to use ANTLR with Dart, see
// https://github.com/antlr/antlr4/blob/master/doc/dart-target.md

// In short:
//  $ antlr -Dlanguage=Dart g4

import 'xml_parser/XMLLexer.dart';

enum TokenType {
  comment(XMLLexer.TOKEN_COMMENT),
  cdata(XMLLexer.TOKEN_CDATA),
  dtd(XMLLexer.TOKEN_DTD),
  entityRef(XMLLexer.TOKEN_EntityRef),
  charRef(XMLLexer.TOKEN_CharRef),
  seaWs(XMLLexer.TOKEN_SEA_WS),
  open(XMLLexer.TOKEN_OPEN),
  xmlDeclOpen(XMLLexer.TOKEN_XMLDeclOpen),
  text(XMLLexer.TOKEN_TEXT),
  close(XMLLexer.TOKEN_CLOSE),
  specialClose(XMLLexer.TOKEN_SPECIAL_CLOSE),
  slashClose(XMLLexer.TOKEN_SLASH_CLOSE),
  slash(XMLLexer.TOKEN_SLASH),
  equals(XMLLexer.TOKEN_EQUALS),
  string(XMLLexer.TOKEN_STRING),
  name(XMLLexer.TOKEN_Name),
  s(XMLLexer.TOKEN_S),
  pi(XMLLexer.TOKEN_PI);

  const TokenType(this.id);
  final int id;

  static TokenType byId(int type) =>
      values.where((element) => element.id == type).first;
}

class Token {
  const Token({
    required this.type,
    required this.text,
    required this.startIndex,
    required this.stopIndex,
  });
  final TokenType type;
  final String? text;
  final int startIndex;
  final int stopIndex;
}

List<Token> tokenize({required String svg}) {
  XMLLexer.checkVersion();
  final input = InputStream.fromString(svg);
  final lexer = XMLLexer(input);
  final tokens = BufferedTokenStream(lexer);
  tokens.fill();
  return tokens.tokens
      .where((tok) => tok.type != -1)
      .map((tok) => Token(
          startIndex: tok.startIndex,
          stopIndex: tok.stopIndex,
          text: tok.text,
          type: TokenType.byId(tok.type)))
      .toList();
}
