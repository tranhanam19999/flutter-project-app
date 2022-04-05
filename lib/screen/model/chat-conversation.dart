class ChatConversation {
  final String senderId;
  final String receiverId;
  final String content;

  const ChatConversation({
    required this.senderId,
    required this.receiverId,
    required this.content,
  });

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
    );
  }
}
