// import 'package:cambridge_school/core/utils/constants/colors.dart';
// import 'package:cambridge_school/core/utils/constants/sizes.dart';
// import 'package:cambridge_school/modules/chat/poll_options.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
// import 'package:video_player/video_player.dart';
// import 'package:audio_waveforms/audio_waveforms.dart';
//
// import 'chat_screen_controller.dart';
// import 'message_model.dart';
//
//
// class MessageBubble extends StatefulWidget {
//   final ChatMessage message;
//   final bool isMe;
//   final ChatMessage? replyToMessage;
//   const MessageBubble(
//       {super.key,
//         required this.message,
//         required this.isMe,
//         this.replyToMessage});
//
//   @override
//   State<MessageBubble> createState() => _MessageBubbleState();
// }
//
// class _MessageBubbleState extends State<MessageBubble> {
//   final ChatScreenController chatScreenController = Get.find();
//   late VideoPlayerController _videoPlayerController;
//   bool _isVideoInitialized = false;
//   late PlayerController _playerController;
//   final  RxBool _isPlaying = false.obs;
//   final RxDouble _sliderValue = 0.0.obs;
//   final RxBool _isSelected = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.message.type == MessageType.video &&
//         widget.message.mediaUrl != null) {
//       _videoPlayerController =
//           VideoPlayerController.network(widget.message.mediaUrl!);
//       _videoPlayerController.initialize().then((value) {
//         _isVideoInitialized = true;
//       });
//     }
//     if (widget.message.type == MessageType.audio &&
//         widget.message.mediaUrl != null) {
//       _playerController = PlayerController();
//       _playerController.preparePlayer(path: widget.message.mediaUrl!);
//       _playerController.onCurrentDurationChanged.listen((duration) {
//         if (_playerController.playerState == PlayerState.playing) {
//           // _sliderValue.value = duration.inSeconds.toDouble();
//         }
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     if (widget.message.type == MessageType.video) {
//       _videoPlayerController.dispose();
//     }
//     if (widget.message.type == MessageType.audio) {
//       _playerController.dispose();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final align =
//     widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
//     final color = widget.isMe
//         ? SchoolColors.activeBlue.withOpacity(0.25)
//         : SchoolColors.white;
//     Widget messageContent;
//     if (widget.replyToMessage != null) {
//       messageContent = Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(5),
//           color: Colors.grey[100],
//         ),
//         padding: const EdgeInsets.all(5),
//         margin: const EdgeInsets.only(bottom: 5),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//                 widget.replyToMessage!.senderId == chatScreenController.userId
//                     ? 'You'
//                     : 'User',
//                 style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text(
//               widget.replyToMessage!.text!,
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontSize: 12),
//             ),
//           ],
//         ),
//       );
//     } else {
//       messageContent = const SizedBox.shrink();
//     }
//     if (widget.message.type == MessageType.text) {
//       messageContent = Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.replyToMessage != null) messageContent,
//           Text(
//             widget.message.text!,
//             style: const TextStyle(
//                 fontSize: 16, color: SchoolColors.headlineTextColor),
//           )
//         ],
//       );
//     } else if (widget.message.type == MessageType.image) {
//       messageContent =   Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.replyToMessage != null) messageContent,
//           ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: SizedBox(
//                 width: 250,
//                 child: Image.network(
//                   widget.message.mediaUrl!,
//                   fit: BoxFit.cover,
//                 ),
//               )
//           )
//         ],
//       );
//     } else if (widget.message.type == MessageType.audio) {
//       messageContent =  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.replyToMessage != null)
//             messageContent,
//           Row(
//             children: [
//               Obx(()=> IconButton(
//                 icon: Icon(_isPlaying.value ? Icons.pause : Icons.play_arrow),
//                 onPressed: () {
//                   if(_playerController.playerState == PlayerState.playing) {
//                     _playerController.pausePlayer();
//                     _isPlaying.value = false;
//                   } else {
//                     _playerController.startPlayer();
//                     _isPlaying.value = true;
//                   }
//                 },
//               ),),
//               SizedBox(
//                 width: 200,
//                 child: AudioFileWaveforms(
//                   size: const Size(200,50),
//                   playerController: _playerController,
//                   waveformType: WaveformType.long,
//                 ),
//               )
//             ],
//           ),
//           Obx(()=> Slider(
//             value: _sliderValue.value,
//             // max: _playerController.maxDuration.inSeconds.toDouble(),
//             onChanged: (double value) {
//               // _playerController.seekTo(Duration(seconds: value.toInt()));
//               _sliderValue.value = value;
//             },
//           ),),
//         ],
//       );
//     } else if (widget.message.type == MessageType.video) {
//       messageContent =  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.replyToMessage != null)
//             messageContent,
//           _isVideoInitialized
//               ? Stack(
//               alignment: Alignment.center,
//               children:[
//                 SizedBox(
//                   height: 200,
//                   child: ClipRRect(
//                       borderRadius:  BorderRadius.circular(10),
//                       child: AspectRatio(
//                         aspectRatio: _videoPlayerController.value.aspectRatio,
//                         child: VideoPlayer(_videoPlayerController),
//                       )
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     if (_videoPlayerController.value.isPlaying) {
//                       _videoPlayerController.pause();
//                     } else {
//                       _videoPlayerController.play();
//                     }
//                     setState(() {});
//                   },
//                   icon: Icon(
//                       _videoPlayerController.value.isPlaying
//                           ? Icons.pause_circle
//                           : Icons.play_circle,
//                       size: 60,
//                       color: Colors.white
//                   ),
//                 ),
//               ]
//           )
//               :  const Center(
//             child: CircularProgressIndicator(),
//           ),
//         ],
//       );
//     } else if (widget.message.type == MessageType.document) {
//       messageContent =
//           Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//             if (widget.replyToMessage != null) messageContent,
//             const Icon(
//               Icons.description,
//               size: 60,
//               color: Colors.black,
//             )
//           ]);
//     } else if (widget.message.type == MessageType.poll) {
//       messageContent =  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.replyToMessage != null) messageContent,
//           Text(
//             widget.message.text!,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           for (var option in widget.message.poll?.options ?? [])
//             PollOption(message: widget.message, option: option)
//         ],
//       );
//     } else {
//       messageContent = const Text("Unsupported Message Type");
//     }
//     return GestureDetector(
//       onLongPress: () {
//         _isSelected.value = !_isSelected.value;
//         if (_isSelected.value) {
//           chatScreenController.addSelectedMessage(widget.message);
//         } else {
//           chatScreenController.removeSelectedMessage(widget.message);
//         }
//       },
//       onTap: () {
//         if(chatScreenController.selectedMessages.isNotEmpty) {
//           _isSelected.value = !_isSelected.value;
//           if (_isSelected.value) {
//             chatScreenController.addSelectedMessage(widget.message);
//           } else {
//             chatScreenController.removeSelectedMessage(widget.message);
//           }
//         }
//       },
//       child: Obx(()=> Container(
//         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         decoration: _isSelected.value ? BoxDecoration(
//             // border: Border.all(color: SchoolColors.activeBlue, width: 1.5),
//             color: SchoolColors.activeBlue.withOpacity(0.1),
//             borderRadius: BorderRadius.circular(10)
//         ) : null,
//         child: Column(
//           crossAxisAlignment: align,
//           children: [
//             Card(
//               elevation: 1,
//               child: Container(
//                   constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width * 0.7),
//                   decoration: BoxDecoration(
//                     color: color,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   padding:
//                   const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                   child: messageContent
//               ),
//             ),
//             Row(
//               mainAxisSize: MainAxisSize.min,
//               mainAxisAlignment: widget.isMe
//                   ? MainAxisAlignment.end
//                   : MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 5),
//                   child: Text(DateFormat('hh:mm a').format(widget.message.timestamp.toDate()), style: const TextStyle(fontSize: 12, color: Colors.grey)),
//                 ),
//                 const SizedBox(
//                   width: SchoolSizes.sm,
//                 ),
//                 if (widget.isMe)
//                   Icon(
//                     widget.message.status == MessageStatus.read
//                         ? Icons.done_all
//                         : Icons.done,
//                     size: 12,
//                     color: widget.message.status == MessageStatus.read
//                         ? SchoolColors.activeBlue
//                         : SchoolColors.grey,
//                   ),
//               ],
//             )
//           ],
//         ),
//       )),
//     );
//   }
// }