// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
// import 'package:image_picker/image_picker.dart';
//
// import '../../core/utils/constants/colors.dart';
// import '../../core/utils/constants/dynamic_colors.dart';
// import 'chat_screen_controller.dart';
// import 'message_model.dart';
//
// class MessageInput extends StatefulWidget {
//   final Function(String) onSend;
//
//   const MessageInput({super.key, required this.onSend});
//
//   @override
//   State<MessageInput> createState() => _MessageInputState();
// }
//
// class _MessageInputState extends State<MessageInput> {
//   final _messageController = TextEditingController();
//   final ChatScreenController chatScreenController = Get.find();
//   bool _showEmojiPicker = false;
//   bool _isTyping = false;
//   final _focusNode = FocusNode();
//
//   @override
//   void dispose() {
//     super.dispose();
//     _messageController.dispose();
//     _focusNode.dispose();
//   }
//
//   void _showOptionsBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//         context: context,
//         builder: (context) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 ListTile(
//                     onTap: () {
//                       chatScreenController.sendMessage('', MessageType.image);
//                       Navigator.of(context).pop();
//                     },
//                     leading: const Icon(Icons.image),
//                     title: const Text('Image')),
//                 ListTile(
//                     onTap: () {
//                       chatScreenController.sendMessage('', MessageType.audio);
//                       Navigator.of(context).pop();
//                     },
//                     leading: const Icon(Icons.mic),
//                     title: const Text('Audio')),
//                 ListTile(
//                     onTap: () {
//                       chatScreenController.sendMessage('', MessageType.video);
//                       Navigator.of(context).pop();
//                     },
//                     leading: const Icon(Icons.video_call_outlined),
//                     title: const Text('Video')),
//                 ListTile(
//                     onTap: () {
//                       _createPoll(context);
//                       Navigator.of(context).pop();
//                     },
//                     leading: const Icon(Icons.poll),
//                     title: const Text('Poll')),
//                 ListTile(
//                     onTap: () {
//                       chatScreenController.sendMessage(
//                           '', MessageType.document);
//                       Navigator.of(context).pop();
//                     },
//                     leading: const Icon(Icons.document_scanner),
//                     title: const Text('Document')),
//               ],
//             ),
//           );
//         });
//   }
//
//   Future<void> _pickMultipleMedia() async {
//     final ImagePicker picker = ImagePicker();
//     final List<XFile> files = await picker.pickMultipleMedia();
//     if (files.isNotEmpty) {
//       for (XFile file in files) {
//         String fileUrl = await chatScreenController.uploadFile(file.path);
//         if (file.path.contains('.mp4')) {
//           chatScreenController.sendMessage(fileUrl, MessageType.video);
//         } else if (file.path.contains('.aac') || file.path.contains('.mp3')) {
//           chatScreenController.sendMessage(fileUrl, MessageType.audio);
//         } else {
//           chatScreenController.sendMessage(fileUrl, MessageType.image);
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         if (chatScreenController.replyMessage != null)
//           Container(
//             padding: const EdgeInsets.all(5),
//             color: Colors.grey[100],
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         chatScreenController.replyMessage!.senderId ==
//                                 chatScreenController.userId
//                             ? 'You'
//                             : 'User',
//                         style: const TextStyle(fontWeight: FontWeight.bold)),
//                     Text(
//                       chatScreenController.replyMessage!.text!,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontSize: 12),
//                     ),
//                   ],
//                 ),
//                 IconButton(
//                     onPressed: () {
//                       chatScreenController.setReplyMessage(null);
//                     },
//                     icon: const Icon(Icons.close))
//               ],
//             ),
//           ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 8.0),
//           margin: const EdgeInsets.all(8.0),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(48),
//             color: SchoolDynamicColors.backgroundColorWhiteDarkGrey,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 spreadRadius: 2,
//                 blurRadius: 5,
//                 offset: const Offset(0, 3),
//               ),
//             ],
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _showEmojiPicker = !_showEmojiPicker;
//                       if (_showEmojiPicker) {
//                         FocusScope.of(context).unfocus();
//                       }
//                     });
//                   },
//                   icon: Icon(Icons.emoji_emotions_outlined,
//                       color: _showEmojiPicker
//                           ? SchoolColors.activeBlue
//                           : Colors.black54)),
//               Flexible(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                   child: Container(
//                     constraints: BoxConstraints(maxHeight: Get.width * 0.5),
//                     child: Expanded(
//                       child: Scrollbar(
//                         thumbVisibility: true,
//                         child: TextField(
//                           focusNode: _focusNode,
//                           keyboardType: TextInputType.multiline,
//                           maxLines: null,
//                           controller: _messageController,
//                           onChanged: (text) {
//                             if (text.trim().isNotEmpty != _isTyping) {
//                               setState(() {
//                                 _isTyping = text.trim().isNotEmpty;
//                               });
//                             }
//                           },
//                           onSubmitted: (text) {
//                             _sendMessage();
//                           },
//                           onTap: () {
//                             setState(() {
//                               _showEmojiPicker = false;
//                             });
//                           },
//                           style: Theme.of(context)
//                               .textTheme
//                               .titleLarge
//                               ?.copyWith(
//                                   fontSize: 18, fontWeight: FontWeight.w400),
//                           decoration: const InputDecoration(
//                             hintText: 'Type a message',
//                             filled: false,
//                             contentPadding: EdgeInsets.symmetric(
//                                 vertical: 12.0, horizontal: 4),
//                             border: InputBorder.none,
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide.none,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               if (!_isTyping)
//                 IconButton(
//                     onPressed: () {
//                       _showOptionsBottomSheet(context);
//                     },
//                     icon: const Icon(Icons.camera_alt_outlined)),
//               if (_isTyping)
//                 IconButton(
//                     onPressed: () {
//                       _pickMultipleMedia();
//                     },
//                     icon: const Icon(
//                       Icons.image,
//                       color: SchoolColors.activeBlue,
//                     )),
//               IconButton(
//                   onPressed: () {
//                     _sendMessage();
//                   },
//                   icon: const Icon(
//                     Icons.send,
//                     color: SchoolColors.activeBlue,
//                   )),
//             ],
//           ),
//         ),
//         if (_showEmojiPicker)
//           SizedBox(
//             height: 250,
//             child: EmojiPicker(
//                 onEmojiSelected: (category, emoji) {
//                   setState(() {
//                     _messageController.text =
//                         _messageController.text + emoji.emoji;
//                   });
//                 },
//                 config: const Config(
//                   height: 256,
//                   emojiViewConfig: EmojiViewConfig(emojiSizeMax: 28),
//                 )),
//           )
//       ],
//     );
//   }
//
//   void _sendMessage() {
//     if (_messageController.text.trim().isNotEmpty) {
//       widget.onSend(_messageController.text);
//       _messageController.clear();
//       setState(() {
//         _isTyping = false;
//       });
//     }
//   }
//
//   void _createPoll(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (context) {
//           final _pollController = TextEditingController();
//           return AlertDialog(
//             title: const Text('Create a poll'),
//             content: TextField(
//                 controller: _pollController,
//                 decoration:
//                     const InputDecoration(hintText: 'Ask a question...')),
//             actions: [
//               TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel')),
//               ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     chatScreenController.sendMessage(
//                         _pollController.text, MessageType.poll);
//                   },
//                   child: const Text('Create')),
//             ],
//           );
//         });
//   }
// }
