# Singulus

Singulus is the monolith that powers [tonyburns.net](https://tonyburns.net) and facilitates dynamic needs for me on the [IndieWeb](https://indieweb.org/).

This application is built first and foremost for me to [eat what I cook](https://indieweb.org/eat_what_you_cook) for my own content, but by making it open source from the beginning my hope is that it will keep me accountable and perhaps be useful to others.

## Features

- Authentication via [Devise](https://github.com/heartcombo/devise)
- OAuth 2.0 provider via [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)

## Roadmap

- [ ] Publish articles, notes, and photos via simple CRUD interface
- [ ] [IndieAuth](https://indieauth.net/) provider
- [ ] [Micropub](https://micropub.rocks/) server
- [ ] Send and receive [Webmentions](https://webmention.rocks/)
- [ ] [Publish (on your) Own Site, Syndicate Elsewhere (POSSE)](https://indieweb.org/POSSE) for content on [tonyburns.net](https://tonyburns.net)
- [ ] [Webauthn](https://webauthn.io/) support for using Yubikeys as 2FA

## Diagram

![Data Movement](/docs/assets/data_movement_diagram.png?raw=true "Data Movement")

## License

Singulus is licensed under the [MIT License](https://opensource.org/licenses/MIT).
