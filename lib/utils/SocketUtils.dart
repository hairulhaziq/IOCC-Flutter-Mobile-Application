import 'dart:convert';
import 'dart:io';
import 'package:adhara_socket_io/adhara_socket_io.dart';
import 'Globals.dart';
// http://www.coderzheaven.com/2020/05/18/chat-application-in-flutter-using-socket-io/

class SocketUtils {
  //
  static String _serverIP =
      Platform.isAndroid ? '192.168.116.41' : '192.168.116.41';
  static const int SERVER_PORT = 3003;
  static String _connectUrl = '$_serverIP:$SERVER_PORT';

  // Events
  static const String ON_MESSAGE_RECEIVED = 'receive_message';
  static const String SUB_EVENT_MESSAGE_SENT = 'message_sent_to_user';
  static const String IS_USER_CONNECTED_EVENT = 'is_user_connected';
  static const String IS_USER_ONLINE_EVENT = 'check_online';
  static const String SUB_EVENT_MESSAGE_FROM_SERVER = 'message_from_server';

  // Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;
  static const int STATUS_MESSAGE_DELIVERED = 10003;
  static const int STATUS_MESSAGE_READ = 10004;

  // Type of Chat
  static const String SINGLE_CHAT = 'single_chat';

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket() async {
    print('Connecting...');
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  _socketOptions() {
    return SocketOptions(
      Globals.rootSocketIO, // IP Configuration for socket
      enableLogging: true,
      transports: [Transports.WEB_SOCKET, Transports.POLLING],
      query: {
        "auth": "---",
        "info": "new connection",
        "timestamp": DateTime.now().toString()
      },
    );
  }

  connectToSocket() {
    if (null == _socket) {
      print("Socket is Null");
      return;
    }
    print("Connecting to socket...");
    _socket.connect();
  }

  emit(msg) {
    _socket.emit('report', [msg]);
  }

  setConnectListener(Function onConnect) {
    _socket.onConnect((data) {
      onConnect(data);
    });
  }

  setOnConnectionErrorListener(Function onConnectError) {
    _socket.onConnectError((data) {
      onConnectError(data);
    });
  }

  setOnConnectionErrorTimeOutListener(Function onConnectTimeout) {
    _socket.onConnectTimeout((data) {
      onConnectTimeout(data);
    });
  }

  setOnErrorListener(Function onError) {
    _socket.onError((error) {
      onError(error);
    });
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket.onDisconnect((data) {
      print("onDisconnect $data");
      onDisconnect(data);
    });
  }

  setResponderReceivedListener(Function onChatMessageReceived) {
    _socket.on('report', (data) {
      onChatMessageReceived(data);
    });
  }

//  setOnChatMessageReceivedListener(Function onChatMessageReceived) {
//    _socket.on('report', (data) {
//      onChatMessageReceived(data);
//    });
//  }

  setOnMessageSentToChatUserListener(Function onMessageSentListener) {
    _socket.on(SUB_EVENT_MESSAGE_SENT, (data) {
      print("onMessageSentListener $data");
      onMessageSentListener(data);
    });
  }

  setOnUserConnectionStatusListener(Function onUserConnectionStatus) {
    _socket.on(IS_USER_CONNECTED_EVENT, (data) {
      onUserConnectionStatus(data);
    });
  }

  closeConnection() {
    if (null != _socket) {
      print("Close Connection");
      _manager.clearInstance(_socket);
    }
  }
}
