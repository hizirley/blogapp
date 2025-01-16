import 'dart:convert';
import 'dart:io';
import 'package:blogapp/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfileEditPage extends StatefulWidget {
  final Map<String, String> userDetails;

  ProfileEditPage({required this.userDetails});

  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  File? _selectedImage; // Seçilen dosyayı tutar
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.userDetails['name']);
    _surnameController =
        TextEditingController(text: widget.userDetails['surname']);
    _emailController = TextEditingController(text: widget.userDetails['email']);
    _phoneController = TextEditingController(text: widget.userDetails['phone']);
  }

  Future<void> selectProfilePicture() async {
    try {
      final file = await openFile(
        acceptedTypeGroups: [
          XTypeGroup(label: 'images', extensions: ['jpg', 'png', 'jpeg'])
        ],
      );
      if (file != null) {
        setState(() {
          _selectedImage = File(file.path);
        });
      }
    } catch (e) {
      print("Hata: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bir hata oluştu: $e")),
      );
    }
  }

  Future<void> uploadProfilePicture(String email) async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lütfen bir fotoğraf seçin.")),
      );
      return;
    }

    final url = Uri.parse("http://10.116.35.80/upload_profile_picture.php");
    final request = http.MultipartRequest("POST", url);

    request.files.add(await http.MultipartFile.fromPath(
      'profile_picture',
      _selectedImage!.path,
    ));

    request.fields['email'] = email;

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);

        if (data['success']) {
          setState(() {
            widget.userDetails['profile_picture'] = data['path'];
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Fotoğraf başarıyla yüklendi.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Bir hata oluştu.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sunucu hatası: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bağlantı hatası: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateUserDetails() async {
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();
    final newEmail = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final currentEmail = widget.userDetails['email']!;

    if (name.isEmpty || surname.isEmpty || newEmail.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Tüm alanları doldurun.")),
      );
      return;
    }

    final url = Uri.parse("http://10.116.35.80/update_user.php");

    try {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "surname": surname,
          "phone": phone,
          "email": currentEmail,
          "newEmail": newEmail,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success']) {
          if (newEmail != currentEmail) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("E-posta değiştirildi. Tekrar giriş yapın.")),
            );

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Profil başarıyla güncellendi.")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Bir hata oluştu.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Sunucu hatası: ${response.statusCode}")),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bağlantı hatası: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Profil Düzenle',
            style: TextStyle(fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: selectProfilePicture,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (widget.userDetails['profile_picture'] != null &&
                              widget.userDetails['profile_picture']!.isNotEmpty
                          ? NetworkImage("http://10.116.35.80/" +
                              widget.userDetails['profile_picture']!)
                          : AssetImage("lib/assets/default_avatar.png")
                              as ImageProvider),
                  child: _selectedImage == null &&
                          (widget.userDetails['profile_picture'] == null ||
                              widget.userDetails['profile_picture']!.isEmpty)
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.white)
                      : null,
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      uploadProfilePicture(widget.userDetails['email']!);
                    },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue, Colors.lightBlueAccent],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Fotoğrafı Yükle",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Ad",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                labelText: "Soyad",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-posta",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: "Telefon",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : updateUserDetails,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green, Colors.lightGreen],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Bilgileri Güncelle",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
