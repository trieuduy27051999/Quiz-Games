import 'dart:convert';
import 'package:http/http.dart' as http;
class QuizService {
  final String apiUrl = 'https://vou.tuan-anh-sd.software/quiz-set';
  Future<List<dynamic>> fetchQuizData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      // Kiểm tra mã trạng thái của phản hồi
      if (response.statusCode == 200) {
        // Nếu thành công, chuyển đổi dữ liệu JSON thành đối tượng Dart
        final data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Lỗi khi tải dữ liệu');
      }
    } catch (e) {
      throw Exception('Có lỗi khi kết nối đến API: $e');
    }
  }

}