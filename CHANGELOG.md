# Changelog

## v0.11.0
- Add support for Rails 8.0. **Thanks [@olivier-thatch](https://github.com/olivier-thatch)**

## v0.10.0
- Drop support for Ruby 3.0.
- Add support for Rails 7.2. **Thanks [@kwent](https://github.com/kwent)**

## v0.9.0
- Add MySql support

## v0.8.0
- Drop support for Ruby 2.7.
- Drop support for Rails 6.0.
- Add support for Ruby 3.3.

## v0.7.0
- Add support for Rails 7.1.

## v0.6.0
- Drop support for Ruby < 2.7 and Rails < 6.0.
- Add support for Ruby 3.1.
- Add support for Rails 7.0.

## [v0.5.1](https://github.com/salsify/safer_rails_console/tree/v0.5.0) (2020-01-29)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.5.0...v0.5.1)

**Merged pull requests:**

- Ruby 3 Support [\#39](https://github.com/salsify/safer_rails_console/pull/39) ([kphelps](https://github.com/kphelps))

## [v0.5.0](https://github.com/salsify/safer_rails_console/tree/v0.5.0) (2020-12-15)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.4.1...v0.5.0)

**Merged pull requests:**

- Enable frozen string literals cop [\#36](https://github.com/salsify/safer_rails_console/pull/36) ([jturkel](https://github.com/jturkel))
- Rails 6.1 Support [\#35](https://github.com/salsify/safer_rails_console/pull/35) ([jturkel](https://github.com/jturkel))
- Migrate to CircleCI [\#34](https://github.com/salsify/safer_rails_console/pull/34) ([jturkel](https://github.com/jturkel))

## [v0.4.1](https://github.com/salsify/safer_rails_console/tree/v0.4.1) (2020-10-13)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.4.0...v0.4.1)

**Closed issues:**

- No default settings for rails 5.1 and 5.2 [\#29](https://github.com/salsify/safer_rails_console/issues/29)

**Merged pull requests:**

- Bump version v0.4.1 [\#33](https://github.com/salsify/safer_rails_console/pull/33) ([alexsalsify](https://github.com/alexsalsify))
- Add support for config values from ENV variables [\#32](https://github.com/salsify/safer_rails_console/pull/32) ([alexsalsify](https://github.com/alexsalsify))

## [v0.4.0](https://github.com/salsify/safer_rails_console/tree/v0.4.0) (2019-09-19)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.3.0...v0.4.0)

**Closed issues:**

- safer\_rails\_console breaks newrelic reporting [\#23](https://github.com/salsify/safer_rails_console/issues/23)

**Merged pull requests:**

- Use Postgres for local development too [\#28](https://github.com/salsify/safer_rails_console/pull/28) ([jturkel](https://github.com/jturkel))
- Rails 6.0 support [\#27](https://github.com/salsify/safer_rails_console/pull/27) ([jturkel](https://github.com/jturkel))
- Drop Rails 4.2 support [\#26](https://github.com/salsify/safer_rails_console/pull/26) ([jturkel](https://github.com/jturkel))

## [v0.3.0](https://github.com/salsify/safer_rails_console/tree/v0.3.0) (2018-04-16)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.2.0...v0.3.0)

**Merged pull requests:**

- Add support for Rails 5.2; remove support for Rails 4.1 [\#24](https://github.com/salsify/safer_rails_console/pull/24) ([timothysu](https://github.com/timothysu))

## [v0.2.0](https://github.com/salsify/safer_rails_console/tree/v0.2.0) (2017-09-07)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.1.4...v0.2.0)

**Implemented enhancements:**

- Sandbox mode should make it clear that edits don't stick [\#19](https://github.com/salsify/safer_rails_console/issues/19)
- Writes made in sandbox mode take out DB locks [\#18](https://github.com/salsify/safer_rails_console/issues/18)
- Confusion over unsandboxed/sandboxed terminology in command prompt [\#17](https://github.com/salsify/safer_rails_console/issues/17)

**Merged pull requests:**

- Set DB transactions to read-only and provide messaging for non-read operations [\#21](https://github.com/salsify/safer_rails_console/pull/21) ([timothysu](https://github.com/timothysu))
- Change 'sandboxed' and 'unsandboxed' to 'read-only' and 'writable' and add respective flags [\#20](https://github.com/salsify/safer_rails_console/pull/20) ([timothysu](https://github.com/timothysu))

## [v0.1.4](https://github.com/salsify/safer_rails_console/tree/v0.1.4) (2017-08-15)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.1.3...v0.1.4)

**Fixed bugs:**

- Invalid cached and prepared statements do not trigger a automatic rollback with PostgreSQL [\#16](https://github.com/salsify/safer_rails_console/issues/16)
- safer\_rails\_console doesn't work in alerts service rails console mode in sandbox mode [\#13](https://github.com/salsify/safer_rails_console/issues/13)

**Merged pull requests:**

- Patch PostgreSQLAdapter\#execute\_and\_clear instead of AbstractAdapter\#log for auto-rollback [\#15](https://github.com/salsify/safer_rails_console/pull/15) ([timothysu](https://github.com/timothysu))

## [v0.1.3](https://github.com/salsify/safer_rails_console/tree/v0.1.3) (2017-08-02)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.1.2...v0.1.3)

**Fixed bugs:**

- Auto-sandboxing on environment does not work in Rails 5.1 [\#4](https://github.com/salsify/safer_rails_console/issues/4)

**Merged pull requests:**

- Default sandbox flag to nil in Rails 5.1 [\#12](https://github.com/salsify/safer_rails_console/pull/12) ([timothysu](https://github.com/timothysu))
- Resolve sqlite3 dependency warning [\#11](https://github.com/salsify/safer_rails_console/pull/11) ([timothysu](https://github.com/timothysu))

## [v0.1.2](https://github.com/salsify/safer_rails_console/tree/v0.1.2) (2017-07-21)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.1.1...v0.1.2)

**Merged pull requests:**

- Dasherize the app name given CamelCase [\#10](https://github.com/salsify/safer_rails_console/pull/10) ([timothysu](https://github.com/timothysu))

## [v0.1.1](https://github.com/salsify/safer_rails_console/tree/v0.1.1) (2017-07-07)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/v0.1.0...v0.1.1)

**Fixed bugs:**

- Nothing happens when Spring is running [\#6](https://github.com/salsify/safer_rails_console/issues/6)

**Merged pull requests:**

- Add support for Spring [\#8](https://github.com/salsify/safer_rails_console/pull/8) ([timothysu](https://github.com/timothysu))

## [v0.1.0](https://github.com/salsify/safer_rails_console/tree/v0.1.0) (2017-06-26)

[Full Changelog](https://github.com/salsify/safer_rails_console/compare/baddba2bc069bc6d72e779d8c157e19d26b30fc1...v0.1.0)

**Merged pull requests:**

- Initial Implementation [\#2](https://github.com/salsify/safer_rails_console/pull/2) ([timothysu](https://github.com/timothysu))
