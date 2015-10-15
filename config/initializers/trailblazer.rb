require 'cell/translation'

Cell::Concept.class_eval do
  include ActionView::Helpers::TranslationHelper
  include Cell::Translation
  include Cell::Erb
end

require 'trailblazer/translation'

# Note: have to prepend here or it won't work because
# the "initialize" in Trailblazer::Operation does not call "super"
class Trailblazer::Operation
  prepend Trailblazer::Translation
end

# Include works here though
class Reform::Form
  include Trailblazer::Translation
end

class Cell::Concept
  include Trailblazer::Translation
end
