import 'package:flutter/material.dart';
import '../../constants.dart';

class KakaoLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double buttonHeight;

  const KakaoLoginButton({super.key,
    required this.onPressed,
    this.buttonHeight = HeightButton,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFFE812),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        minimumSize: Size(double.infinity, buttonHeight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            'lib/assets/kakaotalk_logo.png',
            width: MediaQuery.of(context).size.width * 0.06,
            height: MediaQuery.of(context).size.height * 0.06,
          ),
          Spacer(),
          const Text(
            '카카오계정으로 로그인',
            style: TextStyle(
              fontSize: fontSizeButton,
              color: Color(0xFF381E1F),
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Spacer(),
        ],
      ),
    );
  }
}