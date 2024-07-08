import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static Future<dynamic> get({required String url}) async {
    http.Response response = await http.get(Uri.parse(url));
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'There is a problem with the status code ${response.statusCode}');
    }
  }
}
