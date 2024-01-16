import 'dart:io';

class TcpClientSocket {
  final String ipAddress = "";
  final int portNo = 0;
  Socket? client_socket;

  TcpClientSocket({required ipAddress, required int portNo}) {}

  bool Connect() {
    return true;
  }
}

void test() {
  final tcp_client_socket = TcpClientSocket(
    ipAddress: "127.0.0.1",
    portNo: 50001,
  );
}
