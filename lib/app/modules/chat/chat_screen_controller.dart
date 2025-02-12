// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'dart:io';
// import 'contact_list_screen.dart';
// import 'message_model.dart';
// import 'message_repository.dart';
//
//
// class ChatScreenController extends GetxController {
//   final MessageRepository _messageRepository = MessageRepository();
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//   String? receiverId;
//   var messages = <ChatMessage>[].obs;
//   late final Stream<List<ChatMessage>> _messageStream;
//   late final BehaviorSubject<List<ChatMessage>> _messageSubject = BehaviorSubject<List<ChatMessage>>();
//   ScrollController scrollController = ScrollController();
//   var unreadMessagesCount = 0.obs;
//   List<String> pollOptions = ["Yes", "No"].obs;
//   ChatMessage? replyMessage;
//   final RxList<ChatMessage> selectedMessages = <ChatMessage>[].obs;
//
//   void init(String receiverId) {
//     this.receiverId = receiverId;
//     _messageStream = _messageRepository.getMessagesByAsc(_getChatId(userId!, receiverId));
//     _messageStream.listen((event) {
//       messages.value = event;
//       _messageSubject.add(messages);
//       markMessagesAsRead();
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         scrollToBottom();
//       });
//     });
//     _messageRepository.getUnreadMessagesCount(userId!).listen((count) {
//       unreadMessagesCount.value = count;
//     });
//   }
//   void markMessagesAsRead() {
//     for (var message in messages) {
//       if (message.senderId != userId && message.status != MessageStatus.read) {
//         _messageRepository.updateMessageStatus(
//             message.chatId,
//             message.messageId,
//             MessageStatus.read
//         );
//       }
//     }
//   }
//
//   void sendMessage(String text, MessageType type) async {
//     if(type == MessageType.text)
//     {
//       _messageRepository.sendMessage(receiverId!, text, type);
//       setReplyMessage(null);
//     }
//     else if (type == MessageType.poll) {
//       sendPoll(text);
//     }
//     else if (type == MessageType.image || type == MessageType.audio || type == MessageType.document || type == MessageType.video) {
//       final pickedFile = await pickFile(type.toString());
//       if(pickedFile != null)
//       {
//         String fileUrl = await uploadFile(pickedFile.path);
//         _messageRepository.sendMessage(receiverId!, fileUrl, type);
//       }
//     }
//   }
//   Future<XFile?> pickFile(String type) async {
//     if (type == 'image') {
//       return  await ImagePicker().pickImage(source: ImageSource.gallery);
//     } else if(type == 'audio'){
//       return await ImagePicker().pickVideo(source: ImageSource.gallery);
//     } else if (type == 'video') {
//       return await ImagePicker().pickVideo(source: ImageSource.gallery);
//     }
//     else if(type == 'document'){
//       return await ImagePicker().pickMedia();
//     }
//     return null;
//   }
//
//   Future<String> uploadFile(String filePath) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref();
//       final file = File(filePath);
//       final fileRef = storageRef.child(DateTime.now().toIso8601String());
//       await fileRef.putFile(file);
//       final fileUrl = await fileRef.getDownloadURL();
//       return fileUrl;
//     }
//     catch(e)
//     {
//       return '';
//     }
//   }
//
//   void scrollToBottom() {
//     if (scrollController.hasClients) {
//       scrollController.animateTo(
//         scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }
//   void sendPoll(String text) {
//     final message = ChatMessage(
//       messageId: DateTime.now().toIso8601String(),
//       senderId: userId!,
//       chatId:  _getChatId(userId!, receiverId!),
//       text: text,
//       timestamp: Timestamp.now(),
//       type:MessageType.poll,
//       status: MessageStatus.sent,
//       poll: PollData(options: pollOptions, allowMultiple: false, votes: {}),
//     );
//     _firestore.collection('chats').doc(_getChatId(userId!, receiverId!)).collection('messages').doc(message.messageId).set(message.toJson());
//     _firestore.collection('chats').doc(_getChatId(userId!, receiverId!)).update({
//       'lastMessage': text,
//       'lastSender':  userId,
//       'lastTimestamp': Timestamp.now(),
//     });
//   }
//   void castVote(ChatMessage message, String option) async {
//     final updatedVotes = message.poll?.votes ?? {};
//     updatedVotes[userId!] = [option];
//     final updatedPoll = message.poll?.copyWith(votes: updatedVotes);
//     await _firestore.collection('chats').doc(message.chatId).collection('messages').doc(message.messageId).update({
//       'poll': updatedPoll?.toJson()
//     });
//   }
//   void setReplyMessage(ChatMessage? message) {
//     replyMessage = message;
//     update();
//   }
//   void addSelectedMessage(ChatMessage message) {
//     selectedMessages.add(message);
//   }
//
//   void removeSelectedMessage(ChatMessage message) {
//     selectedMessages.remove(message);
//   }
//   Future<void> deleteSelectedMessages() async {
//     Get.dialog(AlertDialog(
//       title: const Text('Delete Messages?'),
//       content: const Text('Do you want to delete the selected messages?'),
//       actions: [
//         TextButton(
//           onPressed: ()=> Get.back(),
//           child: const Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: (){
//             _deleteMessages();
//             Get.back();
//           },
//           child: const Text('Delete'),
//         )
//       ],
//     ));
//   }
//   Future<void> _deleteMessages() async {
//     for(ChatMessage message in selectedMessages)
//     {
//       await _messageRepository.deleteMessage(message.chatId, message.messageId);
//     }
//     selectedMessages.clear();
//   }
//   Future<void> forwardSelectedMessage() async {
//     Get.to(()=> ContactListScreen());
//   }
//   @override
//   void onClose() {
//     super.onClose();
//     _messageSubject.close();
//   }
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String _getChatId(String senderId, String receiverId) {
//     if(senderId.hashCode <= receiverId.hashCode)
//     {
//       return "${senderId}_${receiverId}";
//     }
//     return "${receiverId}_${senderId}";
//   }
// }