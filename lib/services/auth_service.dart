import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Configura aquí la IP de tu WSL o de tu red local si pruebas en un teléfono físico
  // Para emulador Android hacia WSL normalmente es 10.0.2.2 o la IP de WSL
  static const String baseUrl = 'http://10.0.2.2:8000/api';
  
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final String _tokenKey = 'auth_token';

  AuthService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    // Interceptor para inyectar el token automáticamente en cada petición
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Getter para acceder a la instancia de Dio configurada
  Dio get dio => _dio;

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['access_token'];
        await _storage.write(key: _tokenKey, value: token);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        throw Exception('Credenciales incorrectas');
      }
      throw Exception('Error al iniciar sesión: ${e.message}');
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.statusCode == 201) {
        final token = response.data['access_token'];
        await _storage.write(key: _tokenKey, value: token);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        throw Exception('Datos inválidos: $errors');
      }
      throw Exception('Error al registrarse: ${e.message}');
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (e) {
      // Incluso si la petición al servidor falla (ej. sin internet),
      // borramos el token localmente para cerrar sesión en la app.
      print('Error al hacer logout en el servidor: $e');
    } finally {
      await _storage.delete(key: _tokenKey);
    }
  }
}
