/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.oauth2.mock.model;

class MockLogin extends Source implements ILogin{

  static int _userIdSrc = 0;
  final int testUserId = _userIdSrc++;
  final Map<String, GetResource> _resourceMap;
  bool _loggedIn = false;
  bool _clientClosed = false;
  bool get _clientIsAlive => _loggedIn == true && _clientClosed == false;

  MockLogin([Map<String, GetResource> this._resourceMap])
  :super(){
    registerPurityOAuth2TranTypes();
  }

  void login() {
    if(!_loggedIn){
      _loggedIn = true;
      emit(new OAuth2LoginAccessGranted());
    }
  }

  void requestResource(String resource, {Map<String, String> headers}) {
    if(_clientIsAlive && _resourceMap != null && _resourceMap.containsKey(resource)){
      var response = _resourceMap[resource]();
      emit(new Oauth2ResourceResponse()..response = response);
    }
  }

  void setLoginTimeout(int seconds) {
    // does nothing in the mock class
  }

  void close(){
    if(_clientIsAlive){
      emit(new OAuth2LoginClientClosed());
    }
  }

  void requestUserDetails(){
    var firstName = 'Test$testUserId';
    var lastName = 'User$testUserId';
    if(_clientIsAlive){
      emit(
        new OAuth2LoginUserDetails()
        ..firstName = firstName
        ..lastName = lastName
        ..email = '$firstName.$lastName@mocklogin.com'
        ..imageUrl = 'http://upload.wikimedia.org/wikipedia/commons/d/d3/User_Circle.png'
        ..id = '$testUserId'
        ..displayName = '$firstName $lastName');
    }
  }
}