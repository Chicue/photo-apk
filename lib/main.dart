//permite trabajar con archivos del sistema, en este caso, la foto (File) seleccionada del dispositivo
import 'dart:io';
// Importa el diseño visual de Material Design (botones, barras, textos).
import 'package:flutter/material.dart';
//paquete para seleccionar imágenes de la galería o cámara del dispositivo
import 'package:image_picker/image_picker.dart';
//paquete para enviar solicitudes HTTP, en este caso, la foto al servidor
import 'package:dio/dio.dart';

//Es la función que Flutter busca para arrancar la app. Llama a runApp pasando tu widget inicial.
void main() {
  runApp(const MyApp());
}

bool _isLoading = false;

//Es un Widget sin estado (StatelessWidget) que define la estructura básica de la aplicación.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

//Es un Widget con estado (StatefulWidget). Esto significa que puede almacenar datos que cambian con el tiempo (como la imagen seleccionada o el resultado).
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

//Aquí está la lógica.
//Sirve para guardar la imagen seleccionada (_image), la URL del resultado (_resultUrl), el selector (picker) y el cliente HTTP (dio).
class _HomePageState extends State<HomePage> {
  //Variable para almacenar la imagen seleccionada.
  File? _image;
  //Variable para almacenar la URL del resultado.
  String? _resultUrl;
  //Selector de imágenes.
  final picker = ImagePicker();
  //Cliente HTTP.
  final dio = Dio();

  //Función para seleccionar la imagen.
  Future pickImage() async {
    //Selecciona la imagen de la galería.
    final picked = await picker.pickImage(source: ImageSource.gallery);

    //Si se seleccionó una imagen.
    if (picked != null) {
      //Actualiza el estado.
      setState(() {
        //Convierte el archivo seleccionado en un objeto File.
        _image = File(picked.path);
      });
    }
  }

  //Función para subir la imagen.
  Future uploadImage() async {
    //Si no hay imagen, no hace nada.
    if (_image == null) return;

    setState(() => _isLoading = true);
    //Obtiene el nombre del archivo.
    String fileName = _image!.path.split('/').last;

    //Crea un formulario con la imagen.
    FormData formData = FormData.fromMap({
      "photo": await MultipartFile.fromFile(_image!.path, filename: fileName),
    });

    //Envía la imagen al servidor.
    try {
      final response = await dio.post(
        "http://10.0.2.2:8000/api/process-photo",
        data: formData,
      );
      //Actualiza el estado con la URL del resultado.
      setState(() {
        _isLoading = false;
        _resultUrl = response.data['url'];
      });
      //Si hay un error, lo imprime.
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error procesando la imagen")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCDCCDE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCDCCDE),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Foto Profesional",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Stack(
        children: [
          /// 🟢 CONTENIDO NORMAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // 🔲 IMAGEN
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400, width: 2),
                    ),
                    child: _image == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cloud_upload,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Toca para subir tu foto",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.file(_image!, fit: BoxFit.cover),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                /// 🔘 BOTÓN
                if (_image != null)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: uploadImage,
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color(0xFF552E8B);
                              }
                              return const Color(0xFF5D01E1);
                            }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Procesar Imagen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 25),

                /// 🖼 RESULTADO
                if (_resultUrl != null)
                  Column(
                    children: [
                      const Text(
                        "Resultado",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.network(_resultUrl!, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          /// 🔴 OVERLAY (CORRECTO)
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.7),
                child: const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 20),
                      Text(
                        "Procesando tu foto...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Esto puede tardar unos segundos",
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
