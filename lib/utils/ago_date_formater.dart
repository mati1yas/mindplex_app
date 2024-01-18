import 'package:intl/intl.dart';

String formatCommentDate(String dateString) {
  var commentDate = DateTime.parse("${dateString}Z").toLocal();
  var now = DateTime.now();
  final duration = now.difference(commentDate);
  if (duration.inHours < 1) {
    return "${duration.inMinutes} minutes ago";
  } else if (duration.inDays < 1) {
    return "${duration.inHours} hr${duration.inHours == 1 ? '' : 's'} ago";
  } else if (duration.inDays < 9) {
    return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ago';
  } else if (duration.inDays < 365) {
    return DateFormat.MMMd().format(commentDate);
  } else {
    return DateFormat.yMMMd().format(commentDate);
  }
}
