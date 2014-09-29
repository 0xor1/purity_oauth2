/**
 * author: Daniel Robinson  http://github.com/0xor1
 */

library StopwatchLocalTest;

import 'dart:html';
import 'package:purity_oauth2/mock_model/purity_oauth2_mock_model.dart';
import '../view/purity_oauth2_test_view.dart';

void main(){
  var model = new MockLogin();
  var view = new GoogleLoginView(
    model,
    'Welcome to the Mock Google Login app, enter g-login to start the login flow');
  document.body.children.add(view.html);
}