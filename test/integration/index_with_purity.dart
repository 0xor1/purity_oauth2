/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

import 'dart:html';
import 'dart:async';
import 'package:purity/local.dart';
import 'package:purity/client.dart' as c;
import 'package:purity/purity.dart' as p;
import 'package:purity_oauth2/mock_model/oauth2.dart';
import 'package:purity_oauth2/view/google_login.dart';
import 'package:purity_oauth2/interface/oauth2.dart';
import 'package:polymer/polymer.dart';

void main(){

  initPolymer();
  var host = new Host(
    (_) => new Future.delayed(new Duration(), () => new MockLogin()),
    (ILogin login) => new Future.delayed(new Duration(), (){ login.close(); }),
    0);

  var hostView = new c.LocalHostView(host);

  initConsumerSettings(
    (mockGoogleLogin, proxyEndPoint){
      var view = new GoogleLoginConsumer(mockGoogleLogin);

      /**
       * the following is just for demonstration purposes
       */
      DivElement wrapperView = new DivElement();
       void logInfo(String info){
         var infoEl = new DivElement()
         ..appendText(info);
         wrapperView.append(infoEl);
       }
      wrapperView.style
      ..overflow = 'auto';
      wrapperView.append(view.view);
      document.body.children.add(wrapperView);

      var wrapperConsumer = new p.Consumer(mockGoogleLogin);
      wrapperConsumer.listen(view.source, OAuth2LoginUrlRedirection, (_) => logInfo('login-redirection'));
      wrapperConsumer.listen(view.source, OAuth2LoginTimeOut, (_) => logInfo('login-timed-out'));
      wrapperConsumer.listen(view.source, OAuth2LoginAccessDenied, (_) => logInfo('access-denied'));
      wrapperConsumer.listen(view.source, OAuth2LoginUnkownError, (_) => logInfo('unkown-error'));
      wrapperConsumer.listen(view.source, OAuth2LoginAccessGranted, (_){
        logInfo('ACCESS_GRANTED!!');
        view.source.requestUserDetails();
      });
      wrapperConsumer.listen(view.source, OAuth2LoginUserDetails, (p.Event<OAuth2LoginUserDetails> e){
        var img = new ImageElement();
        img.src = e.data.imageUrl;
        img.height = 50;
        img.width = 50;
        wrapperView.append(img);
        logInfo('first_name: ${e.data.firstName}');
        logInfo('last_name: ${e.data.lastName}');
        logInfo('google_id: ${e.data.id}');
        logInfo('email: ${e.data.email}');
        logInfo('display_name: ${e.data.displayName}');
      });
      hostView.addNewClientView(proxyEndPoint, wrapperView, 300);
    },
    (){});

  document.body.append(hostView.html);
}