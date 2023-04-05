import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechText extends StatefulWidget {
  const SpeechText({Key? key}) : super(key: key);

  @override
  State<SpeechText> createState() => _SpeechTextState();
}

class _SpeechTextState extends State<SpeechText> {
  final speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech To Text'),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: Text(
            speechToText.isListening
                ? lastWords
                : speechEnabled
                    ? 'Tap the microphone to start listening...'
                    : 'Speech not available',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.large(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
