/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library StopwatchLocalTest;

import 'dart:html';
import 'dart:async';
import 'package:purity/local.dart';
import 'package:purity/client.dart' as client;
import 'package:purity_oauth2/mock_model/purity_oauth2_mock_model.dart';
import '../view/purity_oauth2_test_view.dart';
import 'package:purity_oauth2/interface/purity_oauth2_interface.dart';

void main(){

  var host = new Host(
    (_) => new Future.delayed(new Duration(), () => new MockLogin()),
    (ILogin login) => new Future.delayed(new Duration(), (){ login.close(); }),
    0);

  var hostView = new client.LocalHostView(host);

  initConsumerSettings(
    (mockGoogleLogin, proxyEndPoint){
      var view = new GoogleLoginView(
        mockGoogleLogin,
        'Welcome to the Mock Google Login app, enter g-login to start the login flow');
      hostView.addNewClientView(proxyEndPoint, view.html, 300);
    },
    (){});

  document.body.append(hostView.html);
}