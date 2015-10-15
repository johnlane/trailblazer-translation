
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

The main problem that I have is that the module needs to be mixed in to an
operation with "prepend" instead of "include" otherwise the inheritance chain
will exclude the initializer in the module that sets the translation scope.

This does not appear to affect its inclusion in the contract.

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


Operation
---------

With include:

Operation Ancestors:
[Test::Form, Trailblazer::Operation, Trailblazer::Translation, Trailblazer::Operation::Setup, Uber::Builder, Object, ActiveSupport::Dependencies::Loadable, PP::ObjectMixin, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]

the scope is not initialized.

With prepend:

Operation Ancestors:
[Test::Form, Trailblazer::Translation, Trailblazer::Operation, Trailblazer::Operation::Setup, Uber::Builder, Object, ActiveSupport::Dependencies::Loadable, PP::ObjectMixin, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]

the scope is initialized.


Contract
--------

with include

Contract Ancestors:
[#<Class:0xaad59f8>, Test::Form::Form, #<Module:0xaad7c1c>, #<Module:0xaae248c>, Reform::Form, Trailblazer::Translation, #<Module:0x95a0aec>, Reform::Form::ActiveModel::Validations, Reform::Form::ORM, #<Module:0x95bb248>, Reform::Form::ActiveRecord, Reform::Form::ActiveModel::FormBuilderMethods, #<Module:0x95ba3e8>, Reform::Form::ActiveModel, Reform::Form::Prepopulate, Disposable::Twin::Save, Disposable::Twin::Sync::SkipGetter, Disposable::Twin::Sync, Disposable::Twin::Sync::Writeable, Disposable::Twin::Sync::SyncOptions, Disposable::Twin::Sync::ToNestedHash, Disposable::Twin::Changed, Reform::Form::Validate, Reform::Contract, Reform::Contract::Readonly, Reform::Contract::Validate, Disposable::Twin::Default, Disposable::Twin::Setup::SkipSetter, Disposable::Twin::Expose, Disposable::Twin::Expose::Initialize, Disposable::Twin, Disposable::Twin::Option, Disposable::Twin::ModelReaders, Disposable::Twin::ToS, Disposable::Twin::Accessors, Disposable::Twin::Setup, Object, ActiveSupport::Dependencies::Loadable, PP::ObjectMixin, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]

the scope is initialized

With prepend

Contract Ancestors:
[#<Class:0xb0dfe0c>, Test::Form::Form, #<Module:0xb0f5590>, #<Module:0xb0f7430>, Trailblazer::Translation, Reform::Form, #<Module:0x9b821a4>, Reform::Form::ActiveModel::Validations, Reform::Form::ORM, #<Module:0x9b8c258>, Reform::Form::ActiveRecord, Reform::Form::ActiveModel::FormBuilderMethods, #<Module:0x9b8e60c>, Reform::Form::ActiveModel, Reform::Form::Prepopulate, Disposable::Twin::Save, Disposable::Twin::Sync::SkipGetter, Disposable::Twin::Sync, Disposable::Twin::Sync::Writeable, Disposable::Twin::Sync::SyncOptions, Disposable::Twin::Sync::ToNestedHash, Disposable::Twin::Changed, Reform::Form::Validate, Reform::Contract, Reform::Contract::Readonly, Reform::Contract::Validate, Disposable::Twin::Default, Disposable::Twin::Setup::SkipSetter, Disposable::Twin::Expose, Disposable::Twin::Expose::Initialize, Disposable::Twin, Disposable::Twin::Option, Disposable::Twin::ModelReaders, Disposable::Twin::ToS, Disposable::Twin::Accessors, Disposable::Twin::Setup, Object, ActiveSupport::Dependencies::Loadable, PP::ObjectMixin, JSON::Ext::Generator::GeneratorMethods::Object, Kernel, BasicObject]

the scope is initialised
