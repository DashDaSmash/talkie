import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SummaryScreen extends StatefulWidget {
  final GenerativeModel model = GenerativeModel(
      model: 'gemini-pro', apiKey: 'AIzaSyDBp-cckiFfk-7LPQmWeLrtnyJFm1janYg');

  final String originalText;
  SummaryScreen(this.originalText);

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  String summaryText = '';
  String keyPointText = '';
  String assignmentsText = '';

  Future<String> _summarize() async {
    // Change the return type to void
    final summaryPrompt = 'Summarize this: ${widget.originalText}';
    final content = [Content.text(summaryPrompt)];
    final summaryResponse = await widget.model.generateContent(content);
    summaryText = summaryResponse.text ?? ''; // Update the class property
    print(summaryText);
    return summaryText;
  }

  Future<String> _keyPoints() async {
    final keyPointPrompt = 'Show me keypoints in this: ${widget.originalText}';
    final content = [Content.text(keyPointPrompt)];
    final keyPointResponse = await widget.model.generateContent(content);
    keyPointText = keyPointResponse.text ?? '';
    print(keyPointText);
    return keyPointText;
  }

  Future<String> _assignments() async {
    final assignmentsPrompt =
        'Show me keypoints in this: ${widget.originalText}';
    final content = [Content.text(assignmentsPrompt)];
    final assignmentsResponse = await widget.model.generateContent(content);
    assignmentsText = assignmentsResponse.text ?? '';
    print(assignmentsText);
    return assignmentsText;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Color(0xFF040307), Color(0xFF310076)],
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //     This is the first container
                Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(
                            0.05), // Whitish transparent background
                        borderRadius: BorderRadius.all(
                            Radius.circular(20)), // Rounded corners
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Original text',
                                  style: TextStyle(color: Colors.white),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(ClipboardData(
                                        text: widget.originalText));
                                  },
                                  icon: Icon(
                                    Icons.copy_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 10,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                '${widget.originalText}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.05), // Whitish transparent background
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)), // Rounded corners
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Summary',
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: summaryText));
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: FutureBuilder<String>(
                              future: _summarize(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else {
                                    print("got the summary text back");
                                    return Container(
                                      padding: EdgeInsets.all(50),
                                      child: SelectableText(
                                        snapshot.data ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.05), // Whitish transparent background
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)), // Rounded corners
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Key points',
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: keyPointText));
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: FutureBuilder<String>(
                              future: _keyPoints(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else {
                                    print("got the text back");
                                    return Container(
                                      padding: EdgeInsets.all(50),
                                      child: SelectableText(
                                        snapshot.data ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.05), // Whitish transparent background
                      borderRadius: BorderRadius.all(
                          Radius.circular(20)), // Rounded corners
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Assignments/ todo:',
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () {
                                  Clipboard.setData(
                                      ClipboardData(text: assignmentsText));
                                },
                                icon: Icon(
                                  Icons.copy_rounded,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 10,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: FutureBuilder<String>(
                              future: _assignments(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<String> snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else {
                                  if (snapshot.hasError)
                                    return Text('Error: ${snapshot.error}');
                                  else {
                                    print("got the assignment text back");
                                    return Container(
                                      padding: EdgeInsets.all(50),
                                      child: SelectableText(
                                        snapshot.data ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
