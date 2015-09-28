Rails.application.routes.draw do
  scope '(:locale)', locale: /en|es/ do
    root 'application#test'
    post '/' => 'application#test'
  end
end
