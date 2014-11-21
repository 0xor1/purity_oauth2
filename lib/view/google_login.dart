/**
 * Author:  Daniel Robinson http://github.com/0xor1
 */

library purity.oauth2.view;

import 'dart:html';
import 'package:purity/purity.dart' as p;
import 'package:polymer/polymer.dart';
import 'package:paper_elements/paper_button.dart';
import 'package:purity_oauth2/interface/oauth2.dart';

@CustomTag('google-login-element')
class GoogleLoginElement extends PolymerElement with p.Receiver{

  GoogleLoginConsumer consumer;
  WindowBase _loginWindow;
  PaperButton _btn;
  bool _loginInProgress = false;
  bool _loggedIn = false;

  GoogleLoginElement.created() : super.created();

  @override
  void attached() {
    super.attached();
    _btn = $['google-login'];
    this.onClick.listen((_){
      if(!_loginInProgress && !_loggedIn){
        _loginInProgress = true;
        _btn.label = 'signing in ...';
        consumer.source.login();
      }
    });
  }

  @override
  void detached() {
    super.detached();
  }

  void _initSourceBinding(){
    listen(consumer.source, OAuth2LoginUrlRedirection, _handleRedirect);
    listen(consumer.source, OAuth2LoginTimeOut, _handleLoginFlowClosed);
    listen(consumer.source, OAuth2LoginAccessDenied, _handleLoginFlowClosed);
    listen(consumer.source, OAuth2LoginUnkownError, _handleLoginFlowClosed);
    listen(consumer.source, OAuth2LoginAccessGranted, _handleLoginFlowClosed);
  }

  void _handleRedirect(p.Event<OAuth2LoginUrlRedirection> e){
    _loginWindow = window.open(e.data.url, 'Google Login');
  }

  void _handleLoginFlowClosed(p.Event e){
    _loginInProgress = false;
    if(e.data is OAuth2LoginAccessGranted){
      _loggedIn = true;
      _btn.label = 'Sign in Success';
      _btn.disabled = true;
    }else{
      _btn.label = 'Sign in with Google';
    }
    if(_loginWindow != null) _loginWindow.close();
    _loginWindow = null;
  }
}

class GoogleLoginConsumer extends p.Consumer{
  final GoogleLoginElement view = new Element.tag('google-login-element');

  GoogleLoginConsumer(src) : super(src){
    registerPurityOAuth2TranTypes();
    view.consumer = this;
    view._initSourceBinding();
  }

  void dispose(){
    view.remove();
    super.dispose();
  }
}
