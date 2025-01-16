import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_edit_page.dart';
import 'home_page.dart';
import 'post_details_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  Map<String, String> userDetails = {};
  bool _isLoading = true;
  late TabController _tabController;
  List<dynamic> userPosts = [];
  List<dynamic> likedPosts = [];

  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('userEmail');

    if (email == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final url = Uri.parse("http://10.116.35.80/get_user.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data.containsKey("error")) {
          print(data["error"]);
        } else {
          setState(() {
            userDetails = {
              "name": data['name'] ?? "Ad Yok",
              "surname": data['surname'] ?? "Soyad Yok",
              "email": data['email'] ?? "E-posta Yok",
              "phone": data['phone'] ?? "Telefon Yok",
              "profile_picture":
                  data['profile_picture'] ?? "",
            };
          });
        }
      } else {
        print("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }

    setState(() {
      _isLoading = false;
    });

    fetchUserPosts(email!);
    fetchLikedPosts(email);
  }

  Future<void> fetchUserPosts(String email) async {
    final url = Uri.parse("http://10.116.35.80/get_user_posts.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userPosts = data['posts'] ?? [];
        });
      } else {
        print("Kendi postlar yüklenemedi.");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  Future<void> fetchLikedPosts(String email) async {
    final url = Uri.parse("http://10.116.35.80/get_liked_posts.php");
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          likedPosts = data['posts'] ?? [];
        });
      } else {
        print("Beğenilen postlar yüklenemedi.");
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchUserDetails();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil', style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProfileEditPage(userDetails: userDetails),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: (userDetails['profile_picture'] != null &&
                                    userDetails['profile_picture']!.isNotEmpty)
                                ? NetworkImage(
                                    "http://10.116.35.80/" +
                                        userDetails['profile_picture']!)
                                : AssetImage("lib/assets/default_avatar.png")
                                    as ImageProvider,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Ad: ${userDetails['name'] ?? "Ad Yok"}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("Soyad: ${userDetails['surname'] ?? "Soyad Yok"}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("E-posta: ${userDetails['email'] ?? "E-posta Yok"}", style: TextStyle(fontSize: 16)),
                        SizedBox(height: 10),
                        Text("Telefon: ${userDetails['phone'] ?? "Telefon Yok"}", style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.blueAccent,
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: Colors.blueAccent,
                    tabs: [
                      Tab(icon: Icon(Icons.grid_on), text: "Gönderiler"),
                      Tab(icon: Icon(Icons.favorite), text: "Beğeniler"),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 400,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Kendi Postlarım
                        userPosts.isEmpty
                            ? Center(child: Text("Henüz gönderiniz yok.", style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                itemCount: userPosts.length,
                                itemBuilder: (context, index) {
                                  final post = userPosts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetails(postId: post['id']),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(12),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text("Resim Yok", style: TextStyle(color: Colors.black54)),
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post['title'] ?? "Başlık Yok",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  post['created_at'] ??
                                                      "Tarih Yok",
                                                  style: TextStyle(
                                                    fontSize: 12,
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
                              ),
                        // Beğendiğim Postlar
                        likedPosts.isEmpty
                            ? Center(child: Text("Henüz beğendiğiniz bir post yok.", style: TextStyle(color: Colors.grey)))
                            : ListView.builder(
                                itemCount: likedPosts.length,
                                itemBuilder: (context, index) {
                                  final post = likedPosts[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PostDetails(postId: post['id']),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 16),
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                    color: Colors.grey.shade300,
                                                    borderRadius: BorderRadius.vertical(
                                                      top: Radius.circular(12),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text("Resim Yok", style: TextStyle(color: Colors.black54)),
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  post['title'] ?? "Başlık Yok",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  post['created_at'] ??
                                                      "Tarih Yok",
                                                  style: TextStyle(
                                                    fontSize: 12,
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
                              ),
                      ],
                    ),
                  ),
                
              ],
            ),
            ),
    );
  }
}
