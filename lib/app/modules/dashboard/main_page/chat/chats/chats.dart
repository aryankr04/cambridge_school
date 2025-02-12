import 'package:cambridge_school/core/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import '../../../../../../core/utils/constants/dynamic_colors.dart';
import '../../../../../../core/utils/constants/sizes.dart';
import 'chatting_screen.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: GestureDetector(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                    Radius.circular(MySizes.cardRadiusLg)),
                color: MyDynamicColors.activeBlue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: const Offset(0, 6),
                  ),
                ]),
            padding: const EdgeInsets.all(MySizes.md),
            child: const Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MySizes.spaceBtwItems,
              ),
              ChatListItem(
                  contactName: 'Aryan Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Rohit Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Arshad Shaikh',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Asad Alam',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Vedant Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Vedant Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Vedant Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Vedant Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
              ChatListItem(
                  contactName: 'Vedant Kumar',
                  lastMessage: 'hii',
                  time: '8:47 pm'),
            ],
          ),
        ));
  }
}

class ChatListItem extends StatelessWidget {
  final String contactName;
  final String lastMessage;
  final String time;

  const ChatListItem({
    super.key,
    required this.contactName,
    required this.lastMessage,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: MyColors.borderColor.withOpacity(0.1),
          border:Border.all(width: 1,color: MyColors.borderColor),
          // image: DecorationImage(
          //     image: AssetImage('assets/images/banners/Its_time_to_school.jpg'),
          //     fit: BoxFit.fill),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person,color: MyColors.darkGrey,),
      ),
      title: Text(
        contactName,
        style: Theme.of(context).textTheme.titleLarge,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
      subtitle: Text(
        lastMessage,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: MyDynamicColors.subtitleTextColor, fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: 5.0),
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: MyDynamicColors.activeGreen,
              shape: BoxShape.circle,
            ),
            child: const Text(
              '14', // Replace with actual unread message count
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatScreen()));
      },
    );
  }
}
