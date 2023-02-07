import 'package:json_annotation/json_annotation.dart';

part 'server_config.g.dart';

@JsonSerializable()
class ServerConfig {
  final String ip;
  final String port;

  const ServerConfig({required this.ip, required this.port});

  factory ServerConfig.fromJson(Map<String, dynamic> json) => _$ServerConfigFromJson(json);

  Map<String, dynamic> toJson() => _$ServerConfigToJson(this);
}

