import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  void connect() {
    // Kết nối với server
    socket = IO.io('http://localhost:8002', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    // Lắng nghe sự kiện kết nối
    socket.on('connect', (_) {
      print('Connected to server');
    });

    // Lắng nghe các sự kiện khác
    socket.on('joinedRoom', (data) {
      print('Joined room: $data');
    });

    socket.on('newQuestion', (question) {
      print('New question: $question');
    });

    socket.on('leaderboard', (data) {
      print('Leaderboard: $data');
    });

    socket.on('disconnect', (_) {
      print('Disconnected from server');
    });
  }

  void joinRoom(String room, String username) {
    socket.emit('joinRoom', {'room': room, 'username': username});
  }

  void submitAnswer(String questionId, int answerIndex, String userId) {
    socket.emit('submitAnswer', {
      'questionId': questionId,
      'answerIndex': answerIndex,
      'userId': userId,
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
