import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/shared/infraestructure/inputs/inputs.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  return RegisterFormNotifier();
});

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final FullName fullName;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.fullName = const FullName.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
  });

  @override
  String toString() {
    return '''
    CreateFormState:
      isPosting: $isPosting,
      isFormPosted: $isFormPosted,
      isValid: $isValid,
      fullName: $fullName,
      email: $email,
      password: $password,
      confirmedPassword: $confirmedPassword,
    ''';
  }

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    FullName? fullName,
    Email? email,
    Password? password,
    ConfirmedPassword? confirmedPassword,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      );
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  RegisterFormNotifier() : super(RegisterFormState());

  onFullNameChange(String value) {
    final newFullName = FullName.dirty(value: value);
    state = state.copyWith(
      fullName: newFullName,
      isValid: Formz.validate([
        newFullName,
        state.email,
        state.password,
        state.confirmedPassword,
      ]),
    );
  }

  onEmailChanged(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail,
        isValid: Formz.validate([
          newEmail,
          state.fullName,
          state.password,
          state.confirmedPassword,
        ]));
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([
          newPassword,
          state.email,
          state.fullName,
          state.confirmedPassword,
        ]));
  }

  onConfirmedPasswordChanged(String value) {
    final newConfirmedPassword = ConfirmedPassword.dirty(
      value,
      state.password.value,
    );
    state = state.copyWith(
        confirmedPassword: newConfirmedPassword,
        isValid: Formz.validate([
          newConfirmedPassword,
          state.email,
          state.fullName,
          state.password,
        ]));
  }

  onFormSubmit() {
    _touchEveryField();

    if (!state.isValid) return;

    print(state);
  }

  _touchEveryField() {
    final fullName = FullName.dirty(value: state.fullName.value);
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final repeatPassword = ConfirmedPassword.dirty(
      state.confirmedPassword.value,
      state.password.value,
    );

    state = state.copyWith(
      isFormPosted: true,
      fullName: fullName,
      email: email,
      password: password,
      confirmedPassword: repeatPassword,
      isValid: Formz.validate([fullName, email, password, repeatPassword]),
    );
  }
}
