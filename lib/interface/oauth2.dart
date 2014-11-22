/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.oauth2.interface;

@MirrorsUsed(
  targets: const[
    ILogin
  ], override: '*')
import 'dart:mirrors';
import 'package:purity/purity.dart';

final Registrar  registerPurityOAuth2TranTypes = generateRegistrar(
    'purity.oauth2.tran', 'pot', [
    new TranRegistration.subtype(OAuth2LoginUrlRedirection, () => new OAuth2LoginUrlRedirection()),
    new TranRegistration.subtype(OAuth2LoginAccessGranted, () => new OAuth2LoginAccessGranted()),
    new TranRegistration.subtype(OAuth2LoginInProgress, () => new OAuth2LoginInProgress()),
    new TranRegistration.subtype(OAuth2LoginNotComplete, () => new OAuth2LoginNotComplete()),
    new TranRegistration.subtype(OAuth2LoginTimeOut, () => new OAuth2LoginTimeOut()),
    new TranRegistration.subtype(OAuth2LoginAccessDenied, () => new OAuth2LoginAccessDenied()),
    new TranRegistration.subtype(OAuth2LoginUnkownError, () => new OAuth2LoginUnkownError()),
    new TranRegistration.subtype(OAuth2LoginClientClosed, () => new OAuth2LoginClientClosed()),
    new TranRegistration.subtype(OAuth2LoginUserDetails, () => new OAuth2LoginUserDetails()),
    new TranRegistration.subtype(Oauth2ResourceResponse, () => new Oauth2ResourceResponse())
  ]);

abstract class ILogin implements Source{
  /// start the oauth2 login process.
  void login();
  /// set the time in seconds from when the login process starts to the point when it times out.
  void setLoginTimeout(int seconds);
  /// request a resource, this will fail if the login has not already successfully completed.
  void requestResource(String resource, {Map<String, String> headers});
  /// request the logged in users details.
  void requestUserDetails();
  /// closes the client connection
  void close();
}

class OAuth2LoginUrlRedirection extends Transmittable{
  String get url => get('url');
  void set url (String o)=> set('url', o);
}

class OAuth2LoginAccessGranted extends Transmittable{}

class OAuth2LoginInProgress extends Transmittable{}

class OAuth2LoginNotComplete extends Transmittable{}

class OAuth2LoginTimeOut extends Transmittable{}

class OAuth2LoginAccessDenied extends Transmittable{}

class OAuth2LoginUnkownError extends Transmittable{}

class OAuth2LoginClientClosed extends Transmittable{}

class OAuth2LoginUserDetails extends Transmittable{
  String get firstName => get('firstName');
  void set firstName (String o) => set('firstName', o);
  String get lastName => get('lastName');
  void set lastName (String o) => set('lastName', o);
  String get id => get('id');
  void set id (String o) => set('id', o);
  String get email => get('email');
  void set email (String o) => set('email', o);
  String get displayName => get('displayName');
  void set displayName (String o) => set('displayName', o);
  String get imageUrl => get('imageUrl');
  void set imageUrl (String o) => set('imageUrl', o);
}

class Oauth2ResourceResponse extends Transmittable{
  String get response => get('response');
  void set response (String o) => set('response', o);
}