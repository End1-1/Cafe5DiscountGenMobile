// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerConfig _$ServerConfigFromJson(Map<String, dynamic> json) => ServerConfig(
      ip: json['ip'] as String,
      port: json['port'] as String,
    );

Map<String, dynamic> _$ServerConfigToJson(ServerConfig instance) =>
    <String, dynamic>{
      'ip': instance.ip,
      'port': instance.port,
    };
