import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage(
      {super.key, required this.result, required this.resultHeader});
  final String result;
  final String resultHeader;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                  widget.resultHeader),
            ),
            Center(
              child: Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: int.tryParse(widget.result) != null ? 105 : 25,
                  ),
                  widget.result),
            ),
          ],
        ),
      ),
    );
  }
}
