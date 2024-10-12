class User {
  int id;
  String nom;
  String? prenom;
  String tel;
  String email;
  int entrepriseId;
  int isActive;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic codeAgent;

  User({
    required this.id,
    required this.nom,
    this.prenom,
    required this.tel,
    required this.email,
    required this.entrepriseId,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.codeAgent,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    nom: json["nom"],
    prenom: json["prenom"],
    tel: json["tel"],
    email: json["email"],
    entrepriseId: json["entreprise_id"],
    isActive: json["is_active"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    codeAgent: json["codeAgent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nom": nom,
    "prenom": prenom,
    "tel": tel,
    "email": email,
    "entreprise_id": entrepriseId,
    "is_active": isActive,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "codeAgent": codeAgent,
  };
}

class Entreprise {
  int id;
  String raisonSocial;
  String email;
  String tel;

  Entreprise({
    required this.id,
    required this.raisonSocial,
    required this.email,
    required this.tel,
  });

  factory Entreprise.fromJson(Map<String, dynamic> json) => Entreprise(
    id: json["id"],
    raisonSocial: json["raison_social"],
    email: json["email"],
    tel: json["tel"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "raison_social": raisonSocial,
    "email": email,
    "tel": tel,
  };
}
class UserResponse {
  String accessToken;
  String tokenType;
  User user;
  Entreprise entreprise;

  UserResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
    required this.entreprise,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    accessToken: json["access_token"],
    tokenType: json['token_type'],
    user: User.fromJson(json["user"]),
    entreprise: Entreprise.fromJson(json["entreprise"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "token_type": tokenType,
    "user": user.toJson(),
    "entreprise": entreprise.toJson(),
  };
}

class UserContact {
  String name;
  String tel;
  dynamic adresse;
  int userId;
  int entrepriseId;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  UserContact({
    required this.name,
    required this.tel,
    required this.adresse,
    required this.userId,
    required this.entrepriseId,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  factory UserContact.fromJson(Map<String, dynamic> json) => UserContact(
    name: json["name"],
    tel: json["tel"],
    adresse: json["adresse"],
    userId: json["user_id"],
    entrepriseId: json["entreprise_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    createdAt: DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "tel": tel,
    "adresse": adresse,
    "user_id": userId,
    "entreprise_id": entrepriseId,
    "updated_at": updatedAt.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "id": id,
  };
}