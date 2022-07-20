import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText speechToText;
  bool isListening = false;
  String text = 'Press the button and speak';
  double confidence = 1.0;

  @override
  void initState() {
    super.initState();
    speechToText = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Speech to Text')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: isListening,
        glowColor: Colors.redAccent,
        endRadius: 60.0,
        duration: Duration(milliseconds: 2000),
        repeatPauseDuration: Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: listen,
          child: Icon(isListening ? Icons.mic : Icons.mic_none),
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
          child: Column(
            children: [
              Text(
                'Confidence: ${(confidence * 100.0).toStringAsFixed(1)}%',
                style: TextStyle(color: Colors.black54),
              ),
              SelectableText(
                text,
                style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
                toolbarOptions: ToolbarOptions(copy: true, selectAll: true),
                maxLines: 10,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * (2 / 3),
        elevation: 1.0,
        child: ListView(
          padding: EdgeInsets.only(top: 30.0, left: 10, right: 10),
          children: [
            InkWell(
              onTap: () {},
              child: ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Mode'),
              ),
            )
          ],
        ),
      ),
    );
  }

  void listen() async {
    if (!isListening) {
      bool available = await speechToText.initialize(
          onStatus: (val) => print('onStatus: $val'),
          onError: (val) => print('onError:$val'));
      if (available) {
        setState(() => isListening = true);
        speechToText.listen(
            onResult: (val) => setState(() {
                  text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence >= 0) {
                    confidence = val.confidence;
                  }
                }));
      }
    } else {
      setState(() => isListening = false);
      speechToText.stop();
    }
  }
}
