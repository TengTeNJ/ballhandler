// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickName: json['nickName'].toString() as String,
      memberId: json['memberId'] as int,
      avatar: json['avatar'].toString() as String,
      memberStatus: json['memberStatus'] as int,
      memberToken: json['memberToken'].toString() as String,
      createTime: json['createTime'].toString() as String,
      realName: json['realName'].toString() as String?,
      birthday: json['birthday'].toString()as String,
      country:  json['country'].toString() as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'nickName': instance.nickName,
      'memberId': instance.memberId,
      'avatar': instance.avatar,
      'memberStatus': instance.memberStatus,
      'memberToken': instance.memberToken,
      'createTime': instance.createTime,
      'realName': instance.realName,
    };
