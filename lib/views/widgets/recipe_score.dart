import '../../models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RecipeScoreScreen extends StatefulWidget {
  final Recipe recipe;

  const RecipeScoreScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  State<RecipeScoreScreen> createState() => _RecipeScoreScreenState();
}

class _RecipeScoreScreenState extends State<RecipeScoreScreen> {
  late List<Score> scores;

  @override
  void initState() {
    super.initState();
    scores = [];

    DatabaseReference reference = FirebaseDatabase.instance
        .reference()
        .child('recipes/${widget.recipe.key}/score');

    reference.onValue.listen((event) {
      scores.clear();
      Map<dynamic, dynamic> values = {};
      if (event.snapshot.value != null) {
        values = event.snapshot.value as Map<dynamic, dynamic>;
      }

      values.forEach((key, data) {
        scores.add(Score(
          key: key,
          id: data['id'],
          name: data['name'],
          profileUrl: data['profile_img'],
          scores: data['scores'],
        ));
      });
      scores.sort((a, b) => b.scores.compareTo(a.scores));
      setState(() {}); // อัพเดท UI เมื่อโหลดข้อมูลเสร็จสิ้น
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recipe.title),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // เพิ่มรูปภาพด้านบนสุด
              Image.network(
                widget.recipe.imageUrl,
                height: 300,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              // ต่อด้วยส่วนอื่น ๆ ของหน้า
              ListView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // ปิดการเลื่อนของ ListView
                shrinkWrap: true,
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  return _buildScoreCard(context, scores[index], index + 1);
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCard(BuildContext context, Score score, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // รูปโปรไฟล์ของผู้ใช้
              CircleAvatar(
                backgroundImage: NetworkImage(score.profileUrl),
                radius: 25,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ชื่อผู้ใช้
                  Text(
                    score.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Coiny',
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                  SizedBox(height: 5),
                  // คะแนน

                  Row(
                    children: [
                      Text(
                        score.scores.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Coiny',
                          color: Color.fromARGB(255, 255, 153, 36),
                        ),
                      ),
                      SizedBox(width: 5),
                      Image.asset(
                        'assets/img/chef_score.png',
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              // ตำแหน่งของคะแนน

              Text(
                '#$index', // ตำแหน่งของผู้ให้คะแนน
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Coiny',
                  color: Color.fromARGB(255, 255, 80, 80),
                ),
              ),

              SizedBox(width: 5),
              Image.asset(
                'assets/img/scoreplace_icon.png',
                width: 24,
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
