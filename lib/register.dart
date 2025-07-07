import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gemini_in_flutter/login.dart';
import 'settings_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  WidgetsFlutterBinding.ensureInitialized();
                  await Firebase.initializeApp();
                  // 注册用户
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  // 创建用户文档
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(credential.user!.uid)
                      .set({
                    'email': emailController.text,
                    'username': '',
                    'birthday': null,
                    'avatar': '',
                  });

                  // 跳转到个人设置页面
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                } catch (e) {
                  print(e);
                  // 显示错误信息
                }
              },
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
