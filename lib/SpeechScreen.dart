import 'package:flutter/cupertino.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:talkie/SummaryScreen.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen>
    with SingleTickerProviderStateMixin {
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = '';

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF040307), Color(0xFF010556)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                  child: Text(
                    _text,
                    style: const TextStyle(fontSize: 32.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    onPressed: _listen,
                    child: Icon(_isListening ? Icons.mic : Icons.mic_off,
                        size: 40),
                    heroTag: "micButton",
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: () {
                      print("pressed Copy button");
                      Clipboard.setData(ClipboardData(text: _text));
                    },
                    child: Icon(Icons.content_copy, size: 40),
                    heroTag: "copyButton",
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    //TODO: only push navigator when _text is NOT empty
                    onPressed: () {
                      print("pressed Summarize button");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SummaryScreen(_text)));
                    },
                    child: Icon(
                      Icons.summarize_rounded,
                      size: 40,
                    ),
                    heroTag: "summarizeButton",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      print("wasn't listening");
      bool available = await _speech.initialize(
        onStatus: (val) => setState(() => _isListening = val == 'listening'),
      );
      print("now I'm listening");
      if (available) {
        _speech.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
            print("yapping is being printed");
          }),
        );
      }
    } else {
      print("listening stopped duh");
      print(_text);
      _speech.stop();
      setState(() => _isListening = false);
    }
  }

  void _summarize() {
    // Call your Gemini API here to summarize the text
    // Update the state with the summarized text
  }
}
