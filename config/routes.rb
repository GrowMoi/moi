Moi::Application.routes.draw do
  namespace :api do
    namespace :auth do
      mount_devise_token_auth_for(
        "User",
        at: "user",
        controllers: {
          sessions: "api/sessions",
          token_validations: "api/token_validations"
        }
      )
    end
  end

  devise_for :users

  namespace :admin do
    resource :dashboard, only: :index
    resources :users
    resources :profiles

    # settings
    resources :settings, only: :index
    resources :search_engines, except: [:index, :destroy]

    # preview
    match "neurons/preview" => "neurons/preview#preview",
          via: [:post, :patch],
          as: :neuron_preview

    resources :neurons do
      resource :log, module: "neurons",
                     only: :show
      member do
        post :delete
        post :restore
      end
    end

    resource :external_search, only: :create

    resources :contents do
      member do
        post :approve
      end
    end

    root "dashboard#index"
  end

  root "home#index"
end
