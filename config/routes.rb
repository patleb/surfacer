Rails.application.routes.draw do
  if Rails.env.development?
    get 'ui_kit' => 'ui_kit#index'
  end
end
