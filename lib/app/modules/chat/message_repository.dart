// import 'package:cambridge_school/modules/chat/string_constants.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart';
//
// import 'message_model.dart';
//
//
// class MessageRepository {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final _logger = Logger();
//
//
//   // Send Message
//   Future<void> sendMessage(String receiverId, String text, MessageType type, {PollData? poll}) async {
//     try {
//       final message = ChatMessage(
//         messageId: DateTime.now().toIso8601String(),
//         senderId: _auth.currentUser!.uid,
//         chatId: _getChatId(_auth.currentUser!.uid, receiverId),
//         text: text,
//         timestamp: Timestamp.now(),
//         type: type,
//         poll: poll,
//         status: MessageStatus.sent,
//       );
//
//       await _firestore.collection('chats').doc(_getChatId(_auth.currentUser!.uid, receiverId)).collection('messages').doc(message.messageId).set(message.toJson());
//
//       final chat = await _firestore.collection('chats').doc(_getChatId(_auth.currentUser!.uid, receiverId)).get();
//       if(!chat.exists){
//         await _firestore.collection('chats').doc(_getChatId(_auth.currentUser!.uid, receiverId)).set({
//           "chatId":  _getChatId(_auth.currentUser!.uid, receiverId),
//           "type": "single",
//           "members": [_auth.currentUser!.uid, receiverId],
//         });
//       }
//       await _firestore.collection('chats').doc(_getChatId(_auth.currentUser!.uid, receiverId)).update({
//         'lastMessage': text,
//         'lastSender':  _auth.currentUser!.uid,
//         'lastTimestamp':  Timestamp.now(),
//       });
//     } catch (e) {
//       _logger.e(e);
//       throw Exception(StringConstants.somethingWentWrong);
//     }
//   }
//
//
//   // Stream Messages
//   Stream<List<ChatMessage>> getMessages(String chatId) {
//     return _firestore.collection('chats').doc(chatId).collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((querySnapshot) {
//       return querySnapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
//     });
//   }
//
//   // Stream Messages
//   Stream<List<ChatMessage>> getMessagesByAsc(String chatId) {
//     return _firestore.collection('chats').doc(chatId).collection('messages')
//         .orderBy('timestamp', descending: false)
//         .snapshots()
//         .map((querySnapshot) {
//       return querySnapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
//     });
//   }
//   // Stream Messages
//   Stream<List<ChatMessage>> getLatestMessageByContact(String receiverId) {
//     return _firestore.collection('chats').doc(_getChatId(_auth.currentUser!.uid, receiverId)).collection('messages')
//         .orderBy('timestamp', descending: true)
//         .limit(1)
//         .snapshots()
//         .map((querySnapshot) {
//       return querySnapshot.docs.map((doc) => ChatMessage.fromFirestore(doc)).toList();
//     });
//   }
//
//   Stream<int> getUnreadMessagesCount(String senderId) {
//     return  _firestore.collection('chats')
//         .where('members', arrayContains: senderId)
//         .snapshots()
//         .asyncMap((event) async {
//       int total = 0;
//       for (var doc in event.docs) {
//         final snapshot =  await _firestore.collection('chats').doc(doc.id)
//             .collection('messages')
//             .get();
//         for(var docs in snapshot.docs)
//         {
//           final data = docs.data();
//           if(data['senderId'] != senderId && data['status'] != "read")
//           {
//             total++;
//           }
//         }
//       }
//       return total;
//     });
//   }
//   // Update Message Status
//   Future<void> updateMessageStatus(String chatId, String messageId, MessageStatus status) async {
//     try{
//       await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).update({
//         'status': status.toString().split('.').last,
//       });
//     } catch (e) {
//       _logger.e(e);
//       throw Exception(StringConstants.somethingWentWrong);
//     }
//   }
//   Future<void> deleteMessage(String chatId, String messageId) async {
//     try{
//       await _firestore.collection('chats').doc(chatId).collection('messages').doc(messageId).delete();
//     } catch (e) {
//       _logger.e(e);
//       throw Exception(StringConstants.somethingWentWrong);
//     }
//   }
//   String _getChatId(String senderId, String receiverId) {
//     if(senderId.hashCode <= receiverId.hashCode)
//     {
//       return "${senderId}_${receiverId}";
//     }
//     return "${receiverId}_${senderId}";
//   }
// }