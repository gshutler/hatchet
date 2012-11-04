# Release notes

## 0.0.17

 * Added the ability to pass an error along with your message

### Bug fixes

 * Fixed the fallback logging if an appender raises an error whilst trying to
   log a message
 * Ensured all logging calls truly do return `nil` rather than it just being
   part of the documented contract
