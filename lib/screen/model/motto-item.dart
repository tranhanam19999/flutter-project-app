class MottoItem {
  final String creatorId;
  final String content;

  const MottoItem({
    required this.creatorId,
    required this.content,
  });

  factory MottoItem.fromJson(Map<String, dynamic> json) {
    return MottoItem(
      creatorId: json['creatorId'],
      content: json['content'],
    );
  }
}
