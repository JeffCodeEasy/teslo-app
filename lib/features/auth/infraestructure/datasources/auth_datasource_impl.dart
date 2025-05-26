import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(
    BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout:
          const Duration(seconds: 5), // Tiempo para establecer la conexión
      receiveTimeout: const Duration(seconds: 3), // Tiempo para recibir datos
    ),
  );

  @override
  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/auth/check-status',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      // print(e);
      if (e.response?.statusCode == 401) {
        throw CustomError('Token incorrecto');
      }

       if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
            'No se pudo conectar al servidor. Verifica tu conexión o intenta más tarde.');
      }

      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (e) {
      // print(e);
      if (e.response?.statusCode == 401) {
        throw CustomError(
            e.response?.data['message'] ?? 'Credenciales Incorrectas');
      }
      // *** Nuevo: Manejar errores de conexión ***
      // DioExceptionType.connectionError para problemas generales de red (DNS, host no encontrado, etc.)
      // DioExceptionType.connectionTimeout si la conexión se estableció pero no se pudo enviar/recibir en el tiempo.
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        throw CustomError(
            'No se pudo conectar al servidor. Verifica tu conexión o intenta más tarde.');
      }
      throw Exception();
    } catch (e) {
      throw Exception();
    }
  }

  @override
  Future<User> register(String email, String password, String fullName) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
