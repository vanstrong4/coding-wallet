import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  Future<void> sendOtp({required String email, required String otp}) async {
    await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_gvcgja5',
        'template_id': 'template_slvs558',
        'user_id': 'FQoXW7b-klauguaWJ',
        'template_params': {'to_email': email, 'otp': otp},
      }),
    );
  }
}
