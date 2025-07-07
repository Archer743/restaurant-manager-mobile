import 'package:json_annotation/json_annotation.dart';

part 'auth_refresh_model.g.dart';

@JsonSerializable()
class AuthRefreshModel {
  final String refreshToken;

  AuthRefreshModel(this.refreshToken);

  Map<String, dynamic> toJson() => _$AuthRefreshModelToJson(this);
}
