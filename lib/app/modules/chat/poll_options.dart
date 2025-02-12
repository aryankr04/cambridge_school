// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'chat_screen_controller.dart';
// import 'message_model.dart';
//
//
// class PollOption extends StatelessWidget {
//   final ChatMessage message;
//   final String option;
//   final ChatScreenController chatScreenController = Get.find();
//   PollOption({super.key, required this.message, required this.option});
//   @override
//   Widget build(BuildContext context) {
//     int totalVotes = message.poll?.votes.length ?? 0;
//     int optionVotes = message.poll?.votes.values.where((voteList) => voteList.contains(option)).length ?? 0;
//     double percentage = totalVotes > 0 ? optionVotes / totalVotes : 0;
//     return RadioListTile(
//       title: Row(
//         children: [
//           Expanded(child: Text(option)),
//           Text('${(percentage * 100).toStringAsFixed(1)}%'),
//         ],
//       ),
//       secondary:  SizedBox(
//         width: 100,
//         child: LinearProgressIndicator(value: percentage),
//       ),
//       value: option,
//       groupValue: message.poll?.votes?[chatScreenController.userId]?.first ,
//       onChanged: (value) {
//         if(value != null)
//         {
//           chatScreenController.castVote(message, value);
//         }
//       },
//     );
//   }
// }