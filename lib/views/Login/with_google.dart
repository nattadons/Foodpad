import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();
final FirebaseAuth _auth = FirebaseAuth.instance;

Future<UserCredential?> signInWithGoogle() async {
  try {
    // 1. ลงทะเบียนด้วย Google
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    if (googleSignInAccount == null) {
      // ผู้ใช้ยกเลิกการลงทะเบียน
      return null;
    }

    // 2. รับข้อมูลการเข้าสู่ระบบจาก Google
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    // 3. ใช้ข้อมูลเข้าสู่ระบบจาก Google เพื่อลงทะเบียนหรือเข้าสู่ระบบใน Firebase
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return await _auth.signInWithCredential(credential);
  } catch (error) {
    print("Error signing in with Google: $error");
    return null;
  }
}
