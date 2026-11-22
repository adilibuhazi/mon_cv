
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      'http://localhost/api-test/public';

  // Tester la connexion à l'API
  static Future<bool> testerConnexion() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/famille-membres'),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // Créer un compte
  static Future<bool> inscrire(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      return response.statusCode == 201 &&
          data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Se connecter
  static Future<bool> seConnecter(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/accounts/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) return false;

      final data = jsonDecode(response.body);
      return data['success'] == true;
    } catch (e) {
      return false;
    }
  }

  // Afficher les membres de la famille
  static Future<List<dynamic>> getFamilyMembers() async {
    final response = await http.get(
      Uri.parse('$baseUrl/famille-membres'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data'] ?? [];
    }

    throw Exception('Erreur de chargement des membres');
  }

  // Ajouter un membre
  static Future<void> ajouterMembre(
    Map<String, dynamic> donnees,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/famille-membres'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(donnees),
    );

    if (response.statusCode != 201 &&
        response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  // Modifier un membre
  static Future<void> modifierMembre(
    int id,
    Map<String, dynamic> donnees,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/famille-membres/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(donnees),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  // Supprimer un membre
  static Future<void> supprimerMembre(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/famille-membres/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
