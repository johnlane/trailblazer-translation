class ApplicationController < ActionController::Base
  include Trailblazer::Operation::Controller

  require_dependency 'test/operations'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def test
    I18n.locale = params[:locale]
    if request.post?
      run Test::Form do |op|
        return redirect_to root_url
      end
      render
    else
      form Test::Form
    end
  end

  private

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

end
