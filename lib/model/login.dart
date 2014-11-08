/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.oauth2.model;

abstract class Login extends Source implements ILogin{

  static final Map<ObjectId, Login> _activeLogins = new Map<ObjectId, Login>();
  static bool _firstTimeSetupComplete = false;
  static int _timeout = 30;

  final Uri _authUrl;
  final Uri _tokenUrl;
  final Uri _redirectUrl;
  final String _clientId;
  final String _secret;
  final String _scopeDelimiter;
  final List<String> _scopes;
  final ObjectId _loginId = new ObjectId();
  oauth2.AuthorizationCodeGrant _grant;
  oauth2.Client _client;
  Uri _clientAuthRedirect;

  Login(
      this._authUrl,
      this._tokenUrl,
      this._redirectUrl,
      this._clientId,
      this._secret,
      this._scopes,
      [this._scopeDelimiter = ' ']){
    registerPurityOAuth2TranTypes();
    _grant = new oauth2.AuthorizationCodeGrant(_clientId, _secret, _authUrl, _tokenUrl);
    _clientAuthRedirect = _grant.getAuthorizationUrl(_redirectUrl, scopes: _scopes, state: _loginId.toHexString());
  }

  void login(){

    if(_activeLogins.containsKey(_loginId)){
      emit(new OAuth2LoginInProgress());
      return;
    }

    _activeLogins[_loginId] = this;

    new Future.delayed(new Duration(seconds: _timeout),(){
      var login = _activeLogins.remove(_loginId);
      if(login != null){
        login.emit(new OAuth2LoginTimeOut());
      }
    });

    emit(new OAuth2LoginUrlRedirection()..url = _clientAuthRedirect.toString());
  }

  void requestResource(String resource, {Map<String, String> headers}){
    if(_client == null){
      emit(new OAuth2LoginNotComplete());
    }else{
      _client.read(resource, headers: headers)
      .then((String response){
        emit(new Oauth2ResourceResponse()..response = response);
      });
    }
  }

  void setLoginTimeout(int seconds){ _timeout = seconds; }

  void close(){
    if(_client != null){
      _client.close();
      emit(new OAuth2LoginClientClosed());
    }
  }

  static void setupOAuth2RedirectRouteListener(Router router, String redirectPath){
    if(_firstTimeSetupComplete == false){
      router.serve(redirectPath).listen((request){
        _handleOauth2Redirect(request);
      });
      _firstTimeSetupComplete = true;
    }else{
      throw new Exception('Login.setupOAuth2RedirectRouteListener may only be called once.');
    }
  }

  static void _handleOauth2Redirect(HttpRequest authReq) {

    var loginIdHexString = authReq.uri.queryParameters['state'];

    if(loginIdHexString == null){
      return;
    }

    var loginId = new ObjectId.fromHexString(loginIdHexString);
    var login = _activeLogins.remove(loginId);

    if(login != null){
      login._grant.handleAuthorizationResponse(authReq.uri.queryParameters)
      .then((oauth2.Client client){
        login._client = client;
        login.emit(new OAuth2LoginAccessGranted());
      })
      .catchError((error){
        login.emit(new OAuth2LoginUnkownError());
      });
    }

    authReq.response.close();
  }
}