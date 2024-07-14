import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path/path.dart' as path;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Простой чат',
      home: ChatScreen(userId: 'User1'),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String userId;

  ChatScreen({required this.userId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<Message> _messages = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentAudioFilePath;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.userId}'),
        actions: [
          IconButton(
            icon: Icon(Icons.attach_file),
            onPressed: _pickAudioFile,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messageBubble(_messages[index]);
              },
            ),
          ),
          _buildTextComposer(),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(hintText: 'Введите сообщение'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    final messageText = _textController.text.trim();
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: messageText, isSentByMe: true));
        _textController.clear();
      });
    }
  }

  void _pickAudioFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      String fileName = path.basename(file.path!);
      setState(() {
        _messages.add(Message(audioFilePath: file.path, isSentByMe: true, audioFileName: fileName));
      });
    }
  }

  Widget _messageBubble(Message message) {
    return Align(
      alignment: message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Card(
          color: message.isSentByMe ? Colors.blue : Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (message.text != null)
                  Flexible(
                    child: Wrap(
                      children: [
                        Text(
                          message.text!,
                          style: TextStyle(color: message.isSentByMe ? Colors.white : Colors.black),
                        ),
                      ],
                    ),
                  ),
                if (message.audioFilePath != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        message.audioFileName!,
                        style: TextStyle(color: message.isSentByMe ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(_isPlaying && _currentAudioFilePath == message.audioFilePath
                                ? Icons.pause
                                : Icons.play_arrow),
                            onPressed: () => _togglePlayPauseAudio(message.audioFilePath!),
                          ),
                          IconButton(
                            icon: Icon(Icons.stop),
                            onPressed: _stopAudio,
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _togglePlayPauseAudio(String filePath) {
    if (_isPlaying && _currentAudioFilePath == filePath) {
      _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        _currentAudioFilePath = filePath;
        _isPlaying = true;
      });
    }
  }

  void _stopAudio() {
    _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
      _currentAudioFilePath = null;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class Message {
  final String? text;
  final bool isSentByMe;
  final String? audioFilePath;
  final String? audioFileName;

  Message({this.text, required this.isSentByMe, this.audioFilePath, this.audioFileName});
}
