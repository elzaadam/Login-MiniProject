import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

// Events
abstract class MainEvents extends Equatable {
  const MainEvents();
  @override
  List<Object?> get props => [];
}

class VerifyAccount extends MainEvents {
  final String username;
  final String email;

  const VerifyAccount({required this.username, required this.email});

  @override
  List<Object?> get props => [username, email];
}

// States
abstract class MainStates extends Equatable {
  const MainStates();
  @override
  List<Object?> get props => [];
}

class InitialState extends MainStates {}

class Loading extends MainStates {}

class LoginSuccess extends MainStates {}

class LoginFailure extends MainStates {}

// Bloc
class MainBloc extends Bloc<MainEvents, MainStates> {
  MainBloc() : super(InitialState()) {
    on<VerifyAccount>(_verifyAccount);
  }

  Future<void> _verifyAccount(
      VerifyAccount event, Emitter<MainStates> emit) async {
    emit(Loading());
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        // Check if credentials match
        final user = users.firstWhere(
          (u) => u['username'] == event.username && u['email'] == event.email,
          orElse: () => null,
        );

        if (user != null) {
          emit(LoginSuccess());
        } else {
          emit(LoginFailure());
        }
      } else {
        emit(LoginFailure());
      }
    } catch (_) {
      emit(LoginFailure());
    }
  }
}
