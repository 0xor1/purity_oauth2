/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.oauth2.test.web;

import 'dart:html';
import 'package:purity/client.dart';
import 'package:purity_oauth2/view/oauth2.dart';

void main(){
  initConsumerSettings(
    (googleLogin, proxyEndPoint){
      var view = new GoogleLoginView(
        googleLogin,
        'Welcome to the Google Login sandbox app, enter g-login to start the login flow');
      document.body.children.add(view.html);
    },
    (){
      // no clean up
    },
    'ws');
}