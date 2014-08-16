/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.oauth2.mock.source;

class MockLogin extends Source implements ILogin{

  static int _userIdSrc = 0;
  final int _userId = _userIdSrc++;

  void login() {
    emitEvent(new OAuth2LoginAccessGranted());
  }

  void requestResource(String resource, {Map<String, String> headers}) {
    // does nothing in the base mock login clas
  }

  void setLoginTimeout(int seconds) {
    // does nothing in the mock class
  }

  void requestUserDetails(){
    emitEvent(
      new OAuth2LoginUserDetails()
      ..firstName = 'Test$_userId'
      ..lastName = 'User$_userId'
      ..email = 'Test$_userId.User$_userId@mocklogin.com'
      ..imageUrl = 'http://upload.wikimedia.org/wikipedia/commons/d/d3/User_Circle.png'
      ..id = '$_userId'
      ..displayName = 'Test$_userId User$_userId');
  }
}