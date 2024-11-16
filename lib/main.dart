import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Consumo de API")),
        body: PostsPage(),
      ),
    );
  }
}

class PostsPage extends StatefulWidget {
  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  Future<List<dynamic>> fetchPosts() async {
    // Corrige el uso de Uri.parse para evitar errores
    var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    // Verifica si la solicitud fue exitosa
    if (response.statusCode == 200) {
      // Decodifica el contenido de la respuesta como JSON
      var jsonResponse = json.decode(response.body);
      return jsonResponse;
    } else {
      // Lanza un error si la solicitud falla
      throw Exception('Error al cargar los posts');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error al cargar datos"));
        } else {
          // Muestra los datos en una lista
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0, // Usa null safety para evitar errores
            itemBuilder: (context, index) {
              var post = snapshot.data![index]; // Asegúrate de que no sea null antes de acceder
              return ListTile(
                title: Text(post['title']), // Muestra el título del post
                subtitle: Text(post['body']), // Muestra el cuerpo del post
              );
            },
          );
        }
      },
    );
  }
}

/*
Resumen de los cambios realizados:
1. Implementación del método `fetchPosts` para consumir la API REST:
   - Uso de `http.get` con `Uri.parse` para evitar errores.
   - Validación del estado de la respuesta (`response.statusCode`).
   - Decodificación del JSON de la respuesta usando `json.decode`.

2. Modificaciones en el `FutureBuilder`:
   - Validación de la longitud de los datos con `snapshot.data?.length ?? 0` para manejar casos donde `snapshot.data` sea `null`.
   - Uso del operador `!` en `snapshot.data![index]` para garantizar que los datos no sean nulos antes de acceder a ellos.

3. Actualización del método `itemBuilder`:
   - Configuración de `ListTile` para mostrar los valores de `title` y `body` en los widgets `Text`.

4. Manejo de estados y errores:
   - Se agregó un `CircularProgressIndicator` para mostrar una animación mientras se cargan los datos.
   - Se maneja el caso de error con un mensaje genérico en pantalla.

Resultado:
El código ahora muestra una lista de publicaciones con sus títulos y cuerpos, maneja errores, y utiliza las mejores prácticas de null safety.
*/
