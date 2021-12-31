import 'package:extended_image/extended_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:melon_market/constants/common_size.dart';
import 'package:melon_market/states/user_provider.dart';
import 'package:melon_market/utils/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  static const String prePhoneNum = '010';

  AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

const duration = Duration(milliseconds: 300);

class _AuthPageState extends State<AuthPage> {
  final inputBorder =
      OutlineInputBorder(borderSide: BorderSide(color: Colors.grey));

  final TextEditingController _phoneEditingController =
      TextEditingController(text: AuthPage.prePhoneNum);

  final TextEditingController _codeEditingController =
      TextEditingController(text: '');

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  VerificationStatus _verificationStatus = VerificationStatus.none;

  String? _verificationId;
  int? _forceResendingToken;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Size size = MediaQuery.of(context).size;
      return IgnorePointer(
        ignoring: _verificationStatus == VerificationStatus.verifying,
        child: Form(
          key: _formkey,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '전화번호 로그인',
                style: Theme.of(context).appBarTheme.titleTextStyle,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(common_padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      ExtendedImage.asset(
                        'assets/imgs/padlock.png',
                        width: size.width * 0.15,
                        height: size.width * 0.15,
                      ),
                      SizedBox(
                        width: common_sm_padding,
                      ),
                      Text(
                          '멜론마켓은 휴대폰 번호로 가입해요.\n번호는 안전하게 보관 되며 \n어디에도 공개되지 않아요.'),
                    ],
                  ),
                  SizedBox(
                    height: common_sm_padding,
                  ),
                  TextFormField(
                    controller: _phoneEditingController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [MaskedInputFormatter("000 0000 0000")],
                    decoration: InputDecoration(
                        focusedBorder: inputBorder, border: inputBorder),
                    validator: (phoneNumber) {
                      if (phoneNumber != null && phoneNumber.length == 13) {
                        return null;
                      } else {
                        return '필수 입련란 입니다.';
                      }
                    },
                  ),
                  SizedBox(
                    height: common_sm_padding,
                  ),
                  TextButton(
                      onPressed: () async {
                        if (_verificationStatus ==
                            VerificationStatus.codesending) return;

                        if (_formkey.currentState != null) {
                          bool passed = _formkey.currentState!.validate();
                          print(passed);
                          if (passed) {
                            String phoneNum = _phoneEditingController.text;
                            phoneNum = phoneNum.replaceAll(" ", "");
                            phoneNum = phoneNum.replaceFirst("0", "");
                            logger.d('phoneNum: $phoneNum');

                            FirebaseAuth auth = FirebaseAuth.instance;

                            setState(() {
                              _verificationStatus =
                                  VerificationStatus.codesending;
                            });

                            await auth.verifyPhoneNumber(
                              phoneNumber: '+82$phoneNum',
                              forceResendingToken: _forceResendingToken,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) async {
                                logger.d('verificationComplate: $credential');
                                await auth.signInWithCredential(credential);
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                              codeSent: (String verificationId,
                                  int? forceResendingToken) async {
                                setState(() {
                                  _verificationStatus =
                                      VerificationStatus.codeSent;
                                });
                                _verificationId = verificationId;
                                _forceResendingToken = forceResendingToken;

                                // // Update the UI - wait for the user to enter the SMS code
                                // String smsCode = '555555';
                                //
                                // // Create a PhoneAuthCredential with the code
                                // PhoneAuthCredential credential =
                                //     PhoneAuthProvider.credential(
                                //         verificationId: verificationId,
                                //         smsCode: smsCode);
                                //
                                // // Sign the user in (or link) with the credential
                                // await auth.signInWithCredential(credential);
                              },
                              verificationFailed:
                                  (FirebaseAuthException error) {
                                logger.e(error.message);
                                _verificationStatus = VerificationStatus.none;
                              },
                            );

                            setState(() {
                              _verificationStatus = VerificationStatus.codeSent;
                            });
                          }
                        }
                      },
                      child: (_verificationStatus ==
                              VerificationStatus.codesending)
                          ? SizedBox(
                              width: 26,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ))
                          : Text('인증문자 발송')),
                  SizedBox(
                    height: common_padding,
                  ),
                  AnimatedOpacity(
                    duration: duration,
                    curve: Curves.easeInOut,
                    opacity: (_verificationStatus == VerificationStatus.none)
                        ? 0
                        : 1,
                    child: AnimatedContainer(
                      duration: duration,
                      height: getVerificationHeight(_verificationStatus),
                      child: TextFormField(
                        controller: _codeEditingController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [MaskedInputFormatter("000000")],
                        decoration: InputDecoration(
                            focusedBorder: inputBorder, border: inputBorder),
                      ),
                    ),
                  ),
                  AnimatedContainer(
                      duration: duration,
                      height: getVerificationBtnHeight(_verificationStatus),
                      child: TextButton(
                          onPressed: () {
                            attempVerify(context);
                          },
                          child: (_verificationStatus ==
                                  VerificationStatus.verifying)
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text('인증'))),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  double getVerificationHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codesending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 60 + common_sm_padding;
    }
  }

  double getVerificationBtnHeight(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.none:
        return 0;
      case VerificationStatus.codesending:
      case VerificationStatus.codeSent:
      case VerificationStatus.verifying:
      case VerificationStatus.verificationDone:
        return 40 + common_sm_padding;
    }
  }

  void attempVerify(BuildContext context) async {
    setState(() {
      _verificationStatus = VerificationStatus.verifying;
    });

    try {
      // Create a PhoneAuthCredential with the code
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _codeEditingController.text);

      // Sign the user in (or link) with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      //await Future.delayed(Duration(seconds: 3));
      logger.e('verification failed!!');
      SnackBar snackbar = SnackBar(content: Text('입력하신 코드가 틀립니다'));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    //await Future.delayed(Duration(seconds: 3));
    setState(() {
      _verificationStatus = VerificationStatus.verificationDone;
    });

    // context.read<UserProvider>().setUserAuth(true);
  }

  _getAddress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String address = prefs.getString('address') ?? "";
    logger.d('Address from Shared pref: $address');
  }
}

enum VerificationStatus {
  none,
  codesending,
  codeSent,
  verifying,
  verificationDone
}
