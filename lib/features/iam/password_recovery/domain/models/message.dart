class Message {
  final String message;

  Message({required this.message});

  Message copyWith({String? message}) {
    return Message(
      message: message ?? this.message,
    );
  }
}