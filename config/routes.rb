Rails.application.routes.draw do
  resources :loans, defaults: {format: :json}

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      resources :loans, only: [:show] do
        resources :payments, only: [:create, :show, :index] do
        end
      end
    end
  end

end
