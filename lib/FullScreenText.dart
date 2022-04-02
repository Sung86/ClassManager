import 'package:flutter/cupertino.dart';

class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection:TextDirection.ltr,
        child: Column(
            children:
            [
              Expanded(
                  child: Center(
                      child: Text(text)
                  )
              )
            ]
        )
    );
  }
}