/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.oauth2.test.host;

import 'dart:io';
import 'package:purity/host.dart';
import 'package:purity_oauth2/model/oauth2.dart';
import 'package:purity_oauth2/interface/oauth2.dart';

void main(){
  new Host(
    InternetAddress.ANY_IP_V4,
    4346,
    Platform.script.resolve('../web').toFilePath(),
    (_) => new GoogleLogin(
        'http://localhost:4346/oauth2redirect',
        '1084058127345-j5m0ra24902vhuggtf7h9pj27itnr8cl.apps.googleusercontent.com',
        'yX9U5oCY3G4UE9rQQ_1gDC_B',
        ['https://www.googleapis.com/auth/userinfo.profile',
          'https://www.googleapis.com/auth/userinfo.email']),
    (ILogin login) => login.close(),
    0)
  ..start()
  .then((router){
    Login.setupOAuth2RedirectRouteListener(router, '/oauth2redirect');
  });;
}