import 'package:dio/dio.dart';
import 'package:master_utility/src/api_helper/response/api_response.dart';

/// generic json mapper
typedef JsonMapper<T> = T Function(Map<String, dynamic>);

/// generic list json mapper
typedef ListJsonMapper<T> = T Function(List<dynamic>);

/// Error Mapper
typedef CustomErrorMapper<T> = APIResponse<T> Function(Response<dynamic> response);
