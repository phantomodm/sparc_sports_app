import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket _socket;

  SocketService() {
    _initSocket();
  }

  void _initSocket() {
    _socket = io.io('YOUR_SOCKET_SERVER_URL', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    _socket.connect();

    _socket.onConnect((_) {
      print('Connected to socket');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from socket');
    });

    _socket.onError((data) {
      print('Socket error: $data');
    });
  }

  Future<dynamic> emit(String event, [dynamic data]) {
    return Future.delayed(Duration.zero, () {
      _socket.emit(event, data);
    });
  }

  void on(String event, Function(dynamic data) callback) {
    _socket.on(event, callback);
  }

  void off(String event, [Function(dynamic data)? callback]) {
    _socket.off(event, callback);
  }

  void dispose() {
    _socket.dispose();
  }
}
