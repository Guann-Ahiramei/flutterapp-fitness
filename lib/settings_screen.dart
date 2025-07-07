import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_avatar/random_avatar.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController usernameController = TextEditingController();
  DateTime? selectedBirthday;
  String? avatarSeed;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // 加载用户数据
  }

  // 加载用户数据
  Future<void> _loadUserData() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          usernameController.text = userData?['username'] ?? '';
          if (userData?['birthday'] != null) {
            selectedBirthday = DateTime.parse(userData!['birthday']);
          }
          avatarSeed = userData?['avatar_seed'];
        });
      }
    } catch (e) {
      // 显示错误提示
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load user data: $e")),
      );
    }
  }

  // 使用随机种子生成头像
  void generateRandomAvatar() {
    setState(() {
      avatarSeed = DateTime.now().millisecondsSinceEpoch.toString(); // 使用当前时间作为随机种子
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              maxLength: 10,
              decoration: InputDecoration(
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12)),
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12)),
                labelText: "Username",
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              title: Text(
                selectedBirthday == null
                    ? "Select your birthday"
                    : "Birthday: ${_formatDate(selectedBirthday!)}",
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedBirthday ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedBirthday = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: generateRandomAvatar,
              child: Text("Generate Random Avatar"),
            ),
            if (avatarSeed != null) ...[
              SizedBox(height: 20),
              Container(
                height: 100,
                width: 100,
                child: RandomAvatar(avatarSeed!), // 显示随机头像
              ),
            ],
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final uid = FirebaseAuth.instance.currentUser!.uid;

                  // 保存用户信息到 Firestore
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(uid)
                      .update({
                    'username': usernameController.text,
                    'birthday': selectedBirthday?.toIso8601String(),
                    'avatar_seed': avatarSeed, // 保存种子到 Firestore
                  });

                  // 提示保存成功
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Settings saved!")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Failed to save settings: $e")),
                  );
                }
              },
              child: Text("Save Settings"),
            ),
          ],
        ),
      ),
    );
  }

  // 格式化日期
  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
