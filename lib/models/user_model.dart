class UserModel {
  final String uid;
  final String companyName;
  final String ownerName;
  final String mobileNumber;
  final DateTime? createdAt;
  final DateTime? lastLogin;

  UserModel({
    required this.uid,
    required this.companyName,
    required this.ownerName,
    required this.mobileNumber,
    this.createdAt,
    this.lastLogin,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      companyName: map['companyName'] ?? '',
      ownerName: map['ownerName'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      createdAt: map['createdAt']?.toDate(),
      lastLogin: map['lastLogin']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'companyName': companyName,
      'ownerName': ownerName,
      'mobileNumber': mobileNumber,
      'createdAt': createdAt,
      'lastLogin': lastLogin,
    };
  }

  UserModel copyWith({
    String? uid,
    String? companyName,
    String? ownerName,
    String? mobileNumber,
    DateTime? createdAt,
    DateTime? lastLogin,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      companyName: companyName ?? this.companyName,
      ownerName: ownerName ?? this.ownerName,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
} 