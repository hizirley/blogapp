import 'dart:convert';
import 'package:blogapp/pages/other_user_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserSearchPage extends StatefulWidget {
  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> {
  final TextEditingController searchController = TextEditingController();
  late Future<List<dynamic>> _searchResults;

  @override
  void initState() {
    super.initState();
    _searchResults = Future.value([]);
  }

  Future<List<dynamic>> searchUsers(String query) async {
    final url = Uri.parse("http://10.116.35.80/searchUsers.php");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['users'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      print("Bağlantı hatası: $e");
      return [];
    }
  }

  void performSearch(String query) {
    if (query.isNotEmpty) {
      setState(() {
        _searchResults = searchUsers(query);
      });
    } else {
      setState(() {
        _searchResults = Future.value([]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kullanıcı Ara"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "İsim veya e-posta ile kullanıcı arayın",
                prefixIcon: Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onSubmitted: performSearch,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _searchResults,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Bir hata oluştu.",
                      style: TextStyle(fontSize: 16, color: Colors.redAccent),
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Sonuç bulunamadı.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }

                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtherUserProfile(user: user),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        padding: const EdgeInsets.all(12),
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
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: user['profile_picture'] != null
                                  ? NetworkImage(
                                      "http://10.116.35.80/${user['profile_picture']}")
                                  : AssetImage("lib/assets/default_avatar.png")
                                      as ImageProvider,
                              backgroundColor: Colors.grey.shade200,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['name'] ?? "Ad Yok",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user['email'] ?? "E-posta Yok",
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
          ),
        ],
      ),
    );
  }
}
