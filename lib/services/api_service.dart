import 'package:dio/dio.dart';
import '../models/photo_options.dart';

class ApiService {
  final Dio _dio = Dio();

  // ⚠️  Cambia esta URL por la de tu servidor Laravel
  // Emulador Android: 10.0.2.2  |  Dispositivo físico: IP local  |  Producción: tu dominio
  static const String _base = 'http://10.0.2.2:8000';

  Future<String> processPhoto(PhotoOptions opts) async {
    if (opts.photo == null) throw Exception('No hay foto seleccionada');

    final formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(
        opts.photo!.path,
        filename: opts.photo!.path.split(RegExp(r'[/\\]')).last,
      ),
      'document_type': opts.documentType?.apiValue ?? '',
      'background_type': opts.backgroundType?.apiValue ?? '',
      'outfit_category': opts.outfitCategory ?? '',
      'outfit_name': opts.outfitName ?? '',
      'outfit_description': opts.outfitDescription ?? '',
      'prompt': opts.buildPrompt(),
    });

    try {
      final response = await _dio.post(
        '$_base/api/process-photo',
        data: formData,
        options: Options(
          headers: {'Accept': 'application/json'},
          receiveTimeout: const Duration(seconds: 120),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      if (response.statusCode == 200) {
        return response.data['url'] as String;
      }
      throw Exception('Error del servidor: ${response.statusCode}');
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          'Error del servidor (${e.response?.statusCode}). Por favor, intenta de nuevo más tarde.',
        );
      } else {
        throw Exception(
          'Error de red. Verifica que el servidor esté en ejecución y tengas conexión.',
        );
      }
    } catch (e) {
      throw Exception('Ocurrió un error inesperado al enviar la foto.');
    }
  }
}
