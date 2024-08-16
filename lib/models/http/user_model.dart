import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class User {
  String nickName;
  int memberId;
  String avatar;
  int memberStatus;
  String memberToken;
  String createTime;
  String? realName;
 String birthday;
 String country;
 String accountNo;
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  User(
      {required this.nickName,
      required this.memberId,
      required this.avatar,
      required this.memberStatus,
      required this.memberToken,
      required this.createTime,
      required this.realName,
      required this.birthday,
      required this.country,
      required this.accountNo});
}
