Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :classroom_bs, only: [:index], defaults: { format: 'json' } do

      end
      resources :classroom_as, only: [:index], defaults: { format: 'json' } do

      end
      resources :classroom_cs, only: [:index], defaults: { format: 'json' } do

      end
      resources :big_workspaces, only: [:index], defaults: { format: 'json' } do

      end
      resources :today_checkers, only: [:index], defaults: { format: 'json' } do

      end
    end
  end
end
