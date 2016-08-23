Surfacer::Engine.routes.draw do
  get 'theme_kit' => 'theme_kit#index' if Rails.env.development?
end
