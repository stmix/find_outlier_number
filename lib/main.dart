import 'package:easy_localization/easy_localization.dart';
import 'package:find_outlier_number/l10n/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:find_outlier_number/result.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('pl'),
    const Locale('es'),
  ];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
    supportedLocales: L10n.all,
    path: 'assets/l10n/',
    fallbackLocale: const Locale('en'),
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: LocaleKeys.materialAppTitle.tr(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'FindOutlierNumberApp'),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       localizationsDelegates: context.localizationDelegates,
//       supportedLocales: context.supportedLocales,
//       locale: context.locale,
//       title: LocaleKeys.materialAppTitle.tr(),
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: LocaleKeys.homePageTitle.tr()),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({super.key, required this.title});

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
      res = LocaleKeys.listTooShort.tr();
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
        res = LocaleKeys.parseError.tr();
        return res;
      }
    }

    if (evenCounter != 1 && oddCounter == 1) {
      res = oddOutlierNumber;
    } else if (evenCounter == 1 && oddCounter != 1) {
      res = evenOutlierNumber;
    } else if (evenCounter == 0) {
      res = LocaleKeys.allOdd.tr();
    } else if (oddCounter == 0) {
      res = LocaleKeys.allEven.tr();
    } else if (evenCounter > 1 && oddCounter > 1) {
      res = LocaleKeys.outlierNotFound.tr();
    } else {
      res = LocaleKeys.unrecognizedError.tr();
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.chooseLanguage.tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                  const DropdownButtonExample(),
                ],
              ),
              const SizedBox(
                height: 200,
              ),
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: LocaleKeys.inputHintText.tr(),
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
                                                _textEditingController.text),
                                            resultHeader:
                                                LocaleKeys.resultHeader.tr(),
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: Text(
                                LocaleKeys.buttonText.tr(),
                                style: const TextStyle(
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

const List<String> languagesList = <String>['Polski', 'English', 'Español'];
const List<String> codesList = <String>['pl', 'en', 'es'];

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = languagesList.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: languagesList[
          codesList.indexOf(Localizations.localeOf(context).toString())],
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.black, fontSize: 18),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? value) {
        // ignore: deprecated_member_use
        context.locale = Locale(codesList[languagesList.indexOf(value!)]);
        setState(() {
          dropdownValue = value;
        });
      },
      items: languagesList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
