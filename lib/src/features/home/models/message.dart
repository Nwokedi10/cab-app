class Messages {
  String owner;
  String? desc;
  DateTime time;

  bool get isSentByMe => owner == "Me"; //if owner == current user

  Messages(this.time, {this.owner = "Me", this.desc});
}
