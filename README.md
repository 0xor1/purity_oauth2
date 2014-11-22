#Purity OAuth2

A simple oauth2 library for the purity framework.

##Trying the login flow

To view the login flow in action you can run the demo/tests in 3 ways:

  * To see the real login flow with the host making requests to google services run `pub build` then run `build/bin/host.dart`
  then navigate to `localhost:4346`.
  
  * To see the login flow being mocked with the purity framework, run [`test/integration/index_with_purity.html`](http://0xor1.github.io/purity_oauth2/)
  enter `showComs` to view the communications window, then enter `newClient`.
  
  * To see the login flow being mocked without the purity framework, run [`test/integration/index_without_purity.html`](http://0xor1.github.io/purity_oauth2/without_purity/).