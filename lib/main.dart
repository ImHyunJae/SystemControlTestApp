import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:system_control_test_app/current_date_time_widget.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

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
              onPressed: ,
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
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Column(
                            children: [
                              const Text('Close'),
                            ],
                          )),
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

  //https://github.com/DavBfr/dart_pdf/blob/master/demo/lib/examples/invoice.dart

  Future<Uint8List> generateInvoice(
      PdfPageFormat pageFormat, CustomData data) async {
    final lorem = pw.LoremText();

    final products = <Product>[
      Product('19874', lorem.sentence(4), 3.99, 2),
      Product('98452', lorem.sentence(6), 15, 2),
      Product('28375', lorem.sentence(4), 6.95, 3),
      Product('95673', lorem.sentence(3), 49.99, 4),
      Product('23763', lorem.sentence(2), 560.03, 1),
      Product('55209', lorem.sentence(5), 26, 1),
      Product('09853', lorem.sentence(5), 26, 1),
      Product('23463', lorem.sentence(5), 34, 1),
      Product('56783', lorem.sentence(5), 7, 4),
      Product('78256', lorem.sentence(5), 23, 1),
      Product('23745', lorem.sentence(5), 94, 1),
      Product('07834', lorem.sentence(5), 12, 1),
      Product('23547', lorem.sentence(5), 34, 1),
      Product('98387', lorem.sentence(5), 7.99, 2),
    ];

    final invoice = Invoice(
      invoiceNumber: '982347',
      products: products,
      customerName: 'Abraham Swearegin',
      customerAddress: '54 rue de Rivoli\n75001 Paris, France',
      paymentInfo:
          '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
      tax: .15,
      baseColor: PdfColors.teal,
      accentColor: PdfColors.blueGrey900,
    );

    return await invoice.buildPdf(pageFormat);
  }
}

class Product {
  const Product(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
  );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
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

class ChatScreen extends StatefulWidget {
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<String> _messages = [];
  final TextEditingController _controller = TextEditingController();

  void _sendMessage(String message) {
    setState(() {
      _messages.add(message);
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat Widget'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      _sendMessage(_controller.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomData {
  const CustomData({this.name = '[your name]'});

  final String name;
}

Future<Uint8List> generateInvoice(
    PdfPageFormat pageFormat, CustomData data) async {
  final lorem = pw.LoremText();

  final products = <Product>[
    Product('19874', lorem.sentence(4), 3.99, 2),
    Product('98452', lorem.sentence(6), 15, 2),
    Product('28375', lorem.sentence(4), 6.95, 3),
    Product('95673', lorem.sentence(3), 49.99, 4),
    Product('23763', lorem.sentence(2), 560.03, 1),
    Product('55209', lorem.sentence(5), 26, 1),
    Product('09853', lorem.sentence(5), 26, 1),
    Product('23463', lorem.sentence(5), 34, 1),
    Product('56783', lorem.sentence(5), 7, 4),
    Product('78256', lorem.sentence(5), 23, 1),
    Product('23745', lorem.sentence(5), 94, 1),
    Product('07834', lorem.sentence(5), 12, 1),
    Product('23547', lorem.sentence(5), 34, 1),
    Product('98387', lorem.sentence(5), 7.99, 2),
  ];

  final invoice = Invoice(
    invoiceNumber: '982347',
    products: products,
    customerName: 'Abraham Swearegin',
    customerAddress: '54 rue de Rivoli\n75001 Paris, France',
    paymentInfo:
        '4509 Wiseman Street\nKnoxville, Tennessee(TN), 37929\n865-372-0425',
    tax: .15,
    baseColor: PdfColors.teal,
    accentColor: PdfColors.blueGrey900,
  );

  return await invoice.buildPdf(pageFormat);
}

class Invoice {
  Invoice({
    required this.products,
    required this.customerName,
    required this.customerAddress,
    required this.invoiceNumber,
    required this.tax,
    required this.paymentInfo,
    required this.baseColor,
    required this.accentColor,
  });

  final List<Product> products;
  final String customerName;
  final String customerAddress;
  final String invoiceNumber;
  final double tax;
  final String paymentInfo;
  final PdfColor baseColor;
  final PdfColor accentColor;

  static const _darkColor = PdfColors.blueGrey800;
  static const _lightColor = PdfColors.white;

  PdfColor get _baseTextColor => baseColor.isLight ? _lightColor : _darkColor;

  PdfColor get _accentTextColor => baseColor.isLight ? _lightColor : _darkColor;

  double get _total =>
      products.map<double>((p) => p.total).reduce((a, b) => a + b);

  double get _grandTotal => _total * (1 + tax);

  String? _logo;

  String? _bgShape;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    // Create a PDF document.
    final doc = pw.Document();

    _logo = await rootBundle.loadString('assets/logo.svg');
    _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
          await PdfGoogleFonts.robotoRegular(),
          await PdfGoogleFonts.robotoBold(),
          await PdfGoogleFonts.robotoItalic(),
        ),
        header: _buildHeader,
        footer: _buildFooter,
        build: (context) => [
          _contentHeader(context),
          _contentTable(context),
          pw.SizedBox(height: 20),
          _contentFooter(context),
          pw.SizedBox(height: 20),
          _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _accentTextColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(invoiceNumber),
                          pw.Text('Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.topRight,
                    padding: const pw.EdgeInsets.only(bottom: 8, left: 30),
                    height: 72,
                    child:
                        _logo != null ? pw.SvgImage(svg: _logo!) : pw.PdfLogo(),
                  ),
                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: 'Invoice# $invoiceNumber',
            drawText: false,
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber}/${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
            color: PdfColors.white,
          ),
        ),
      ],
    );
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape!),
      ),
    );
  }

  pw.Widget _contentHeader(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 20),
            height: 70,
            child: pw.FittedBox(
              child: pw.Text(
                'Total: ${_formatCurrency(_grandTotal)}',
                style: pw.TextStyle(
                  color: baseColor,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Row(
            children: [
              pw.Container(
                margin: const pw.EdgeInsets.only(left: 10, right: 10),
                height: 70,
                child: pw.Text(
                  'Invoice to:',
                  style: pw.TextStyle(
                    color: _darkColor,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              pw.Expanded(
                child: pw.Container(
                  height: 70,
                  child: pw.RichText(
                      text: pw.TextSpan(
                          text: '$customerName\n',
                          style: pw.TextStyle(
                            color: _darkColor,
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                        const pw.TextSpan(
                          text: '\n',
                          style: pw.TextStyle(
                            fontSize: 5,
                          ),
                        ),
                        pw.TextSpan(
                          text: customerAddress,
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.normal,
                            fontSize: 10,
                          ),
                        ),
                      ])),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _contentFooter(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Thank you for your business',
                style: pw.TextStyle(
                  color: _darkColor,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Container(
                margin: const pw.EdgeInsets.only(top: 20, bottom: 8),
                child: pw.Text(
                  'Payment Info:',
                  style: pw.TextStyle(
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                paymentInfo,
                style: const pw.TextStyle(
                  fontSize: 8,
                  lineSpacing: 5,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Sub Total:'),
                    pw.Text(_formatCurrency(_total)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(tax * 100).toStringAsFixed(1)}%'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Total:'),
                      pw.Text(_formatCurrency(_grandTotal)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _termsAndConditions(pw.Context context) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border(top: pw.BorderSide(color: accentColor)),
                ),
                padding: const pw.EdgeInsets.only(top: 10, bottom: 4),
                child: pw.Text(
                  'Terms & Conditions',
                  style: pw.TextStyle(
                    fontSize: 12,
                    color: baseColor,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              pw.Text(
                pw.LoremText().paragraph(40),
                textAlign: pw.TextAlign.justify,
                style: const pw.TextStyle(
                  fontSize: 6,
                  lineSpacing: 2,
                  color: _darkColor,
                ),
              ),
            ],
          ),
        ),
        pw.Expanded(
          child: pw.SizedBox(),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = [
      'SKU#',
      'Item Description',
      'Price',
      'Quantity',
      'Total'
    ];

    return pw.TableHelper.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        products.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => products[row].getIndex(col),
        ),
      ),
    );
  }
}

String _formatCurrency(double amount) {
  return '\$${amount.toStringAsFixed(2)}';
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}

class Product {
  const Product(
    this.sku,
    this.productName,
    this.price,
    this.quantity,
  );

  final String sku;
  final String productName;
  final double price;
  final int quantity;
  double get total => price * quantity;

  String getIndex(int index) {
    switch (index) {
      case 0:
        return sku;
      case 1:
        return productName;
      case 2:
        return _formatCurrency(price);
      case 3:
        return quantity.toString();
      case 4:
        return _formatCurrency(total);
    }
    return '';
  }
}
