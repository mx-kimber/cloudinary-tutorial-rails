Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :images
  post '/upload_image', to: 'images#upload_image'
  
end
