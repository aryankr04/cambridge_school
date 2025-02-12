// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../repositories/chat_repository.dart';
// import '../models/message_model.dart';
//
// class ChatController extends GetxController {
//   final ChatRepository _chatRepository = ChatRepository();
//   final messages = <MessageModel>[].obs;
//   final isLoading = false.obs;
//   final selectedMessage = Rxn<MessageModel>();
//
//   Stream<List<MessageModel>> getMessages(String chatId) {
//     return _chatRepository.getMessages(chatId);
//   }
//
//   Future<void> sendMessage(String chatId, String content) async {
//     try {
//       await _chatRepository.sendMessage(
//         chatId: chatId,
//         content: content,
//         type: MessageType.text,
//         replyTo: selectedMessage.value?.id,
//       );
//       selectedMessage.value = null;
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send message');
//     }
//   }
//
//   Future<void> sendMediaMessage(String chatId, ImageSource source) async {
//     try {
//       final ImagePicker picker = ImagePicker();
//       final XFile? image = await picker.pickImage(source: source);
//
//       if (image != null) {
//         isLoading.value = true;
//         await _chatRepository.sendMessage(
//           chatId: chatId,
//           content: 'Image',
//           type: MessageType.image,
//           mediaFile: File(image.path),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send image');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   void setReplyMessage(MessageModel message) {
//     selectedMessage.value = message;
//   }
//
//   Future<void> reactToMessage(
//     String chatId,
//     String messageId,
//     String reaction,
//   ) async {
//     try {
//       await _chatRepository.updateMessageReaction(chatId, messageId, reaction);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to add reaction');
//     }
//   }
//
//   Future<void> deleteMessage(String chatId, String messageId) async {
//     try {
//       await _chatRepository.deleteMessage(chatId, messageId);
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to delete message');
//     }
//   }
//
//   Future<void> markAsRead(String chatId, String messageId) async {
//     try {
//       await _chatRepository.markMessageAsRead(chatId, messageId);
//     } catch (e) {
//       print('Error marking message as read: $e');
//     }
//   }
// }