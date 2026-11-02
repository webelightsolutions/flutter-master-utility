import 'package:master_utility/master_utility.dart';

void main() {
  final APIRequest request = APIRequest(
    url: '/users',
    methodType: MethodType.POST,
    params: {'name': 'Asha'},
    paramList: [1],
    header: {'x': '1'},
    isAuthorization: false,
  );
  request.params = {'name': 'Ravi'};
  print(request.paramList);
  print(request.header);
  print(request.isAuthorization);

  APIConstError.kSomethingWentWrong = 'Oops';
  print(APIConstError.kNoInternetConnection2);
  print(APIConstError.kTimeOut);
  print(APIConstError.kInvalidStatusCode(statusCode: 500));

  print(APIService().setErrorData(null));
  print(ErrorHandler.instance.getDioError(DioException(requestOptions: RequestOptions())));
}
