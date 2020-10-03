import 'dart:async';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

Future<dynamic> reqWss(String _text) {
  //var channel = HtmlWebSocketChannel.connect("ws://localhost:6628");
  var channel = HtmlWebSocketChannel.connect("ws://shpp.me:6628");

  //var channel = WebSocketChannel.connect(Uri(path: "ws://shpp.me:6628"));
  //var channel = IOWebSocketChannel.connect("ws://shpp.me:6628");

  final c = new Completer();

  channel.stream.listen((message) {
    print('got answer msg $message');
    channel.sink.close(status.goingAway);
    String res = message as String;
    c.complete(res);
  });

  channel.sink.add(_text);
  return c.future;
}
