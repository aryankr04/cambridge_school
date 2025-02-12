// // presentation/screens/contact_list_screen.dart
// import 'package:cambridge_school/core/utils/constants/sizes.dart';
// import 'package:cambridge_school/core/widgets/text_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'auth_controller.dart';
// import 'contact_card.dart';
// import 'contact_list_controller.dart';
//
// class ContactListScreen extends StatelessWidget {
//   final ContactListController contactListController =
//   Get.put(ContactListController());
//   final AuthController authController = Get.find();
//   ContactListScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chats'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () => authController.logout(),
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(SchoolSizes.lg),
//             child: SchoolTextFormField(
//               onChanged: (value) {
//                 contactListController.searchContact(value);
//               },
//               hintText: 'Search...',
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (contactListController.loading.value) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }
//               if (contactListController.contacts.isEmpty) {
//                 return const Center(
//                   child: Text("No Chats Available"),
//                 );
//               }
//               return ListView.builder(
//                 itemCount: contactListController.contacts.length,
//                 itemBuilder: (context, index) {
//                   return ContactCard(
//                       contact: contactListController.contacts[index]);
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => showNewContactDialog(context),
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
//
//   void showNewContactDialog(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           final _searchController = TextEditingController();
//           return AlertDialog(
//             title: const Text('Add new chat user'),
//             content: TextField(
//               controller: _searchController,
//               decoration: const InputDecoration(
//                 hintText: 'Search user by name',
//               ),
//               onChanged: (value) {
//                 contactListController.searchContact(value);
//               },
//             ),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     contactListController.searchContact('');
//                   },
//                   child: const Text('Cancel')),
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     if (contactListController.contacts.isNotEmpty) {
//                       contactListController.searchContact('');
//                     }
//                   },
//                   child: const Text('Add')),
//             ],
//           );
//         });
//   }
// }