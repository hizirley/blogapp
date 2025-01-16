import 'dart:convert';
import 'package:blogapp/pages/post_details_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtherUserProfile extends StatefulWidget {
  final Map<String, dynamic> user;

  OtherUserProfile({required this.user});

  @override
  _OtherUserProfileState createState() => _OtherUserProfileState();
}

class _OtherUserProfileState extends State<OtherUserProfile> {
  late Future<List<dynamic>> userPosts;

  @override
  void initState() {
    super.initState();
    userPosts = fetchUserPosts(widget.user['email']);
  }

  Future<List<dynamic>> fetchUserPosts(String email) async {
    final url = Uri.parse("http://10.116.35.80/get_user_posts.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['posts'] ?? [];
      } else {
        print("Sunucu hatası: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.user['name'] ?? "Kullanıcı Detayları",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: widget.user['profile_picture'] != null
                    ? NetworkImage(
                        "http://10.116.35.80/${widget.user['profile_picture']}")
                    : AssetImage("lib/assets/default_avatar.png")
                        as ImageProvider,
                child: widget.user['profile_picture'] == null
                    ? Icon(Icons.person, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                widget.user['name'] ?? "Ad Yok",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                widget.user['email'] ?? "E-posta Yok",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Gönderiler",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            FutureBuilder<List<dynamic>>(
              future: userPosts,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print("Snapshot hatası: ${snapshot.error}");
                  return Center(child: Text("Bir hata oluştu."));
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Bu kullanıcıya ait gönderi bulunamadı."),
                  );
                }

                final posts = snapshot.data!;

                return ListView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return GestureDetector(
                      onTap: () {
                        final postId = post['id'] is int
                            ? post['id']
                            : int.tryParse(post['id']);
                        if (postId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PostDetails(postId: postId),
                            ),
                          );
                        } else {
                          print("Geçersiz ID: ${post['id']}");
                        }
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            post['picture'] != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      "http://10.116.35.80/uploads/${post['picture']}",
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    height: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(12),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text("Resim Yok"),
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post['title'] ?? "Başlık Yok",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    post['created_at'] ?? "Tarih Yok",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
