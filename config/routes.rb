Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :classroom_bs, defaults: { format: 'json' } do

      end
      resources :classroom_as, defaults: { format: 'json' } do

      end
      resources :classroom_cs, defaults: { format: 'json' } do

      end
      resources :big_workspaces, defaults: { format: 'json' } do

      end
    end
  end
end
