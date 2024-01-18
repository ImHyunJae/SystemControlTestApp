import 'dart:io';

class TcpClientSocket {
  final String ipAddress = "";
  final int portNo = 0;
  Socket? _socket;

  TcpClientSocket({required ipAddress, required int portNo}) {}

  Future<void> connect(String serverIP, int serverPort) async {
    try {
      _socket = await Socket.connect(serverIP, serverPort);
      print(
          'Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}');

      // Send a message to the server
      _socket!.write('Hello, Server!');

      // Listen for incoming data from the server
      _socket!.listen(
        (List<int> data) {
          String message = String.fromCharCodes(data);
          print('Received from server: $message');
        },
        onDone: () {
          print('Connection closed by server.');
          _socket!.destroy();
        },
        onError: (error) {
          print('Error: $error');
          _socket!.destroy();
        },
        cancelOnError: true,
      );
    } catch (error) {
      print('Unable to connect to the server: $error');
    }
  }
}

void test() {
  final tcp_client_socket = TcpClientSocket(
    ipAddress: "127.0.0.1",
    portNo: 50001,
  );
}
