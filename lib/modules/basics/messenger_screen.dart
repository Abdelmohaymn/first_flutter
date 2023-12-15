
import 'package:flutter/material.dart';

class MessengerScreen extends StatelessWidget{
  const MessengerScreen({super.key});

  final String img = 'https://static.wikia.nocookie.net/shingekinokyojin/images/7/73/Pieck_Finger_%28Anime%29_character_image.png/revision/latest/scale-to-width-down/1000?cb=20231105183352';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage('https://static.wikia.nocookie.net/shingekinokyojin/images/7/73/Pieck_Finger_%28Anime%29_character_image.png/revision/latest/scale-to-width-down/1000?cb=20231105183352'),
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              'Chats',
              style: TextStyle(
                color: Colors.black,
              ),
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () { },
            icon: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 15,
              child: Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            onPressed: () { },
            icon: CircleAvatar(
              backgroundColor: Colors.blue,
              radius: 15,
              child: Icon(
                Icons.edit,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey[300]
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      'Search'
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
                Container(
                  height: 100,
                  child: ListView.separated(
                    itemBuilder: (BuildContext context, int index) => storyItem(),
                    separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 10,),
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              const SizedBox(height: 10),
              ListView.separated(
                itemBuilder: (BuildContext context, int index) => chatItem(),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10,),
                itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget storyItem() => Container(
    width: 60.0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage('https://static.wikia.nocookie.net/shingekinokyojin/images/7/73/Pieck_Finger_%28Anime%29_character_image.png/revision/latest/scale-to-width-down/1000?cb=20231105183352'),
            ),
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 7,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 5,
              ),
            ),
          ],
        ),
        Text(
          'Pieck Fingerrrrrr',
          style: TextStyle(
              color: Colors.black
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,

        ),

      ],
    ),
  );

  Widget chatItem() => Row(
    children: [
      Container(
        width: 60.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://static.wikia.nocookie.net/shingekinokyojin/images/7/73/Pieck_Finger_%28Anime%29_character_image.png/revision/latest/scale-to-width-down/1000?cb=20231105183352'),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 7,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(width: 5,),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pieck Finger',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'ابعت المؤسس ي راينرررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررررر',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 10),),
                Text(
                  ' . 12:00 am',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ],
            )
          ],
        ),
      )

    ],
  );
}
