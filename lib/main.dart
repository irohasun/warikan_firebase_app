import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:warikan_firebase_app/make_group/make_group_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MakeGroupPage(),
    );
  }
}

// class MainPage extends StatelessWidget {
//   Widget _buildButton(
//       {required String label,
//       required Color color,
//       required VoidCallback onPressed}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: ElevatedButton(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             label,
//             style: TextStyle(fontSize: 30.0, color: Colors.white),
//           ),
//         ),
//         onPressed: onPressed,
//       ),
//     );
//   }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       backgroundColor: Colors.blueAccent,
//       title: Center(
//         child: Text('Tabikan'),
//       ),
//     ),
//     body: MakeGroupPage(),
// body: Center(
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       _buildButton(
//         label: '新規登録',
//         color: Colors.blueAccent,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SignUpPage()),
//           );
//         },
//       ),
//       _buildButton(
//         label: 'ログイン',
//         color: Colors.blueAccent,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => LoginPage()),
//           );
//         },
//       ),
//     ],
//   ),
// ),
