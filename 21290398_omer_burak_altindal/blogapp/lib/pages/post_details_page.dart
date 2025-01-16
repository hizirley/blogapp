import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PostDetails extends StatefulWidget {
  final int postId;

  PostDetails({required this.postId});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  final TextEditingController commentController = TextEditingController();
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    checkIfLiked();
  }

  Future<void> checkIfLiked() async {
    String? userEmail = await getUserEmail();

    if (userEmail == null) {
      print("Kullanıcı e-postası alınamadı!");
      return;
    }

    final url = Uri.parse("http://10.116.35.80/checkLike.php?post_id=${widget.postId}&user_email=$userEmail");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          isLiked = data['isLiked'] ?? false;
        });
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<Map<String, dynamic>> fetchPostDetails() async {
    final url = Uri.parse("http://10.116.35.80/getPostDetails.php?id=${widget.postId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print("Hata: $e");
      return {};
    }
  }

  Future<List<dynamic>> fetchComments() async {
    final url = Uri.parse("http://10.116.35.80/getComments.php?post_id=${widget.postId}");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['comments'];
      } else {
        return [];
      }
    } catch (e) {
      print("Hata: $e");
      return [];
    }
  }

  Future<String?> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail');
  }

  Future<void> toggleLike() async {
    String? userEmail = await getUserEmail();

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı e-postası bulunamadı!")),
      );
      return;
    }

    final url = Uri.parse("http://10.116.35.80/toggleLike.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "post_id": widget.postId,
          "user_email": userEmail,
        }),
      );

      final data = json.decode(response.body);

      if (data['success']) {
        setState(() {
          isLiked = !isLiked;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Bir hata oluştu!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  Future<void> addComment(String content) async {
    String? userEmail = await getUserEmail();

    if (userEmail == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kullanıcı e-postası bulunamadı!")),
      );
      return;
    }

    final url = Uri.parse("http://10.116.35.80/addComment.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "post_id": widget.postId,
          "user_email": userEmail,
          "content": content,
        }),
      );

      final data = json.decode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Yorum başarıyla eklendi!")),
        );
        setState(() {});
        commentController.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? "Yorum eklenirken hata oluştu!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Hata: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detayları'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchPostDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Center(child: Text("Post bilgileri alınamadı."));
          }

          final post = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['title'] ?? "Başlık Yok",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                ),
                SizedBox(height: 20),
                post['picture'] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          "http://10.116.35.80/uploads/${post['picture']}",
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(child: Text("Resim Yok", style: TextStyle(color: Colors.black54))),
                      ),
                SizedBox(height: 10),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: toggleLike,
                    ),
                    Text(
                      isLiked ? "Beğenildi" : "Beğen",
                      style: TextStyle(color: isLiked ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  post['content'] ?? "İçerik Yok",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 40),
                Text("Yorumlar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
                FutureBuilder<List<dynamic>>(
                  future: fetchComments(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text("Henüz yorum yok."));
                    }

                    final comments = snapshot.data!;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(comment['user_email'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                            subtitle: Text(comment['content'], style: TextStyle(color: Colors.black54)),
                            trailing: Text(
                              comment['created_at'],
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: "Yorumunuzu yazın...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    addComment(commentController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: Text("Gönder"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
