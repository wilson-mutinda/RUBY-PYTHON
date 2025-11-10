Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      
      post 'create_category', to: 'categories#create_category'
      get 'single_category/:slug', to: 'categories#single_category'
      get 'all_categories', to: 'categories#all_categories'
      patch 'update_category/:slug', to: 'categories#update_category'
      delete 'delete_category/:slug', to: 'categories#delete_category'
      get 'restore_category/:slug', to: 'categories#restore_category'

      post 'create_post', to: 'posts#create_post'
      get 'single_post/:slug', to: 'posts#single_post'
      get 'all_posts', to: 'posts#all_posts'
      patch 'update_post/:slug', to: 'posts#update_post'
      delete 'delete_post/:slug', to: 'posts#delete_post'
      get 'restore_post/:slug', to: 'posts#restore_post'
    end
  end
end
