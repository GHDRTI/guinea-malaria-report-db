Rails.application.routes.draw do
  
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'

  get '/login'      => 'login#index'
  get '/login/key'  => 'login#login'
  post '/login'     => 'login#send_login'
  get '/logout'     => 'login#logout'

  get '/malaria'                => 'monthly_malaria#index'
  post '/malaria'               => 'monthly_malaria#report'
  get '/malaria/workbooks'      => 'monthly_malaria#workbooks'
  post '/malaria/workbooks'     => 'monthly_malaria#search'
  get '/malaria/workbooks/:id'  => 'monthly_malaria#workbook'

  resources :workbook_files
  patch '/workbook_files/:id/uploaded'  => 'workbook_files#uploaded'
  get '/workbook_files/:id/status'      => 'workbook_files#status'
  get '/workbook_files/:id/activate'    => 'workbook_files#activate'

end
