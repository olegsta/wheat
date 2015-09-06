Rails.application.routes.draw do

  devise_for :users, controllers: {
        sessions: 'users/sessions',
        registrations: 'users/registrations'
  }
  root "application#index"

  scope :ajax do
    get 'offers' => 'offers#index'
    get 'messages' => 'messages#index'
    get 'analytics' => 'analytics#index'
    get 'support' => 'support#index'
    get 'help' => 'help#index'
    get 'profile' => 'profile#index'
    get 'settings' => 'settings#index'

    scope :search do
      get '/' => 'search#index', as: :search
      get 'suitable' => 'search#suitable'
    end

    post 'attachments' => 'attachments#upload'
    delete 'attachments' => 'attachments#destroy'
    resources :positions do
      collection do
        post 'send_offer' => 'positions#send_offer'
      end
    end
    resources :favorites
    resources :templates
    resources :correspondences
  end

  get '/*path' => 'application#index'
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
