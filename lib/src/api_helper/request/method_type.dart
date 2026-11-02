/// HTTP method of an `APIRequest`. Lowercase names are aliases: `MethodType.get == MethodType.GET`.
enum MethodType {
  GET,
  POST,
  PATCH,
  PUT,
  DELETE;

  static const MethodType get = GET;
  static const MethodType post = POST;
  static const MethodType patch = PATCH;
  static const MethodType put = PUT;
  static const MethodType delete = DELETE;
}
