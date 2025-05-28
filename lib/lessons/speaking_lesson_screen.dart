import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class SpeakingLessonScreen extends StatefulWidget {
  const SpeakingLessonScreen({super.key});

  @override
  State<SpeakingLessonScreen> createState() => _SpeakingLessonScreenState();
}

class _SpeakingLessonScreenState extends State<SpeakingLessonScreen> {
  final List<String> prompts = [
    'Introduce yourself in 2 sentences.',
    'Describe your favorite food.',
    'Talk about what you did yesterday.',
  ];

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  int? _recordingPromptIndex;

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // Show a dialog or message instead of throwing
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission not granted')),
        );
      }
      return;
    }
    await _recorder.openRecorder();
    setState(() {
      _isRecorderInitialized = true;
    });
  }

  Future<String> _getFilePath(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/recording_prompt_$index.aac';
  }

  Future<void> _startRecording(int index) async {
    if (!_isRecorderInitialized) return;
    try {
      final path = await _getFilePath(index);
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      );
      setState(() {
        _isRecording = true;
        _recordingPromptIndex = index;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting recording: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecorderInitialized) return;
    try {
      final path = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _recordingPromptIndex = null;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recording saved: $path')),
        );
      }

      // You can send the `path` file to backend or analyze it here
      print('Recorded file path: $path');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping recording: $e')),
        );
      }
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Speaking Skills')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: prompts.length,
        itemBuilder: (context, index) {
          bool isRecordingThisPrompt = _isRecording && _recordingPromptIndex == index;
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prompts[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  if (isRecordingThisPrompt)
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Recording...',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
              trailing: IconButton(
                icon: Icon(isRecordingThisPrompt ? Icons.stop : Icons.mic),
                color: isRecordingThisPrompt ? Colors.red : Colors.blue,
                onPressed: () {
                  if (isRecordingThisPrompt) {
                    _stopRecording();
                  } else {
                    _startRecording(index);
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
