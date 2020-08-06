# Singulus

[![GitHub Workflow Status](https://img.shields.io/github/workflow/status/craftyphotons/singulus/Verify?style=for-the-badge)](https://github.com/craftyphotons/singulus/actions?query=workflow%3AVerify)
&nbsp;
[![Code Climate maintainability](https://img.shields.io/codeclimate/maintainability/craftyphotons/singulus?style=for-the-badge)](https://codeclimate.com/github/craftyphotons/singulus)

Singulus is the monolith that powers [tonyburns.net](https://tonyburns.net) and facilitates dynamic needs for me on the [IndieWeb](https://indieweb.org/).

## Contributing

I currently do not have plans for the necessary work and rearchitecture to make this application as a whole reusable by others. Expect there to be design decisions in the codebase with that in mind, particularly around the development environment for the application.

Singulus is built first and foremost for me to [eat what I cook](https://indieweb.org/eat_what_you_cook) for my own content, but by making it open source from the beginning my hope is that it will keep me accountable to build it well and perhaps be useful to others.

All of that said, if you're interested in using parts of Singulus for your own application, this entire codebase is licensed under the [MIT License](https://opensource.org/licenses/MIT). If there's something here that you think could be useful if it was extracted into its own library, please [create an extraction request](https://github.com/craftyphotons/singulus/issues/new?assignees=&labels=extraction&template=extraction_request.md&title=).

## Features

- [x] [IndieAuth](https://indieauth.net/) server built on top of [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)
- [x] Tracking-free [URL shortening service](https://en.wikipedia.org/wiki/URL_shortening) with automatic link management for other content created in Singulus
- [x] Create basic posts with categories and photos via [Micropub](https://micropub.rocks/)
- [x] Authentication via [Devise](https://github.com/heartcombo/devise)
- [x] OAuth 2.0 provider via [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper)

## License

Singulus is licensed under the [MIT License](https://opensource.org/licenses/MIT).
