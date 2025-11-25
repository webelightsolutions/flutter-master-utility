import 'package:master_utility/master_utility.dart';

/// generic json mapper
typedef JsonMapper<T> = T Function(Map<String, dynamic>);

/// generic json mapper
typedef JsonMapperDynamic<T> = T Function(dynamic);

/// generic list json mapper
typedef ListJsonMapper<T> = T Function(List<dynamic>);

/// generic error mapper
typedef ErrorMapper<T> = T Function(Response<dynamic>?);
