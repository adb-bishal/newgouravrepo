class TextTemplateParser {
  static Map<String, List<String>> extractPlaceholdersAndText(String input) {
    RegExp regExp = RegExp(r'{{(.*?)}}');

    List<String> placeholders = [];
    List<String> textParts = [];

    int lastIndex = 0;

    for (final match in regExp.allMatches(input)) {
      // Add text before the placeholder
      if (match.start > lastIndex) {
        textParts.add(input.substring(lastIndex, match.start));
      }

      // Add the placeholder (without {{}} braces)
      placeholders.add(match.group(1)!);

      lastIndex = match.end;
    }

    // Add any remaining text after the last placeholder
    if (lastIndex < input.length) {
      textParts.add(input.substring(lastIndex));
    }

    return {
      'placeholders': placeholders,
      'text': textParts,
    };
  }
}
