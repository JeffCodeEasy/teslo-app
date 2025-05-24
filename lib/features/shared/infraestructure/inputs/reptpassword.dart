import 'package:formz/formz.dart';

// Define input validation errors
enum ConfirmedPasswordError { empty, equal }

// Extend FormzInput and provide the input type and error type.
class ConfirmedPassword extends FormzInput<String, ConfirmedPasswordError> {
  final String originalPassword;
  
  // Call super.pure to represent an unmodified form input.
  const ConfirmedPassword.pure({this.originalPassword = ''}) : super.pure('');

  // Call super.dirty to represent a modified form input.
  const ConfirmedPassword.dirty( super.value, this.originalPassword ) : super.dirty();


  String? get errorMessage {
    if ( isValid || isPure ) return null;

    if ( displayError == ConfirmedPasswordError.empty ) return 'El campo es requerido';
    if (displayError == ConfirmedPasswordError.equal) return 'Las contraseñas no coinciden';
    return null;
  }


  // Override validator to handle validating a given input value.
  @override
  ConfirmedPasswordError? validator(String value) {

    if ( value.isEmpty || value.trim().isEmpty ) return ConfirmedPasswordError.empty;
     if (value != originalPassword) return ConfirmedPasswordError.equal;

    return null;
  }
}