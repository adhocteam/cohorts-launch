Cohorts::Application.routes.draw do
  scope '/admin' do
    resources :clients, except: [:show, :new, :edit]
    resources :engagements, except: [:show, :new, :edit]
    resources :research_sessions, except: [:show, :new, :edit]
    resources :forms, only: [:index, :update]
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
    get 'taggings/destroy'
    get 'taggings/search'

    get 'mailchimp_export/index'
    get 'mailchimp_export/create'

    devise_for :users
    get 'dashboard/index'
    resources :submissions

    resources :comments
    resources :taggings, only: [:create, :destroy]

    get  'search/index'
    post 'search/index'
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

    root to: 'dashboard#index', as: :admin_root
  end

  get 'veterans/signup', to: 'static#vets_signup'

  root to: 'static#signup'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
