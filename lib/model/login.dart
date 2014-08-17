/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.oauth2.source;

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
  }

  void login(){
    _activeLogins[_loginId] = this;

    new Future.delayed(new Duration(seconds: _timeout),(){
      var login = _activeLogins.remove(_loginId);
      if(login != null){
        login.emitEvent(new OAuth2LoginTimeOut());
      }
    });

    var authRedirectUrl = new Uri.https(_authUrl.host, _authUrl.path, {
      'redirect_uri' : _redirectUrl.toString(),
      'response_type' : 'code',
      'client_id' : _clientId,
      'scope' : _scopes.join(_scopeDelimiter),
      'approval_prompt' : 'auto',
      'access_type' : 'offline',
      'state' : _loginId.toHexString()
    });

    // this needs to be called or an exception is thrown when making calls to progress
    // the oauth2 process further down the line, it would be nice to use this url
    // instead of the one created above but this can't be used at the moment as it
    // doesn't allow the user to specify a scopeDelimiter character which is required
    // for facebook as they use a non standard comma instead of space.
    _grant.getAuthorizationUrl(_redirectUrl, scopes: _scopes, state: _loginId.toHexString());

    emitEvent(new OAuth2LoginUrlRedirection()..url = authRedirectUrl.toString());
  }

  void requestResource(String resource, {Map<String, String> headers}){
    if(_client == null){
      throw new Exception('The login process has not yet completed.');
    }else{
      _client.read(resource, headers: headers)
      .then((String response){
        emitEvent(new Oauth2ResourceResponse()..response = response);
      });
    }
  }

  void setLoginTimeout(int seconds){ _timeout = seconds; }

  void close() => _client.close();

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
        login.emitEvent(new OAuth2LoginAccessGranted());
      })
      .catchError((error){
        login.emitEvent(new OAuth2LoginUnkownError());
      });
    }

    authReq.response.close();
  }
}