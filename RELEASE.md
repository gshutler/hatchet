# Release notes

## 0.2.6

 * Log messages can be objects deferring to `to_s` (thanks to
   [@gstark](https://github.com/gstark))

## 0.2.5

 * Rails 4.0 compatibility

## 0.2.2

 * Achieved a [4.0 GPA on Code * Climate](https://codeclimate.com/github/gshutler/hatchet)
   and resolved all warnings when running in `-w` mode

## 0.2.1

 * Changed the middleware to insert itself before `Rails::Rack::Logger` for
   consistent behavior

## 0.2.0

 * Added nested diagnostic context and Rack middleware to clear it between
   requests

### Note

The `Hatchet::Message` constructor has been altered, going forward it will take
a Hash of arguments instead of fixed arguments. It is currently backwards
compatible but this will likely be dropped for 1.0.0 so it is advised you update
your libraries now.

This should only affect custom formatters which may want to take advantage of
the nested diagnostic context which is now available anyway.

## 0.1.0

No changes from 0.0.20, just time for a minor version release.

## 0.0.20

 * Added a `#thread_context` attribute to the `SimpleFormatter` that is `false`
   by default, but when set to `true` will output the context of the thread
   within messages in the same style as the `StandardFormatter`

## 0.0.19

 * Changed core formatters to output an indented backtrace after a message when
   an error is present, can be disabled via the formatter's `backtrace=`
   attribute

## 0.0.18

 * Made the presence of a `formatter=` method on appenders optional

## 0.0.17

 * Added the ability to pass an error along with your message

### Bug fixes

 * Fixed the fallback logging if an appender raises an error whilst trying to
   log a message
 * Ensured all logging calls truly do return `nil` rather than it just being
   part of the documented contract
