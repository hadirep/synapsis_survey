import 'package:equatable/equatable.dart';
import 'package:synapsis_survey/domain/entities/login.dart';

class LoginModel extends Equatable {
  const LoginModel({
    required this.occupationLevel,
    required this.occupationName,
  });

  final int occupationLevel;
  final String occupationName;

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final login = json['data'];

    return LoginModel(
      occupationLevel: login["occupation_level"],
      occupationName: login["occupation_name"],
    );
  }

  Map<String, dynamic> toJson() => {
    "occupation_level": occupationLevel,
    "occupation_name": occupationName,
  };

  Login toEntity() {
    return Login(
      occupationLevel: occupationLevel,
      occupationName: occupationName,
    );
  }

  @override
  List<Object?> get props => [occupationLevel, occupationName];
}
