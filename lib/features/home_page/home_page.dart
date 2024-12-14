import 'package:ai_interview_prototype/core/voice_recognition/recorder_manager.dart';
import 'package:ai_interview_prototype/core/voice_recognition/stt.dart';
import 'package:ai_interview_prototype/core/voice_recognition/tts.dart';
import 'package:ai_interview_prototype/features/home_page/mic_icon.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isLoading;
  late String text;
  String? path;

  @override
  void initState() {
    isLoading = false;
    text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('GP AI Interview'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(text, style: const TextStyle(fontSize: 28)),
                GlowAvatarIcon(
                  icon: Icons.mic,
                  onPressed: (enabled) async {
                    if (enabled) {
                      path = await startRecording(audioFileName);
                    } else if (!enabled && path != null) {
                      await stopRecording();
                      text = await sendAudioToServer(path!);
                      setState(() {});
                      String audioPath = await recieveAudioFromServer(text);
                      await startPlayAudio(audioPath);
                      await File(path!).delete();
                      await File(audioPath).delete();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
