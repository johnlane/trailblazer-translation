class Test::Cell < Cell::Concept
  include SimpleForm::ActionViewExtensions::FormHelper
  def show
    render
  end
end
