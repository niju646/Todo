class CategoryModel {
  String? message;
  Data? data;

  CategoryModel({this.message, this.data});

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  int? id;
  String? name;
  int? userId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? categoryId;

  Data({this.id, this.name, this.userId, this.updatedAt, this.createdAt});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    userId: json["user_id"],
    updatedAt: json["updatedAt"] == null
        ? null
        : DateTime.parse(json["updatedAt"]),
    createdAt: json["createdAt"] == null
        ? null
        : DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "user_id": userId,
    "updatedAt": updatedAt?.toIso8601String(),
    "createdAt": createdAt?.toIso8601String(),
  };
}
