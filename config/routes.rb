Rails.application.routes.draw do
  if Rails.env.development?
    get 'theme_kit' => 'theme_kit#index'
  end
end
