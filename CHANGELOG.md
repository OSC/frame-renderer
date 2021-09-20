# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).


## [Unreleased]

## [1.0.0] - 2021-09-20

1.0.0 requires a database migration from 0.x versions, so it's increased a major version

### Added
* Support for V-Ray in [103](https://github.com/OSC/frame-renderer/pull/103).
  This work was done in a feature branch and holds many smaller merges than just this
  one PR.

## [0.8.0] - 2021-08-27

### Changed

- Update ACCAD module in [84](https://github.com/OSC/frame-renderer/pull/84).

### Added

- Test cases in [77](https://github.com/OSC/frame-renderer/pull/77).

## [0.7.0] - 2021-06-29

### Changed

- Updated the file picker to v1.0.0 to be Open OnDemand 2.0.x compatible
  in [74](https://github.com/OSC/frame-renderer/pull/74).

### Added

- Added some tests cases around project creation, updating and deleting in
  [71](https://github.com/OSC/frame-renderer/pull/71).

## [0.6.3] - 2021-03-26
### Fixed
- Fixed a bug where users were unable to create new projects due to nil
  params in [62](https://github.com/OSC/frame-renderer/pull/60)

### Changed
- bundler update for mememagic in [63](https://github.com/OSC/frame-renderer/pull/60)

## [0.6.2] - 2021-02-08
### Changed
- Generate SECRET_KEY_BASE through bash commands instead of rake because rake can fail
  if dependencies are unmet (installed through bin/setup in the next command) in
  [61](https://github.com/OSC/frame-renderer/pull/61)

## [0.6.1] - 2021-02-08
### Changed
- Generate SECRET_KEY_BASE during builds in [60](https://github.com/OSC/frame-renderer/pull/60)

## [0.6.0] - 2021-02-04
### Changed
- OnDemand 2.0 compatability in [59](https://github.com/OSC/frame-renderer/pull/59)
  - Upgrades rails 5.2 (up from 4.2)
  - Upgrades bundler to 2.1.4 (up from 1.7.13)

## [0.5.0] - 2020-12-14
### Changed
- use SLURM_ARRAY_TASK_ID instead of PBS_ARRAYID to migrate fully to Slurm.

## [0.4.2] - 2020-12-07
### Fixed
- Yet another frame task calculation bug in [53](https://github.com/OSC/frame-renderer/pull/53)

## [0.4.1] - 2020-12-07
### Fixed
- Fixed two bugs in [51](https://github.com/OSC/frame-renderer/pull/51)
  - one where end frames were not calculated correctly if start frame was > 1
  - another where choosing a single node did not choose the correct element
    in the bash arrays becuase PBSARRAY_ID was unset.

## [0.4.0] - 2020-11-30
### Added
- tests are now ran in Github actions.

### Changed
- start and end frames for each tasks are now calculated in Ruby in
  [49](https://github.com/OSC/frame-renderer/issues/49).

### Fixed
- Files (scenes and thumbnails) can now have spaces in them in
  [50](https://github.com/OSC/frame-renderer/pull/50).

## [0.3.1] - 2020-10-15
### Changed
- OSU to use the new 2020 modules [#48](https://github.com/OSC/frame-renderer/pull/48).
- tags are now prefixed with v.

### Fixed
- Fixed a bug with bind directories in the singularity command [#48](https://github.com/OSC/frame-renderer/pull/48).

## [0.3.0] - 2020-08-25
### Added
- Added the ability to load the Kent State modules based on group membership

### Changed
- Changed the way other sites can configure different things like cores, cluster
  and the script to be submitted.  Sites can now simply use environment varaibles
  instead of ruby initializers.

## [0.2.3] - 2020-04-07
### Fixed
- Another framing bug when users specify just one node [#41](https://github.com/OSC/frame-renderer/pull/40)
  the start and end frames were not corrrect.

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

[Unreleased]: https://github.com/OSC/frame-renderer/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/OSC/frame-renderer/compare/v0.8.0...v1.0.0
[0.8.0]: https://github.com/OSC/frame-renderer/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/OSC/frame-renderer/compare/v0.6.3...v0.7.0
[0.6.3]: https://github.com/OSC/frame-renderer/compare/v0.6.2...v0.6.3
[0.6.2]: https://github.com/OSC/frame-renderer/compare/v0.6.1...v0.6.2
[0.6.1]: https://github.com/OSC/frame-renderer/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/OSC/frame-renderer/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/OSC/frame-renderer/compare/v0.4.2...v0.5.0
[0.4.2]: https://github.com/OSC/frame-renderer/compare/v0.4.1...v0.4.2
[0.4.1]: https://github.com/OSC/frame-renderer/compare/v0.4.0...v0.4.1
[0.4.0]: https://github.com/OSC/frame-renderer/compare/v0.3.1...v0.4.0
[0.3.1]: https://github.com/OSC/frame-renderer/compare/0.3.0...v0.3.1
[0.3.0]: https://github.com/OSC/frame-renderer/compare/0.2.2...0.3.0
[0.2.2]: https://github.com/OSC/frame-renderer/compare/0.2.1...0.2.2
[0.2.1]: https://github.com/OSC/frame-renderer/compare/0.2.0...0.2.1
[0.2.0]: https://github.com/OSC/frame-renderer/compare/0.1.1...0.2.0
[0.1.1]: https://github.com/OSC/frame-renderer/compare/0.1.0...0.1.1
