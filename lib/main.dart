import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:system_control_test_app/current_date_time_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData();
    return MaterialApp(
      title: 'Dashboard App',
      theme: ThemeData.dark().copyWith(
        colorScheme: theme.colorScheme.copyWith(secondary: Colors.blueAccent),
        scaffoldBackgroundColor:
            Color.fromARGB(255, 3, 0, 43), // Set the background color
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white), // Set text color
        ),
      ),
      home: DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  double circularProgress = 0.0;
  double linearProgress = 0.0;
  bool showCircularProgressBar = true;
  bool showLinearProgressBar = false;
  bool circularButtonEnabled = true;
  bool linearButtonEnabled = true;
  Timer? circularProgressTimer;
  Timer? linearProgressTimer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CurrentDateTimeWidget(),
            CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 10.0,
              percent: circularProgress.clamp(0.0, 1.0),
              center: Text(
                '${(circularProgress * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20.0),
              ),
              progressColor: Colors.green,
            ),
            SizedBox(height: 30.0),
            TestResultLabel(
              label: 'Test 1',
              result: showCircularProgressBar ? 'In Progress' : 'Pass',
            ),
            LinearProgressIndicator(
              value: linearProgress.clamp(0.0, 1.0),
              color: Colors.blue,
            ),
            SizedBox(height: 10.0),
            TestResultLabel(
              label: 'Test 2',
              result: showLinearProgressBar ? 'In Progress' : 'Fail',
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: circularButtonEnabled ? startCircularProgress : null,
              child: Text('Start Circular Progress'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: linearButtonEnabled ? startLinearProgress : null,
              child: Text('Start Linear Progress (Test 2)'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: generatePDF,
              child: Text('Generate PDF'),
            ),
            TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LoginDialog(),
                      ],
                      // children: <Widget>[
                      //   const Text('This is a typical dialog.'),
                      //   const SizedBox(height: 15),
                      //   TextButton(
                      //     onPressed: () {
                      //       Navigator.pop(context);
                      //     },
                      //     child: const Text('Close'),
                      //   ),
                      // ],
                    ),
                  ),
                ),
              ),
              child: const Text('운용자 인증'),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => Dialog.fullscreen(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('This is a fullscreen dialog.'),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                ),
              ),
              child: const Text('Show Fullscreen Dialog'),
            ),
          ],
        ),
      ),
    );
  }

  void startCircularProgress() {
    const duration = Duration(milliseconds: 100);
    circularProgress = 0.0;
    circularButtonEnabled = false;

    circularProgressTimer?.cancel();
    circularProgressTimer = Timer.periodic(duration, (timer) {
      setState(() {
        circularProgress += 0.01;
        circularProgress = circularProgress.clamp(0.0, 1.0);
        if (circularProgress >= 1.0) {
          timer.cancel();
          showCircularProgressBar = false;
          circularButtonEnabled = true;
        }
      });
    });
  }

  void startLinearProgress() {
    const duration = Duration(milliseconds: 100);
    linearProgress = 0.0;
    linearButtonEnabled = false;

    linearProgressTimer?.cancel();
    linearProgressTimer = Timer.periodic(duration, (timer) {
      setState(() {
        linearProgress += 0.01;
        linearProgress = linearProgress.clamp(0.0, 1.0);
        if (linearProgress >= 1.0) {
          timer.cancel();
          showLinearProgressBar = false;
          linearButtonEnabled = true;
        }
      });
    });
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    // Add content to the PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text(
                'Test 1 Result: ${showCircularProgressBar ? 'In Progress' : 'Pass'}'),
            pw.Text(
                'Test 2 Result: ${showLinearProgressBar ? 'In Progress' : 'Fail'}'),
          ],
        ),
      ),
    );

    // Get the directory for saving the PDF using file_picker
    String? save_path = await FilePicker.platform.getDirectoryPath();

    if (save_path != null) {
      final filePath = join(save_path, 'test_report.pdf');
      final outputFile = File(filePath);
      await outputFile.writeAsBytes(await pdf.save());

      // Print the path to the console (you can remove this line if not needed)
      print('PDF saved to: $filePath');
    }
    // Save the PDF to the directory
  }
}

class TestResultLabel extends StatelessWidget {
  final String label;
  final String result;

  TestResultLabel({required this.label, required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 18.0),
          ),
          Text(
            result,
            style: TextStyle(
              fontSize: 18.0,
              color: result == 'Pass' ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

class CurrentTimeDisplay extends StatefulWidget {
  @override
  _CurrentTimeDisplayState createState() => _CurrentTimeDisplayState();
}

class _CurrentTimeDisplayState extends State<CurrentTimeDisplay> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) => _updateTime());
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _dateTime.toString(),
        style: TextStyle(fontSize: 30),
      ),
    );
  }
}

class LoginDialog extends StatefulWidget {
  @override
  _LoginDialogState createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialog> {
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _idController.text = '';
    _passwordController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('로그인'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _idController,
            decoration: InputDecoration(labelText: '아이디'),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: '패스워드'),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: Text('로그인'),
          onPressed: () {
            if (_idController.text == 'admin' &&
                _passwordController.text == 'admin') {
              Navigator.of(context).pop();
            } else {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('로그인 실패'),
                    content: Text('아이디 또는 패스워드가 올바르지 않습니다.'),
                    actions: [
                      ElevatedButton(
                        child: Text('확인'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ],
    );
  }
}
