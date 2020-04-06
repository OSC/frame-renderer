# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [Unreleased]
## [0.2.2] - 2020-04-06
### Fixed
- Endframe was not being cacluated correctly when the start frame was non-zero. So end
  endframe is now `offset + start frame [+ remainder if last task]` 
  ([#40](https://github.com/OSC/frame-renderer/pull/40)).
- +1 offset was incorrect and only needs to be applied to start frame if the pbs
  id is > 1.

## [0.2.1] - 2020-04-03
### Fixed
- wall_time was not being submitted.
- new projects need to validate the name exists [#37](https://github.com/OSC/frame-renderer/issues/37)
- generating and showing thumbnails expected file extension to be .exr only.

## [0.2.0] - 2019-10-18
### Added
- added SFTP links to support [#3](https://github.com/OSC/frame-renderer/issues/3)

## [0.1.1] - 2019-09-26
### Fixed
- ensure app doesn't crash if there is no `~/maya/projects` directory [#30](https://github.com/OSC/frame-renderer/issues/30)

[Unreleased]: https://github.com/OSC/frame-renderer/compare/0.2.2...HEAD
[0.2.2]: https://github.com/OSC/frame-renderer/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/OSC/frame-renderer/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/OSC/frame-renderer/compare/0.1.1...0.2.0
[0.1.1]: https://github.com/OSC/frame-renderer/compare/0.1.0...0.1.1
