Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :classroom_bs, defaults: { format: 'json' } do

      end
    end
  end
end
