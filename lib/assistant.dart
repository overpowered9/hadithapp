import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:mad_project/openai_service.dart';
import 'package:mad_project/pallets.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'feature_box.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:animate_do/animate_do.dart';

class ChatAssistant extends StatefulWidget {
  const ChatAssistant({super.key});

  @override
  State<ChatAssistant> createState() => _ChatAssistantState();
}

class _ChatAssistantState extends State<ChatAssistant> {
  final speechToText = SpeechToText();
  final flutterTts = FlutterTts();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  String? generatedContent;
  String? generatedImageUrl;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    // initTextToSpeech();
  }


  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> stopSpeaking() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: BounceInDown(child: const Text('Assistant')),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              // virtual assistant picture
              ZoomIn(
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: const BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Container(
                      height: 123,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            'assets/vr.png',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // chat bubble
              FadeInRight(
                child: Visibility(
                  visible: generatedImageUrl == null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                      top: 30,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Pallete.borderColor,
                      ),
                      borderRadius: BorderRadius.circular(20).copyWith(
                        topLeft: Radius.zero,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        generatedContent == null
                            ? 'Good Morning, what can I do for you?'
                            : generatedContent!,
                        style: TextStyle(
                          fontFamily: 'Cera Pro',
                          color: Pallete.whiteColor,
                          fontSize: generatedContent == null ? 25 : 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SlideInLeft(
                child: Visibility(
                  visible:
                      generatedContent == null && generatedImageUrl == null,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 10, left: 22),
                    child: const Text(
                      '  Get your Answers with',
                      style: TextStyle(
                        fontFamily: 'Cera Pro',
                        color: Pallete.whiteColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // features list
              Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child:                    
                    SlideInLeft(
                      delay: Duration(milliseconds: start + 2 * delay),
                      child: const FeatureBox(
                        color: Pallete.thirdSuggestionBoxColor,
                        headerText: 'Smart Voice Assistant',
                        descriptionText:
                            'Get the best of the world with a voice assistant powered by ChatGPT',
                      ),
                    ),
              )
            ],
          ),
        ),
        floatingActionButton: FadeInUp(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: FloatingActionButton(
                    backgroundColor: Colors.red,
                    onPressed: stopSpeaking,
                    tooltip: 'Stop Speaking',
                    child: const Icon(Icons.stop),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: () async {
                    if (await speechToText.hasPermission &&
                        speechToText.isNotListening) {
                      await startListening();
                    } else if (speechToText.isListening) {
                      final speech =
                          await openAIService.isArtPromptAPI(lastWords);
                      if (speech.contains('https')) {
                        generatedImageUrl = speech;
                        generatedContent = null;
                        setState(() {});
                      } else {
                        generatedImageUrl = null;
                        generatedContent = speech;
                        setState(() {});
                        await systemSpeak(speech);
                      }
                      await stopListening();
                    } else {
                      initSpeechToText();
                    }
                  },
                  tooltip: speechToText.isListening ? 'Stop Listening' : 'Start Listening',
                  child: Icon(
                    speechToText.isListening ? Icons.stop: Icons.mic,
                    
                  ),
                ),
              ),
            ],
          ),
        )
        );
  }
}
