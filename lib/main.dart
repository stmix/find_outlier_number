import 'package:flutter/material.dart';
import 'package:find_outlier_number/result.dart';
import 'package:find_outlier_number/messages/messages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outlier',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Find Outlier Number'),
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
  final TextEditingController _textEditingController = TextEditingController();

  String findOutlierNumber(String list) {
    int evenCounter = 0;
    int oddCounter = 0;
    String evenOutlierNumber = '';
    String oddOutlierNumber = '';
    String res = '';
    List<String> splitList = list.split(',');
    if (splitList.length < 3) {
      res = listTooShort;
      return res;
    }
    for (int i = 0; i < splitList.length; i++) {
      if (int.tryParse(splitList[i]) != null) {
        if (int.parse(splitList[i]) % 2 == 0) {
          evenCounter++;
          evenOutlierNumber = splitList[i];
        } else if (int.parse(splitList[i]) % 2 == 1) {
          oddCounter++;
          oddOutlierNumber = splitList[i];
        }
      } else {
        res = parseError;
        return res;
      }
    }

    if (evenCounter != 1 && oddCounter == 1) {
      res = oddOutlierNumber;
    } else if (evenCounter == 1 && oddCounter != 1) {
      res = evenOutlierNumber;
    } else if (evenCounter == 0) {
      res = allOdd;
    } else if (oddCounter == 0) {
      res = allEven;
    } else if (evenCounter > 1 && oddCounter > 1) {
      res = outlierNotFound;
    } else {
      res = unrecognizedError;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: inputHintText,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    Expanded(
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                          result: findOutlierNumber(
                                              _textEditingController.text))));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                'Wyszukaj',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
