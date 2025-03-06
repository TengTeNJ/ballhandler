import 'dart:async';
import 'dart:collection';

class CommandSender {
  static CommandSender? _instance;

  final Duration timeout;
  final int maxRetries;
  late Stream<int> responseStream;
  // final void Function(String command) sendCommand;
  final controller = StreamController<int>.broadcast();
  factory CommandSender({
    Duration timeout = const Duration(milliseconds: 500),
    int maxRetries = 5,
  }) {
    _instance ??= CommandSender._internal(
      timeout: timeout,
      maxRetries: maxRetries,
    );
    return _instance!;
  }

  CommandSender._internal({
    required this.timeout,
    required this.maxRetries,
  }) {
     responseStream = controller.stream;
    _listenForResponses();
  }

  static void resetInstance({
    required Duration timeout,
    required int maxRetries,
    required Stream<String> responseStream,
    required void Function(String command) sendCommand,
  }) {
    _instance = CommandSender._internal(
      timeout: timeout,
      maxRetries: maxRetries,
    );
  }

  final Map<int, Completer<int>> _pendingCommands = {};
  final Queue<List<int>> _commandQueue = Queue();
  bool _isProcessing = false;

  void _listenForResponses() {
    responseStream.listen((response) {
     String commandId =  response.toString();
      if (_pendingCommands.keys.contains(commandId)) {
        _pendingCommands[commandId]!.complete(response);
        _pendingCommands.remove(commandId);
        _isProcessing = false;
        _processNextCommand();
      }
    });
  }

  void addCommand(List<int> command) {
    _commandQueue.add(command);
    if (!_isProcessing) {
      _processNextCommand();
    }
  }

  void _processNextCommand() {
    if (_commandQueue.isEmpty || _isProcessing) return;
    _isProcessing = true;
    _sendWithRetry(_commandQueue.removeFirst());
  }

  Future<void> _sendWithRetry(List<int> command) async {
    var completer = Completer<int>();
    int _id = 100;
    if(command.length >= 4){
      _id = command[3];
    }
    _pendingCommands[_id] = completer;

    int attempt = 0;
    while (attempt < maxRetries) {
      // 发送蓝牙指令
     // sendCommand(fullCommand);
      try {
        await completer.future.timeout(timeout);
        return; // 成功收到响应，结束
      } catch (_) {
        print('等待超时');
        attempt++;
      }
    }
    _pendingCommands.remove(_id);
    _isProcessing = false;
    _processNextCommand();
    throw TimeoutException("No response received for command: $command");
  }

  String _generateCommandId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
