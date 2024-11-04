import 'package:ducky_test/features/home/presentation/widgets/url_text_span.dart';
import 'package:flutter/material.dart';

TextSpan commentTextSpan(BuildContext context,{required String text}) {
  final linkRegex =
      RegExp(r'(https?:\/\/[^\s]+)', caseSensitive: false);
  final matches = linkRegex.allMatches(text);

  List<TextSpan> spans = [];
  int lastMatchEnd = 0;

  for (final match in matches) {
    // Add non-link text before this link
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(
          text: text.substring(lastMatchEnd, match.start),
          style: Theme.of(context).textTheme.bodyMedium));
    }
    // Add clickable link text
    final url = match.group(0)!;
    spans.add(urlTextSpan(url: url));

    // Update last match end position
    lastMatchEnd = match.end;
  }
  // Add any remaining text after the last link
  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd)));
  }
  return TextSpan(
      children: spans,
      style: Theme.of(context).textTheme.bodyMedium);
}
