class Note {
  late int id;
  late String head;
  late String body;

  Note({
    required this.id,
    required this.head,
    required this.body,
  });

  Map<String, dynamic> fromJson() {
    return {'id': id, 'head': head, 'body': body};
  }

  Note.toJson(Map<String, dynamic> res)
      : id = res['id'],
        head = res['head'],
        body = res['body'];
}
