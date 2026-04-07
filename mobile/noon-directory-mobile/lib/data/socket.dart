import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/app_strings.dart';
import 'package:noon/core/print_value.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket _socket;
  final _box = Hive.box(AppStrings.boxKey);
  bool _isInitialized = false;
  bool _isConnecting = false;
  final _maxReconnectAttempts = 3;

  bool get isConnected => _socket.connected;

  bool get isConnecting => _isConnecting;

  bool get isInitialized => _isInitialized;

  void init(String api) {
    if (_isInitialized) {
      dprint(tag: 'Socket', '⚠️ Socket already initialized');
      return;
    }

    try {
      String accessToken = _box.get(AppStrings.tokenKey);

      _socket = io(
        api,
        OptionBuilder()
            .setTransports(['websocket'])
            .setExtraHeaders({'Authorization': 'Bearer $accessToken'})
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(2000)
            .build(),
      );

      dprint(tag: 'Socket', '✅ Socket initialized successfully');
      _isInitialized = true;
    } catch (e) {
      dprint(tag: 'Socket', '❌ Failed to initialize socket: $e');
      rethrow;
    }
  }

  bool connect() {
    if (!_isInitialized) {
      dprint(
        tag: 'Socket',
        '❌ Cannot start connection: Socket not initialized',
      );
      return false;
    }

    if (_isConnecting) {
      dprint(tag: 'Socket', '⚠️ Connection attempt already in progress');
      return false;
    }

    if (isConnected) {
      dprint(tag: 'Socket', '✅ Already connected');
      return true;
    }

    _isConnecting = true;

    try {
      _socket.connect();
      dprint(tag: 'Socket', '🚀 Connection attempt started');
      return true;
    } catch (e) {
      dprint(tag: 'Socket', '❌ Failed to start connection, $e');
      return false;
    } finally {
      _isConnecting = false;
    }
  }

  void disconnect() {
    if (!_isInitialized) {
      dprint(tag: 'Socket', '⚠️ Socket not initialized');
      return;
    }

    if (_socket.disconnected) {
      dprint(tag: 'Socket', '✅ Already disconnected');
      return;
    }

    try {
      _socket.disconnect();
      dprint(tag: 'Socket', '✅ Disconnected');
    } catch (e) {
      dprint(tag: 'Socket', '❌ Error disconnecting: $e');
    }
  }

  void onConnect(void Function(dynamic) callback) {
    _socket.onConnect(callback);
  }

  void onConnectError(void Function(dynamic) callback) {
    _socket.onConnectError(callback);
  }

  void onDisconnect(void Function(dynamic) callback) {
    _socket.onDisconnect(callback);
  }

  void onReconnecting(void Function(dynamic) callback) {
    _socket.onReconnectAttempt(callback);
  }

  void onReconnected(void Function(dynamic) callback) {
    _socket.onReconnect(callback);
  }

  void on(String eventName, Function(dynamic) callback) {
    _socket.on(eventName, (message) {
      dprint(tag: 'Socket', '✅ Received event: $eventName - $message');
      callback(message);
    });
  }

  void stopListening(String eventName) {
    _socket.off(eventName);
    dprint(tag: 'Socket', '✅ Stopped listening to event: $eventName');
  }

  void emit(String methodName, {dynamic args}) {
    if (!_isInitialized) {
      throw Exception('Socket not initialized. Call init() first.');
    }

    if (!isConnected) {
      dprint(
        tag: 'Socket',
        '❌ Socket is not connected, cannot emit $methodName',
      );
      throw Exception(
        'Cannot send data if the socket is not in the connected state.',
      );
    }

    try {
      _socket.emit(methodName, [args]);
      dprint(
        tag: 'Socket',
        '✅ Method "$methodName" emitted successfully, args: $args',
      );
    } catch (e) {
      dprint(tag: 'Socket', '❌ Failed to emit method "$methodName": $e');
      rethrow;
    }
  }

  void dispose() {
    if (_isInitialized) {
      disconnect();
      _isInitialized = false;
      _socket.dispose();
    }
  }
}
