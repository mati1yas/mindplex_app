String processHtml(String htmlString) {
  final RegExp linkRegex = RegExp(
    r'\b(?:https?://|www\.)\S+\b',
    caseSensitive: false,
  );
  final matches = linkRegex.allMatches(htmlString);

  String processedHtml = htmlString;
  matches.forEach((match) {
    final url = match.group(0);
    final wrappedLink =
        '<a href="$url"  target="_blank" rel="noreferrer noopener">$url</a>';
    processedHtml =
        processedHtml.replaceFirst(url!, wrappedLink + "&nbsp;&nbsp;&nbsp; ");
  });

  final containsAnchorTags = htmlString.contains('<a ');
  if (containsAnchorTags) {
    return htmlString;
  }
  return processedHtml;
}
