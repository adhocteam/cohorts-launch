Cohorts::Application.routes.draw do
  scope '/admin' do
    resources :clients
    resources :engagements do
      resources :research_sessions
    end
    resources :landing_pages
    resources :forms, only: [:index, :update] do
      collection do
        get :update_from_wufoo
      end
    end
    resources :gift_cards
    resources :mailchimp_updates
    namespace :public do
      resources :people, only: [:new, :create, :deactivate] do
        get '/deactivate/:token', to:'people#deactivate', as: :deactivate
      end
    end

    get 'registration', to: 'public/people#new'

    resources :twilio_wufoos

    resources :twilio_messages do
      collection do
        post 'newtwil'
        get 'newtwil'
        post 'uploadnumbers'
        get 'sendmessages'
      end
    end


    post 'receive_text/index', defaults: { format: 'xml' }
    post 'receive_text/smssignup', defaults: { format: 'xml' }

    # post "twilio_messages/updatestatus", to: 'twilio_messages/#updatestatus'

    # post "twil", to: 'twilio_messages/#newtwil'

    get 'taggings/create'
    post 'taggings/bulk_create'
    get 'taggings/destroy'
    get 'taggings/search'

    get 'mailchimp_export/index'
    get 'mailchimp_export/create'

    devise_for :users
    get 'dashboard/index'
    resources :submissions, except: [:destroy]

    resources :comments
    resources :taggings, only: [:create, :destroy]

    get  'search/index'
    post 'search/index'
    post 'search/save_to_engagement'
    post 'search/export_ransack'
    post 'search/export' # send search results elsewhere, i.e. Mailchimp
    post 'search/exportTwilio'

    get 'mailchimp_exports/index'

    resources :people do
      collection do
        post 'create_sms'
        post ':person_id/deactivate', action: :deactivate, as: :deactivate
        post 'import_csv'
      end
      resources :comments
      resources :gift_cards
    end
    # post "people/create_sms"

    get 'privacy_mode', to: 'application#privacy_mode', as: :privacy_mode
    root to: 'dashboard#index', as: :admin_root
  end

  get 'veterans/signup', to: 'static#vets_signup'
  get 'signup/:tag_name', to: 'signup#index', as: :landing_signup

  root to: 'signup#index'
end
