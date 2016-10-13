Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :loan, only: [:show] do
        resources :payments, only: [:create] do
        end
      end
    end
  end

end
