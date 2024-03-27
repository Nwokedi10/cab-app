class Bank {
  int id;
  String code, name;

  Bank(this.id, this.code, this.name);

  factory Bank.fromJSON(Map<String, dynamic> json) {
    return Bank(json["id"], json["code"], json["name"]);
  }
}
