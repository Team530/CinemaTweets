Rails.application.routes.draw do
  get 'correlation_analysis/index'

  get "correlation_analysis", :to => 'correlation_analysis#index'

  get 'genre_analysis/index'

  get "genre_analysis", :to => 'genre_analysis#index'

  get 'rating_analysis/index'

  get "rating_analysis", :to => 'rating_analysis#index'

  get 'tweet_ranking/index'

  get 'tweet_ranking/show'

  get "tweet_ranking", :to => 'tweet_ranking#index'


  get 'gross_ranking/index'

  get 'gross_ranking/show'

  get "gross_ranking", :to => 'gross_ranking#index'

  get 'tweet_per_movies/index'



  get 'tweet_per_movies/show'

  get 'tweet_per_movies/new'

  get 'tweet_per_movies/edit'

  get 'tweet_per_movies/index'

  root 'welcome#index'

  # For Data Navigation
  resources :movies
  resources :tweets
  resources :keywords
  resources :financial_data
  resources :tweet_per_movies
  resources :genres



  get "/what" => "pages#what"
  get "/who" => "pages#who"
  get "/analysis" => "pages#analysis"

  # User gets redirected to root upon entering unknown routes
  match '*path' => redirect('/'), via: :get

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
