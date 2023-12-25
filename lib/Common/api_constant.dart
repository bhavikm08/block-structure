class ApiConstant {
  // static const baseUrl = 'http://103.27.32.10/~whphstaging/wp-json/';
  static const loginApi = 'http://103.27.32.10/~whphstaging/wp-json/jwt-auth/v1/token';
  static const postsApi = 'https://dummyjson.com/posts';


}
class Constants {
  static const defaultToken =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjo2LCJpYXQiOjE2Nzk4OTkwNzUsImV4cCI6MTY3OTk4NTQ3NX0.ccPzSNL7bzbDU9MoN-MF656mpyRdvXDilzPeJrfgBek';

  /// used after login response ///

  static const authToken = '';

  /// generate using fireBase ///

  static const deviceToken = "";
  static String isLogin = 'is_login';

  /// used when code 401 is generate exchange expired token with new ///

  static const refreshToken = '';
  static const language = 'en';
  static const deviceId = '1234';
  static const name = 'name';
}

