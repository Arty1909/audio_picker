# audio_picker
Simple Chat Application
This Flutter application provides a simple chat interface with support for text and audio messages. Users can send text messages, attach audio files, and play/pause or stop the audio files directly within the chat.

Features
Text Messaging: Users can compose and send text messages.
Audio Messaging: Users can pick audio files from their device and send them as messages.
Audio Playback: Users can play, pause, and stop the audio messages within the chat interface.

Dependencies
flutter/material.dart: Provides Flutter's Material Design widgets.
file_picker: Allows users to pick audio files from their device.
audioplayers: Facilitates audio playback for the selected audio files.
path: Helps in handling file paths.

How It Works
ChatScreen Widget: The main screen of the app where users can send and view messages.

Text Composer: 
Allows users to input and send text messages.
Audio File Picker: Users can attach audio files using the file picker, which gets displayed as part of the chat messages.
Message Bubble: Displays text and audio messages. For audio messages, playback controls (play/pause and stop) are provided.
Message Class: A data model representing a message. It contains fields for text, sender information, audio file path, and audio file name.
