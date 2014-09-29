#Purity OAuth2

A simple oauth2 library for the purity framework.

##Trying the login flow

To view the login flow in action you can run the integration tests in 3 ways, all require you run `pub build` first,
in addition there is currently a bug in the [`pub build`](https://code.google.com/p/dart/issues/detail?id=21127) where
the packages directory is not copied to the appropriate locations, so until this bug is fixed there is the requirement
to copy the `packages` directory from `build/test` into `all_on_client`, `bin`, `web` directories in `build/test/integration`, then:

  * To see the real login flow with the host making requests to google services run `build/test/integration/bin/host.dart`
  then navigate to `localhost:4346` and follow the on screen instructions, mainly to use the commands `g-login` then `requestUserDetails`.
  
  * To see the login flow being mocked with the purity framework, run [`index_with_purity.html`](http://0xor1.github.io/purity_oauth2/)
  enter `showComs` to view the communications window, then enter `newClient`, then in the new client window enter `g-login` then enter `requestUserDetails`.
  
  * To see the login flow being mocked without the purity framework, run [`index_without_purity.html`](http://0xor1.github.io/purity_oauth2/without_purity/),
   and enter `g-login` then enter `requestUserDetails`.