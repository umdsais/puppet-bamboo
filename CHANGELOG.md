## 2021-11-17 - Release 4.0.2

### Summary

- Adjustments by `pdk update`
- Dropped `assert_private()` to fix collector failures
- Dropped end of life distributions
- Changed bamboo default version to `8.0.3`
- Extended test suite to puppet 7
- Updated module dependencies

## 2020-11-17 - Release 4.0.1

### Summary

- Extended test suite to puppet 5 and puppet 6
- Updated README.md and metadata.json
- Added .sync.yml for `pdk update`

## 2020-11-17 - Release 4.0.0

### Summary

- Requires Puppet 4.10.0
- Changed default version to latest bamboo release 7.1.4
- Introduced types on init.pp
- Fixed spec tests for `pdk test unit`

## 2019-04-23 - Release 3.6.0

### Summary

- Use the archive module instead of the staging module (@bt-lemery PR #21)
- Refresh systemd if service file changes

## 2019-04-19 - Release 3.5.1

### Summary

- Fix an issue with Bamboo > 6.8.0 in managing the Tomcat server connector proxy settings (PR #23)

## 2018-11-29 - Release 3.5.0

### Summary

- Fix issue where environment variables (HOME) were preserved from the login
  user (root) and not set to Bamboo's in the service init. (30d12a5)
- Add `bamboo::umask` parameter to specify a custom UMASK.
- Updates to tests
- Bump default Bamboo version to 6.7.1
- Adopt PDK

## 2016-12-21 - Release 3.4.1

### Summary

- Fix issue where stale external fact is present, causing an upgrade attempt
  on every run.  (issue #14)
- Don't set permgen by default

## 2016-12-13 - Release 3.4.0

### Summary

- Add ability to manage service config (/etc/(sysconfig|default)/bamboo)
  - Add 3 new parameters: `initconfig_manage`, `initconfig_path`, and
    `initconfig_content` (@exeral PR #7)

- Support Debian and Ubuntu
- Fix uknown `puppet_confdir` (resolves #11) (@ssteveli PR #12)

- update default bamboo version to 5.14.3.1
- metadata: depend on `puppet/staging` instead of `nanliu/staging`
- testing: add acceptance tests (beaker) (resolves #10)
- testing: update spec tests (resolves #10)

## 2016-11-17 - Release 3.3.0

### Summary

- Optionally provide `bamboo_version` external fact
- Support stopping service prior to upgrading (resolves #8)
- Update default version to 5.13.2
- README - minor typo correction on homedir parameter name in example (@exeral PR #9)
- metadata: use 'puppet-staging' instead of deprecated 'nanliu-staging'

## 2016-07-20 - Release 3.2.2

### Summary

- Support point releases (x.x.x.x) (@spacepants PR #6)
- Update default version to 5.12.3.1

## 2016-02-04 - Release 3.2.1

### Summary

- Provide param to disable managing the 'installdir' (@Etherdaemon PR #4)
- Provide param to disable managing the 'appdir' (@Etherdaemon PR #4)
- Provide param to specify a custom 'appdir' (@Etherdaemon PR #4)

## 2015-11-17 - Release 3.1.2

### Summary

- Bump default Bamboo version to 5.9.7 from 5.9.4 (@tarrantmarshall PR #3)
- Specify catalina pid file in setenv.sh (@tarrantmarshall PR #3)

## 2015-10-09 - Release 3.1.1

### Summary

- Documentation added
- Expanded unit testing
- Manage home directory even if user isn't managed

## 2015-10-08 - Release 3.1.0

### Summary

- Improvements to init script
  - Better status and stop handling - check process table and wait for
    process shutdown
  - Remove lockfile - check process table

## 2015-10-07 - Release 3.0.0

### Summary

- Forked module from dormant upstream and significant refactoring
- Abstract functionality into separate classes
- Add more customization options, including the ability to manage various
  Bamboo configuration settings (Tomcat)
- Abandon support for older versions of Bamboo

## Release 2.0.0

- Works with Bamboo 4.4+

## Release 1.0.0

- Works with Bamboo up to 4.4
