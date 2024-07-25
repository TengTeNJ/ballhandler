import 'dart:io';
import 'dart:convert';

class UDPManager {
  RawDatagramSocket? socket;

  Future<void> startListening() async{
    // socket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345)
    //     .then((RawDatagramSocket udpSocket) {
    //   this.socket = udpSocket;
    //   this.socket!.listen((RawSocketEvent event) {
    //     if (event == RawSocketEvent.read) {
    //       Datagram? packet = socket!.receive();
    //       if (packet != null) {
    //         String message = utf8.decode(packet.data);
    //         print('Received message: $message');
    //       }
    //     }
    //   });
    // }).catchError((e) {
    //   print('Error starting UDP: $e');
    // });
  }

  void send(String message) {
    if (this.socket != null) {
      InternetAddress dest = InternetAddress('10.10.100.255'); // Replace with your destination IP
      int port = 8000; // Replace with your destination port

      this.socket!.send(utf8.encode(message), dest, port);
      print('Sent message: $message');
    } else {
      print('Socket not initialized.');
    }
  }

  void close() {
    socket?.close();
    print('Socket closed.');
  }
}

