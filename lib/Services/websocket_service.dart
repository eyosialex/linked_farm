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
  Stream? _broadcastStream;
  
  // Replace with your actual WebSocket server URL
  // Example: 'ws://your-backend-server.com:8080'
  final String _url = 'wss://echo.websocket.org'; // Echo server for demo

  Stream get stream {
    if (_channel == null) {
      connect();
    }
    _broadcastStream ??= _channel!.stream.asBroadcastStream();
    return _broadcastStream!;
  }
  bool _isConnected = false;
  void connect() {
    if (_isConnected) return;
    try {
      _channel = IOWebSocketChannel.connect(Uri.parse(_url));
      _broadcastStream = _channel!.stream.asBroadcastStream();
      _isConnected = true;
      print("✅ Connected to WebSocket: $_url");
    } catch (e) {
      print("❌ WebSocket Connection Error: $e");
    }
  }

  void sendMessage(String senderId, String receiverId, String message) {
    if (_channel == null || !_isConnected) {
      connect();
    }
    
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
    _channel = null;
    _broadcastStream = null;
    _isConnected = false;
    print("🔌 WebSocket Disconnected and Reset");
  }
}
