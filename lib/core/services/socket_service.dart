import 'package:cloud_user/core/config/app_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_riverpod/flutter_riverpod.dart';

final socketServiceProvider = Provider((ref) => SocketService());

class SocketService {
  IO.Socket? _socket;

  // Initialized in main or wherever
  void init() {
    String url = AppConfig.baseUrl;
    if (url.endsWith('/api/')) {
      url = url.substring(0, url.length - 5);
    } else if (url.endsWith('/api')) {
      url = url.substring(0, url.length - 4);
    }

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .build(),
    );

    _socket?.onConnect((_) {
      print('Socket Connected: ${_socket?.id}');
    });

    _socket?.onConnectError((data) => print('Socket Error: $data'));
  }

  void joinRoom(String userId) {
    if (_socket != null) {
      _socket!.emit('join', userId);
    }

    // Also re-emit on reconnect
    _socket?.onConnect((_) {
      _socket!.emit('join', userId);
    });
  }

  void onNotification(Function(Map<String, dynamic>) callback) {
    _socket?.on('notification', (data) {
      print('Received notification: $data');
      if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  void dispose() {
    _socket?.disconnect();
  }
}
