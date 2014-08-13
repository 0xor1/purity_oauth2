/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

part of purity.oauth2.source;

class GoogleLogin extends Login{
  static Uri _AUTH_URL = new Uri.https('accounts.google.com', '/o/oauth2/auth');
  static Uri _TOKEN_URL = new Uri.https('accounts.google.com', '/o/oauth2/token');

  GoogleLogin(
    String redirectUrl,
    String clientId,
    String secret,
    List<String> scopes)
  :super(
    _AUTH_URL,
    _TOKEN_URL,
    Uri.parse(redirectUrl),
    clientId,
    secret,
    scopes){
    listen(this, Oauth2ResourceResponse,(Event<Oauth2ResourceResponse> event){
      var data = JSON.decode(event.data.response);
      emitEvent(
        new OAuth2LoginUserDetails()
        ..firstName = data['given_name']
        ..lastName = data['family_name']
        ..id = data['id']
        ..email = data['email']
        ..displayName = data['name']
        ..imageUrl = data['picture']);
    });
    listen(this, OAuth2LoginAccessGranted,(Event<OAuth2LoginAccessGranted> event){
      requestResource('https://www.googleapis.com/userinfo/v2/me');
    });
  }
}