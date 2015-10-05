require 'i18n'
module Trailblazer::Translation

  # Set the translation scope for relative translation paths
  # based on the class name. If the class is anonymous then
  # iterate through its ancestors until a names class is found.
  #
  # The translation scope is derived from the class name so that,
  # for class +AaBb::CcDd::EeFf+, it is  +aa_bb.cc_dd.ee_ff+.
  def initialize(*args)
    c = self.class
    while c.to_s.match /#<Class:0x[\da-f]+>/ do; c = c.superclass; end
    @scope = c.to_s.gsub('::','.').underscore
    super
  end

  # Allow the scope to be customised
  attr_accessor :scope

  # Attempts to translate the given key which can be given either
  # as an absolute or relative path. If the first character of the
  # key is a period (.) then it represents translation path relative
  # to the currens scope, otherwise it is an absolute path.
  #
  # The scope is a key prefix that is empty by default. It is
  # prepended to a relative key to produce an absolute key.
  #
  # If a translation is not found for a scoped key then the key's
  # penultimate part is removed and translation is re-attempted. 
  # This is repeated until the key has only one part.
  #
  # If a translation canot be found then the default action is to
  # render a "translation missing" +<span>+ HTML element but an
  # a I18n::MissingTranslationData exception will be rased instead
  # if +raise: true+ is given.
  def translate(key, options={})
    scoped = key[0] == '.'
    key = key.prepend(scope) if scoped
    absolute_key = key.dup

    begin
      I18n.translate(key, options.merge(raise:true))
    rescue I18n::MissingTranslationData => e

      if scoped and (options[:iterate] != false ) # iterate up the hierarchy
        last = key.dup
        key.gsub!(/((.*)\.)?(.*)(\.[^.]+$)/,'\2\4') # rubular.com/r/JeQxqKQGrv
        key.slice!(0) if key =~ /^\.[^.]+$/         # rubular.com/r/r1p999nxp8
        retry unless (key == last)
      end

      raise e if (options[:raise] == true)
      "<span>translation missing:#{absolute_key}</span>".html_safe
    end

  end
  alias_method :t, :translate

  # Delegates to <tt>I18n.localize</tt> with no additional functionality.
  def localize(*args)
    I18n.localize(*args)
  end
  alias :l :localize

end
