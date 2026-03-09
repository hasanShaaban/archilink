import 'package:intl/intl.dart';

String formatPostDate(String dateString) {
  final postDate = DateTime.parse(dateString).toLocal();
  final now = DateTime.now();

  final difference = now.difference(postDate);

  // Less than 1 hour
  if (difference.inMinutes < 60) {
    final minutes = difference.inMinutes;
    return '${minutes}min ago';
  }

  // Less than 24 hours
  if (difference.inHours < 24) {
    final hours = difference.inHours;
    return '${hours}h ago';
  }

  // Less than 7 days
  if (difference.inDays < 7) {
    final days = difference.inDays;
    return '${days} day${days > 1 ? 's' : ''} ago';
  }

  // Less than 1 year
  if (difference.inDays < 365) {
    return DateFormat('d MMM').format(postDate);
  }

  // Older than 1 year
  return DateFormat('d MMM yyyy').format(postDate);
}