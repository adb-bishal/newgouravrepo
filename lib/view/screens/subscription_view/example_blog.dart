import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlCommonWidget extends StatefulWidget {
  final String htmlData;
  final bool isDark;
  final double fontSize;

  const HtmlCommonWidget(
      {Key? key, required this.htmlData, required this.isDark, required this.fontSize})
      : super(key: key);

  @override
  State<HtmlCommonWidget> createState() => _HtmlCommonWidget();
}

class _HtmlCommonWidget extends State<HtmlCommonWidget> {
  List<String> colorTag = [
    "p",
    "span",
    "a",
    "colgroup",
    "strong",
    "h3",
    "hr",
    "h2",
    "h1",
    "h4",
    "h5",
    "h6",
    "ul",
    "li",
  ];
  List<String> colorBorder = ["td", "tr", "table"];

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      widget.htmlData,
      customStylesBuilder: (element) {
        // Check if the element has an inline font size and adjust it
        String? inlineFontSize = element.attributes['style'];
        if (inlineFontSize != null) {
          // Override the inline font size with the widget's fontSize
          inlineFontSize = inlineFontSize.replaceAll(RegExp(r'font-size:\s?\d+px'), 'font-size: ${widget.fontSize}px');
          element.attributes['style'] = inlineFontSize;
        }

        if (colorTag.contains(element.localName)) {
          return {
            'color': widget.isDark ? "white" : 'black',
            "font-size": "${widget.fontSize}px", // Apply dynamic font-size
          };
        }
        if (colorBorder.contains(element.localName)) {
          return {
            "border": "1pt solid black",
            "border-collapse": "collapse",
            "word-wrap": "break-word",
            "font-size": "20px", // This is just an example, change if needed
          };
        }
        return null;
      },
    );
  }
}
