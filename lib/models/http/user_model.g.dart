// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickName: json['nickName'] ?? '',
      memberId: json['memberId'] ?? 0,
      avatar: json['avatar'] ?? '',
      memberStatus: json['memberStatus'] ?? 0,
      memberToken: json['memberToken'] ?? '',
      createTime: json['createTime'] ?? '',
      realName: json['realName'] ?? '',
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
