class Test::Form < Trailblazer::Operation

  class Form < Reform::Form
    undef :persisted?
    property :one, virtual: true
    property :two, virtual: true
    validate :must_be_equal

    private

    def must_be_equal
      if one != two
        
        errors.add(:one,
                   t('.oops') + t('.error', first: t('.one'), second: t('.two')))
        errors.add(:two,
                   t('.oops') + t('.error', first: t('.two'), second: t('.one')))
      end
    end
  end

  contract Form

  def process(params)
    Rails.logger.debug t('.oops')
    validate(params[:test])
    Rails.logger.debug t('should_give_a_translation_missing_span')
    Rails.logger.debug t('.should_not_iterate', iterate: false)
  end
end
