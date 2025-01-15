import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sparc_sports_app/src/auth/auth_user.dart';
import 'package:sparc_sports_app/src/auth/bloc/auth_state.dart';
import 'package:sparc_sports_app/src/sparc/services/auth_service.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoginWithEmailAndPassword>(_onLoginWithEmailAndPassword);
    on<Logout>(_onLogout);
  }

  Future<void> _onAppStarted(
      AppStarted event, Emitter<AuthState> emit) async {
    try {
      final user = _authService.getCurrentUser();
      if (user != null) {
        emit(Authenticated(user as AuthUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLoginWithEmailAndPassword(
      LoginWithEmailAndPassword event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
          event.email, event.password);
      emit(Authenticated(userCredential.user! as AuthUser));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _authService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

}