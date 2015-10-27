
This is an initial implementation of a translation module for Trailblazer
that does not rely on ActionView.

It works similar to, but is not the same as, the ActionView translate "t"
helper.

I've done enough to see how this can plug in to Trailblazer but it can be
later extended to mirror the ActionView functionality if desired. Things that
it doesn't do include the speacial treatment of keys ending in `_html`.

It has features lacking in ActionView:

1. If a relative translation path is given and the key is not found then
it will iterate up the hierarchy to find it. (this behaviour can be disabled
by giving `iterate: false` as an option.

2. If a relative translation path is given then any 'cell' path components
are removed. This is done to reduce clutter in the translation namespace.
It allows a translation in Thing::Cell::Item for a `'.key'` to find a
translation at `thing.item.key` instead of `thing.cell.item.key'.

ISSUES
------

The scope of an anonymous contract class will be "reform.form" which isn't
ideal and, for this reason, the example code uses a named class.

CODE
----

The main code is in `lib/trailblazer/translation.rb` and its initialization
in `config/initializers/trailblazer.rb`/ Everything else is for testing and
evaluation: a Rails app with with a single action at the root url.

TESTS
-----

There are some tests in test/i18n_test.rb

TO DO
-----

Some things I want to do if this is a workable solution

* set options globally
* consider matching the full functionality of the ActionView helper
* support a per-conept "locale" directory with YAML files that supplement
  the main ones.
