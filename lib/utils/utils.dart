import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String calculateGroupeChatId(String user1, String user2) {
  String groupChatId;

  if (user2.hashCode <= user1.hashCode) {
    groupChatId = '$user2-$user1';
  } else {
    groupChatId = '$user1-$user2';
  }
  return groupChatId;
}

String eventDateFormat(DateTime date) {
  final DateFormat formatter = DateFormat('dd MMM yyyy – kk:mm');
  return formatter.format(date);
}

String eventCardDateFormat(Timestamp date) {
  final DateTime tempDay2 = date.toDate();
  final DateFormat formatter = DateFormat('dd LLLL');
  final String formatted = formatter.format(tempDay2);
  return formatted;
}
