import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:potenic/general/ApiUrl.dart';
import 'package:potenic/timeline.dart';

class ApiServices {
  Future<Map<String, dynamic>> getTimeLine(int userId, var givenDate) async {
    const timelineUrl = apiUrls.timeLineUrl;
    final url = '$timelineUrl$userId?givenDate=$givenDate';
    final response = await http.get(Uri.parse(url));
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // No need for loop, just return the data
      return data;
    } else {
      return {}; // Return empty map or handle error accordingly
    }
  }
}
