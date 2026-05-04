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
        _resultUrl = response.data['url'];
      });
      //Si hay un error, lo imprime.
    } catch (e) {
      print("Error: $e");
    }
  }

  //Función para construir la interfaz de usuario.
  @override
  Widget build(BuildContext context) {
    //Regresa un Scaffold que es el esqueleto de la pantalla.
    return Scaffold(
      //Barra superior.
      appBar: AppBar(title: const Text("Foto Profesional")),
      //Cuerpo de la pantalla.
      body: Padding(
        //Espaciado.
        padding: const EdgeInsets.all(16),
        //Column es un widget que permite mostrar widgets en una columna vertical.
        child: Column(
          //Lista de widgets a mostrar.
          children: [
            //Botón para seleccionar la imagen.
            ElevatedButton(
              onPressed: pickImage,
              child: const Text("Seleccionar Imagen"),
            ),
            //Espaciado.
            const SizedBox(height: 10),
            //Si hay imagen, la muestra.
            if (_image != null) Image.file(_image!, height: 200),
            //Espaciado.
            const SizedBox(height: 10),
            //Botón para subir la imagen.
            ElevatedButton(
              onPressed: uploadImage,
              child: const Text("Procesar Imagen"),
            ),
            //Espaciado.
            const SizedBox(height: 20),
            //Si hay resultado, lo muestra.
            if (_resultUrl != null) Image.network(_resultUrl!, height: 200),
          ],
        ),
      ),
    );
  }
}
