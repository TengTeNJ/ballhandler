// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      nickName: json['nickName'] as String,
      memberId: json['memberId'] as int,
      avatar: json['avatar'] as String,
      memberStatus: json['memberStatus'] as int,
      memberToken: json['memberToken'] as String,
      createTime: json['createTime'] as String,
      realName: json['realName'] as String?,
      birthday: json['birthday'] as String,
      country:  json['country'] as String,
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
