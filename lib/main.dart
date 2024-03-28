import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tugas_akhir/login/loginstate.dart';
import 'package:tugas_akhir/regis/regis.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        } else {
          print(snapshot.data);
          if (snapshot.data != null) {
            return GetMaterialApp(
              home: HomeScreen(),
            );
          } else {
            return GetMaterialApp(
              home: MyApp(),
            );
          }
        }
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  RxBool isLoading = false.obs;
  final emailC = TextEditingController();
  final passC = TextEditingController();

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: emailC.text, password: passC.text);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ));
        print(userCredential);

        // if (userCredential.user != null) {
        //   isLoading.value = false;
        //   if (userCredential.user!.emailVerified == true) {
        //     Navigator.of(context).pushReplacement(MaterialPageRoute(
        //       builder: (context) => HomeScreen(),
        //     ));
        //   } else {
        //     // Get.defaultDialog(
        //     //     title: "Belum Verifikasi",
        //     //     middleText: "Lakukan Verifikasi Email",
        //     //     actions: [
        //     //       TextButton(
        //     //           onPressed: () {
        //     //             isLoading.value = false;
        //     //             Get.back();
        //     //           },
        //     //           child: Text('Cancel')),
        //     //       TextButton(
        //     //           onPressed: () async {
        //     //             try {
        //     //               await userCredential.user!.sendEmailVerification();
        //     //               Get.snackbar("Sukses verifikasi", "Silahkan Login");
        //     //               Get.back();
        //     //               isLoading.value = false;
        //     //             } catch (e) {
        //     //               isLoading.value = false;
        //     //               Get.snackbar("Terjadi kesalahan",
        //     //                   "Coba cek kembali email anda");
        //     //             }
        //     //           },
        //     //           child: Text('Kirim Ulang'))
        //     //     ]);
        //   }
        // }
        // isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (emailC.text != UserCredential) {
          Get.snackbar("Terjadi Kesalahan", "User tidak terdaftar");
        } else if (passC.text != UserCredential) {
          Get.snackbar("Terjadi Keslahan", "Password anda salah");
        }
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Email dan Password wajib di isi");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 6, 190, 15),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                          image: AssetImage('assets/melon.png')),
                    ),
                    height: 190,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Login',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: emailC,
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Color.fromARGB(255, 4, 194, 36)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fillColor: Colors.black,
                          label: Text('Email')),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextField(
                      controller: passC,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 3, color: Color.fromARGB(255, 4, 170, 40)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fillColor: Colors.black,
                        label: Text('Password'),
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          onPressed: () {}, child: Text('Lupa Password?'))),
                  SizedBox(
                    height: 5,
                  ),
                  TextButton(
                      onPressed: () async {
                        if (isLoading.isFalse) {
                          await login();
                        }
                      },
                      child: Text('Login')),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(regis_screen());
                      },
                      child: Text("Registrasi"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
