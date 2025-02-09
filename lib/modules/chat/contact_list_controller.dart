// import 'package:get/get.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// import 'contact_model.dart';
// import 'contact_repository.dart';
// import 'message_model.dart';
// import 'message_repository.dart';
//
// class ContactListController extends GetxController {
//   final ContactRepository _contactRepository = ContactRepository();
//   final MessageRepository _messageRepository = MessageRepository();
//   var contacts = <ContactModel>[].obs;
//   var loading = true.obs;
//   var lastMessages = <String, ChatMessage?>{}.obs;
//   String? userId = FirebaseAuth.instance.currentUser?.uid;
//   var allContacts = <ContactModel>[].obs;
//   @override
//   void onInit() {
//     super.onInit();
//     fetchContacts();
//   }
//
//   Future<void> fetchContacts() async {
//     loading.value = true;
//     try {
//       allContacts.value = await _contactRepository.fetchContacts();
//       contacts.value = allContacts.value;
//       fetchLastMessages();
//     } catch (e) {
//       // Handle errors
//     } finally {
//       loading.value = false;
//     }
//   }
//   void fetchLastMessages() {
//     for (final contact in contacts) {
//       _messageRepository.getLatestMessageByContact(contact.id!)
//           .listen((messages) {
//         if(messages.isNotEmpty) {
//           lastMessages[contact.id!] = messages.first;
//         }
//       });
//     }
//   }
//
//   Stream<int> getUnreadMessages(String senderId)  {
//     return _messageRepository.getUnreadMessagesCount(senderId);
//   }
//   void searchContact(String value) {
//     if (value.isEmpty) {
//       contacts.value = allContacts;
//       return;
//     }
//     contacts.value = allContacts.where((contact) =>
//         contact.name.toLowerCase().contains(value.toLowerCase()),
//     ).toList();
//   }
//
//   String _getChatId(String senderId, String receiverId) {
//     if(senderId.hashCode <= receiverId.hashCode)
//     {
//       return "${senderId}_$receiverId";
//     }
//     return "${receiverId}_$senderId";
//   }
// }