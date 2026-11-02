// Records how the API helper behaves today, so the refactor can prove it changes nothing.
// Tests marked `skip:` describe known bugs (D1–D9 in API_HELPER_REFACTOR.md); each fix commit un-skips its own test.
// Uses the deprecated old names on purpose: apps still use them, so they must keep working.
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package
import 'dart:convert';
import 'dart:io';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:master_utility/master_utility.dart';
import 'package:master_utility/src/api_helper/error/api_error_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A request the test server received.
class ReceivedRequest {
  ReceivedRequest(this.method, this.path, this.authorizationHeader, this.body);

  final String method;
  final String path;
  final String? authorizationHeader;
  final dynamic body;
}

/// A reply the test server sends back.
class ServerReply {
  const ServerReply(this.statusCode, {this.body, this.reasonPhrase, this.contentType = 'application/json'});

  final int statusCode;
  final Object? body;
  final String? reasonPhrase;
  final String contentType;
}

/// Real local HTTP server. JWT refresh/retry use their own Dio clients, so a fake adapter can't reach them.
class TestServer {
  late HttpServer _httpServer;
  final List<ReceivedRequest> receivedRequests = [];
  ServerReply Function(ReceivedRequest request) replyTo = (request) => const ServerReply(200, body: {});

  String get baseUrl => 'http://${_httpServer.address.host}:${_httpServer.port}';

  int countRequestsTo(String path) => receivedRequests.where((request) => request.path == path).length;

  Future<void> start() async {
    _httpServer = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    _httpServer.listen(_handle);
  }

  Future<void> stop() => _httpServer.close(force: true);

  Future<void> _handle(HttpRequest httpRequest) async {
    final String rawBody = await utf8.decoder.bind(httpRequest).join();
    final ReceivedRequest receivedRequest = ReceivedRequest(
      httpRequest.method,
      httpRequest.uri.path,
      httpRequest.headers.value(HttpHeaders.authorizationHeader),
      rawBody.isEmpty ? null : jsonDecode(rawBody),
    );
    receivedRequests.add(receivedRequest);

    final ServerReply reply = replyTo(receivedRequest);
    final HttpResponse httpResponse = httpRequest.response..statusCode = reply.statusCode;
    if (reply.reasonPhrase != null) httpResponse.reasonPhrase = reply.reasonPhrase!;
    httpResponse.headers.contentType = ContentType.parse(reply.contentType);
    httpResponse.write(reply.body is String ? reply.body : jsonEncode(reply.body));
    await httpResponse.close();
  }
}

class InMemoryTokenStorage implements TokenStorage {
  JwtToken? storedToken;

  @override
  Future<JwtToken?> loadToken() async => storedToken;

  @override
  Future<void> saveToken(JwtToken token) async => storedToken = token;

  @override
  Future<void> clear() async => storedToken = null;

  @override
  Future<String?> get accessToken async => storedToken?.accessToken;

  @override
  Future<String?> get refreshToken async => storedToken?.refreshToken;
}

class User {
  User(this.name);

  final String name;
}

User userFromJson(Map<String, dynamic> json) => User(json['name'] as String);

List<User> usersFromJson(List<dynamic> jsonList) =>
    jsonList.map((userJson) => userFromJson(userJson as Map<String, dynamic>)).toList();

String signedAccessToken(String version) => JWT({
      'version': version,
      'exp': DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    }).sign(SecretKey('test-secret'));

void main() {
  final TestServer testServer = TestServer();
  final APIService apiService = APIService();

  setUpAll(() async {
    await testServer.start();
    SharedPreferences.setMockInitialValues({});
    await PreferenceHelper.init(encryptionKey: '0123456789abcdef0123456789abcdef');
    DioClient.setIsApiLogVisible(isVisible: false);
  });

  tearDownAll(testServer.stop);

  setUp(() async {
    testServer.receivedRequests.clear();
    testServer.replyTo = (request) => const ServerReply(200, body: {});
    dioClient.setConfiguration(testServer.baseUrl);
    await PreferenceHelper.setStringPrefValue(key: HttpHeaders.authorizationHeader, value: 'stored-token');
  });

  APIRequest requestTo(String path, {MethodType methodType = MethodType.GET, bool isAuthorization = false}) =>
      APIRequest(url: path, methodType: methodType, isAuthorization: isAuthorization);

  group('public API is exported from the barrel', () {
    test('every public name still resolves', () {
      final List<Type> publicTypes = [
        APIService,
        APIRequest,
        MethodType,
        APIResponse,
        ApiException,
        APIConstError,
        ErrorHandler,
        DioClient,
        JwtHeroInterceptor,
        JwtToken,
        SessionManager,
        SessionStatus,
        TokenStorage,
        RefreshTokenConfiguration,
      ];
      const JsonMapper<User>? jsonMapper = null;
      const ListJsonMapper<User>? listJsonMapper = null;
      const CustomErrorMapper<dynamic>? customErrorMapper = null;

      expect(publicTypes, hasLength(14));
      expect([jsonMapper, listJsonMapper, customErrorMapper], everyElement(isNull));
      expect(MethodType.values.map((methodType) => methodType.name), ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']);
    });
  });

  group('new names match old names', () {
    test('APIRequest: body, bodyList, headers, requiresAuth share storage with the old names', () {
      final APIRequest request = APIRequest(url: '/x', methodType: MethodType.post, params: {'a': 1}, header: {'h': '1'})
        ..paramList = [1]
        ..isAuthorization = false;

      expect(request.body, {'a': 1});
      expect(request.bodyList, [1]);
      expect(request.headers, {'h': '1'});
      expect(request.requiresAuth, isFalse);

      request
        ..body = {'b': 2}
        ..requiresAuth = true;
      expect(request.params, {'b': 2});
      expect(request.isAuthorization, isTrue);
    });

    test('requiresAuth defaults to true, like isAuthorization did', () {
      expect(APIRequest(url: '/x', methodType: MethodType.get).requiresAuth, isTrue);
    });

    test('POST with new names sends the same body as with old names', () async {
      await apiService.getResponseWithMapper<dynamic>(
          APIRequest(url: '/echo', methodType: MethodType.post, body: {'from': 'body'}, bodyList: ['from bodyList']));
      expect(testServer.receivedRequests.single.body, ['from bodyList']);
    });

    test('lowercase MethodType names are the same values', () {
      expect([MethodType.get, MethodType.post, MethodType.patch, MethodType.put, MethodType.delete], MethodType.values);
    });

    test('APIConstError old and new names share storage', () {
      final String originalMessage = APIConstError.connectionTimeout;
      addTearDown(() => APIConstError.connectionTimeout = originalMessage);

      APIConstError.kTimeOut = 'set via old name';
      expect(APIConstError.connectionTimeout, 'set via old name');
      APIConstError.connectionTimeout = 'set via new name';
      expect(APIConstError.kTimeOut, 'set via new name');
      expect(APIConstError.kInvalidStatusCode(statusCode: 418), APIConstError.invalidStatusCode(statusCode: 418));
    });

    test('renamed methods return the same result', () {
      final DioException cancelled = DioException.requestCancelled(requestOptions: RequestOptions(), reason: null);
      final List<ErrorDetails> errorDetails = [ErrorDetails(msg: 'a'), ErrorDetails(msg: 'a'), ErrorDetails(msg: 'b')];

      expect(ErrorHandler.instance.getDioError(cancelled), ErrorHandler.instance.messageFor(cancelled));
      expect(apiService.setErrorData(errorDetails), apiService.joinValidationMessages(errorDetails));
      expect(apiService.joinValidationMessages(errorDetails), 'a, b');
    });

    test('dioClient.dio is the same client getDioClient returns', () {
      expect(identical(dioClient.dio, dioClient.getDioClient()), isTrue);
    });
  });

  group('success mapping', () {
    test('jsonMapper maps an object', () async {
      testServer.replyTo = (request) => const ServerReply(200, body: {'name': 'Asha'});

      final result = await apiService.getResponseWithMapper<User>(requestTo('/user'), jsonMapper: userFromJson);

      expect(result.getOrElse(() => throw 'expected right').name, 'Asha');
    });

    test('listJsonMapper maps a list', () async {
      testServer.replyTo = (request) => const ServerReply(200, body: [
            {'name': 'Asha'},
            {'name': 'Ravi'},
          ]);

      final result =
          await apiService.getResponseWithMapper<List<User>>(requestTo('/users'), listJsonMapper: usersFromJson);

      expect(result.getOrElse(() => throw 'expected right').map((user) => user.name), ['Asha', 'Ravi']);
    });

    test('no mapper returns the raw body', () async {
      testServer.replyTo = (request) => const ServerReply(200, body: {'id': 1});

      final result = await apiService.getResponseWithMapper<dynamic>(requestTo('/raw'));

      expect(result.getOrElse(() => throw 'expected right'), {'id': 1});
    });

    test('a body that does not match T becomes left(kSomethingWentWrong)', () async {
      testServer.replyTo = (request) => const ServerReply(200, body: {'id': 1});

      final result = await apiService.getResponseWithMapper<String>(requestTo('/raw'));

      expect(result.fold((apiException) => apiException.message, (_) => 'right'), APIConstError.kSomethingWentWrong);
    });
  });

  group('request body per method', () {
    Future<dynamic> bodySentFor(MethodType methodType) async {
      final APIRequest request = requestTo('/echo', methodType: methodType)
        ..params = {'from': 'params'}
        ..paramList = ['from paramList'];
      await apiService.getResponseWithMapper<dynamic>(request);
      return testServer.receivedRequests.single.body;
    }

    test('GET sends no body', () async => expect(await bodySentFor(MethodType.GET), isNull));
    test('POST prefers paramList', () async => expect(await bodySentFor(MethodType.POST), ['from paramList']));
    test('PUT sends params', () async => expect(await bodySentFor(MethodType.PUT), {'from': 'params'}));
    test('PATCH sends params', () async => expect(await bodySentFor(MethodType.PATCH), {'from': 'params'}));
    test('DELETE prefers params', () async => expect(await bodySentFor(MethodType.DELETE), {'from': 'params'}));

    test('HTTP method matches MethodType', () async {
      for (final MethodType methodType in MethodType.values) {
        await apiService.getResponseWithMapper<dynamic>(requestTo('/echo', methodType: methodType));
      }
      expect(testServer.receivedRequests.map((request) => request.method), ['GET', 'POST', 'PATCH', 'PUT', 'DELETE']);
    });
  });

  group('error messages', () {
    Future<ApiException> errorFor(ServerReply reply) async {
      testServer.replyTo = (request) => reply;
      final result = await apiService.getResponseWithMapper<dynamic>(requestTo('/fail'));
      return result.fold((apiException) => apiException, (_) => throw 'expected left');
    }

    test('422 with FastAPI detail joins unique messages', () async {
      final ApiException apiException = await errorFor(const ServerReply(422, body: {
        'detail': [
          {'loc': ['body', 'email'], 'msg': 'Email is invalid', 'type': 'value_error'},
          {'loc': ['body', 'email'], 'msg': 'Email is invalid', 'type': 'value_error'},
          {'loc': ['body', 'name'], 'msg': 'Name is required', 'type': 'missing'},
        ],
      }));

      expect(apiException.message, 'Email is invalid, Name is required');
      expect(apiException.statusCode, 422);
    });

    test('422 with empty detail falls back to message', () async {
      final ApiException apiException = await errorFor(const ServerReply(422, body: {'detail': [], 'message': 'Bad'}));
      expect(apiException.message, 'Bad');
    });

    test('400 uses body.message', () async {
      expect((await errorFor(const ServerReply(400, body: {'message': 'Bad input'}))).message, 'Bad input');
    });

    test('400 uses body.error when message is missing', () async {
      expect((await errorFor(const ServerReply(400, body: {'error': 'Nope'}))).message, 'Nope');
    });

    test('400 with a non-String message falls back to statusMessage', () async {
      final ApiException apiException =
          await errorFor(const ServerReply(400, body: {'message': 123}, reasonPhrase: 'Bad Request'));
      expect(apiException.message, 'Bad Request');
    });

    test('400 with a plain-text body uses statusMessage', () async {
      final ApiException apiException = await errorFor(
          const ServerReply(400, body: 'oops', reasonPhrase: 'Bad Request', contentType: 'text/plain'));
      expect(apiException.message, 'Bad Request');
    });

    test('500 uses statusMessage, not the body', () async {
      final ApiException apiException =
          await errorFor(const ServerReply(500, body: {'message': 'hidden'}, reasonPhrase: 'Server Broke'));
      expect(apiException.message, 'Server Broke');
      expect(apiException.statusCode, 500);
    });

    test('connection failure uses kNoInternetConnection2', () async {
      dioClient.setConfiguration('http://127.0.0.1:1');
      final result = await apiService.getResponseWithMapper<dynamic>(requestTo('/fail'));
      expect(result.fold((apiException) => apiException.message, (_) => 'right'), APIConstError.kNoInternetConnection2);
    });

    test('cancelled request uses kCancelled', () async {
      final CancelToken cancelToken = CancelToken()..cancel();
      final result =
          await apiService.getResponseWithMapper<dynamic>(requestTo('/fail')..cancelToken = cancelToken);
      expect(result.fold((apiException) => apiException.message, (_) => 'right'), APIConstError.kCancelled);
    });

    test('apps can reassign APIConstError messages', () async {
      final String originalMessage = APIConstError.kCancelled;
      addTearDown(() => APIConstError.kCancelled = originalMessage);
      APIConstError.kCancelled = 'Cancelled (custom)';

      final result =
          await apiService.getResponseWithMapper<dynamic>(requestTo('/fail')..cancelToken = (CancelToken()..cancel()));

      expect(result.fold((apiException) => apiException.message, (_) => 'right'), 'Cancelled (custom)');
    });

    test('customErrorMapper set after setConfiguration is used', () async {
      dioClient.customErrorMapper =
          (response) => APIResponse<dynamic>(hasError: true, message: 'mapped ${response.statusCode}');

      expect((await errorFor(const ServerReply(418, body: {'message': 'ignored'}))).message, 'mapped 418');
    });

    test('setErrorData joins unique messages', () {
      expect(apiService.setErrorData(null), '');
    });

    test(
      'D3: unexpected 422 body returns left instead of throwing',
      () async {
        final ApiException apiException =
            await errorFor(const ServerReply(422, body: 'not json', reasonPhrase: 'Unprocessable', contentType: 'text/plain'));
        expect(apiException.message, 'Unprocessable');
      },
      skip: 'Known bug D3, fixed in its own commit',
    );
  });

  group('error callbacks', () {
    test('per-request onError is called', () async {
      testServer.replyTo = (request) => const ServerReply(400, body: {});
      final List<int?> callbackStatusCodes = [];

      await apiService.getResponseWithMapper<dynamic>(requestTo('/fail')
        ..onError = (dioException, handler) {
          callbackStatusCodes.add(dioException.response?.statusCode);
          handler.next(dioException);
        });

      expect(callbackStatusCodes, [400]);
    });

    test('globalOnErrorHandler set after setConfiguration is called', () async {
      testServer.replyTo = (request) => const ServerReply(400, body: {});
      final List<int?> globalStatusCodes = [];
      dioClient.globalOnErrorHandler = (dioException, handler) {
        globalStatusCodes.add(dioException.response?.statusCode);
        handler.next(dioException);
      };

      await apiService.getResponseWithMapper<dynamic>(requestTo('/fail'));

      expect(globalStatusCodes, [400]);
    });
  });

  group('authorization (no refresh token configuration)', () {
    test('isAuthorization sends the stored token', () async {
      await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));
      expect(testServer.receivedRequests.single.authorizationHeader, 'Bearer stored-token');
    });

    test('isAuthorization: false sends no Authorization header', () async {
      await apiService.getResponseWithMapper<dynamic>(requestTo('/public'));
      expect(testServer.receivedRequests.single.authorizationHeader, isNull);
    });

    test('getDioClient(isAuth: false) sends no Authorization header', () async {
      await dioClient.getDioClient(isAuth: false).get<dynamic>('/public');
      expect(testServer.receivedRequests.single.authorizationHeader, isNull);
    });

    test('getDioClient() sends the stored token', () async {
      await dioClient.getDioClient().get<dynamic>('/secure');
      expect(testServer.receivedRequests.single.authorizationHeader, 'Bearer stored-token');
    });

    test(
      'D6: no Authorization header when no token is stored',
      () async {
        await PreferenceHelper.setStringPrefValue(key: HttpHeaders.authorizationHeader, value: '');
        await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));
        expect(testServer.receivedRequests.single.authorizationHeader, isNull);
      },
      skip: 'Known bug D6, fixed in its own commit',
    );
  });

  // Keep this group LAST: there is no public way to clear a refresh token configuration from the global dioClient.
  group('JWT refresh', () {
    final InMemoryTokenStorage tokenStorage = InMemoryTokenStorage();
    final String oldAccessToken = signedAccessToken('old');
    final String newAccessToken = signedAccessToken('new');

    setUp(() {
      tokenStorage.storedToken = JwtToken(accessToken: oldAccessToken, refreshToken: 'refresh-1');
      dioClient.setRefreshTokenConfiguration(
        refreshTokenConfiguration: RefreshTokenConfiguration(
          refreshTokenEndPoint: '/refresh',
          sessionManager: SessionManager(),
          tokenStorage: tokenStorage,
          responseMapper: (responseBody) =>
              JwtToken(accessToken: responseBody['access'] as String, refreshToken: responseBody['refresh'] as String),
        ),
      );
      testServer.replyTo = (request) {
        if (request.path == '/refresh') {
          return ServerReply(200, body: {'access': newAccessToken, 'refresh': 'refresh-2'});
        }
        final bool hasNewToken = request.authorizationHeader == 'Bearer $newAccessToken';
        return hasNewToken ? const ServerReply(200, body: {'ok': true}) : const ServerReply(401, body: {});
      };
    });

    test('401 refreshes once, saves the new token, and retries with it', () async {
      await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));

      expect(testServer.countRequestsTo('/refresh'), 1);
      expect(tokenStorage.storedToken?.refreshToken, 'refresh-2');
      expect(
        testServer.receivedRequests.where((request) => request.path == '/secure').map((request) => request.authorizationHeader),
        ['Bearer $oldAccessToken', 'Bearer $newAccessToken'],
      );
    });

    test('today: the retried response is lost and the caller gets left(kSomethingWentWrong)', () async {
      final result = await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));

      expect(result.fold((apiException) => apiException.message, (_) => 'right'), APIConstError.kSomethingWentWrong);
    });

    test(
      'D9: the retried response reaches the caller',
      () async {
        final result = await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));
        expect(result.getOrElse(() => throw 'expected right'), {'ok': true});
      },
      skip: 'Known bug D9, fixed in its own commit',
    );

    test('refresh call sends the refresh token as Bearer', () async {
      await apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true));

      final ReceivedRequest refreshRequest =
          testServer.receivedRequests.firstWhere((request) => request.path == '/refresh');
      expect(refreshRequest.authorizationHeader, 'Bearer refresh-1');
    });

    test('isAuthorization: false skips the JWT token', () async {
      testServer.replyTo = (request) => const ServerReply(200, body: {});
      await apiService.getResponseWithMapper<dynamic>(requestTo('/public'));
      expect(testServer.receivedRequests.single.authorizationHeader, isNull);
    });

    test(
      'D1: two parallel 401s trigger one refresh',
      () async {
        await Future.wait([
          apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true)),
          apiService.getResponseWithMapper<dynamic>(requestTo('/secure', isAuthorization: true)),
        ]);
        expect(testServer.countRequestsTo('/refresh'), 1);
      },
      skip: 'Known bug D1, fixed in its own commit',
    );
  });
}
