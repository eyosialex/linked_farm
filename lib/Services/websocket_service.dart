import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

class WebSocketService {
  // Singleton pattern
  static final WebSocketService _instance = WebSocketService._internal();

  factory WebSocketService() {
    return _instance;
  }

  WebSocketService._internal();

  WebSocketChannel? _channel;
  
  // Replace with your actual WebSocket server URL
  // Example: 'ws://your-backend-server.com:8080'
  final String _url = 'wss://echo.websocket.org'; // Echo server for demo

  Stream get stream => _channel!.stream;
  
  bool _isConnected = false;

  void connect() {
    if (_isConnected) return; // Don't reconnect if already connected
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(_url));
      _isConnected = true;
      print("✅ Connected to WebSocket: $_url");
    } catch (e) {
      print("❌ WebSocket Connection Error: $e");
    }
  }

  void sendMessage(String senderId, String receiverId, String message) {
    if (_channel != null) {
      final payload = jsonEncode({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': DateTime.now().toIso8601String(),
      });
      _channel!.sink.add(payload);
      print("📤 Message sent via WebSocket");
    }
  }

  void disconnect() {
    _channel?.sink.close();
    print("🔌 WebSocket Disconnected");
  }
}
