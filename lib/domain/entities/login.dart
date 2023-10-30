import 'package:equatable/equatable.dart';

class Login extends Equatable {
  const Login({
    required this.occupationLevel,
    required this.occupationName,
  });

  final int occupationLevel;
  final String occupationName;

  @override
  List<Object?> get props => [occupationLevel, occupationName];
}
