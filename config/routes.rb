Moi::Application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    resources :neurons,
              only: [:index, :show] do
      resources :contents,
                only: [] do
        member do
          post :learn
        end
      end
    end
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

  match "/delayed_job" => DelayedJobWeb,
        anchor: false,
        via: [:get, :post]

  root "home#index"

  apipie
end
