import 'dart:convert';

Map<String, dynamic> parseTranslations(String body) {
  return json.decode(body) as Map<String, dynamic>;
}
