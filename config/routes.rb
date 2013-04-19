require 'sidekiq/web'

Migrationrocket::Application.routes.draw do

  resources :users
  
  
  
  # Clients
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :clients
  match "/zendesk/test" => 'clients#zendesk'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Profiles
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :profiles
  match "/imports" => 'profiles#index'
  match "/imports/:id" => 'profiles#show'
  match "/imports/:profile_id/select" => 'profiles#select'
  match "/imports/:profile_id/skip" => 'profiles#skip'
  match "/imports/:profile_id/prev" => 'profiles#prev'
  match "/new_import" => 'profiles#new'
  match "/imports/:id/delete" => 'profiles#destroy'
  match "/imports/:profile_id/rollback" => 'profiles#rollback'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Mapping
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :mapping,path: "/imports/:profile_id/mapping/:type"
  match "/imports/:profile_id/mapping/:type/:map_id/deactivate" => 'mapping#deactivate'
  match "/imports/:profile_id/mapping/:type/:map_id/activate" => 'mapping#activate'
  #match "/imports/:profile_id/mapping/new" => 'mapping#new'
  #match "/imports/:profile_id/mapping/create" => 'mapping#create'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Import
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :import
  match "/imports/:profile_id/import/:type" => 'import#index'
  match "/imports/:profile_id/import/:type/status" => 'import#status'
  match "/imports/:profile_id/import/:type/start" => 'import#start'
  match "/imports/:profile_id/import/:type/stop" => 'import#stop'
  match "/imports/:profile_id/import/:type/reset" => 'import#reset'
  match "/imports/:profile_id/import/:type/log" => 'import#log'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Sync
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :sync
  match "/imports/:profile_id/sync" => 'sync#index'
  match "/imports/:profile_id/sync/start" => 'sync#start'
  match "/imports/:profile_id/sync/status" => 'sync#status'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # CSV
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :csv
  match "/imports/:profile_id/csv/:type" => 'csv#files'
  match "/imports/:profile_id/csv/:type/upload" => 'csv#upload'
  match "/imports/:profile_id/csv/:type/attachments/:attachment_id/reset" => 'csv#reset'
  match "/imports/:profile_id/csv/:type/attachments/:attachment_id/log" => 'csv#log'
  match "/imports/:profile_id/csv/:type/attachments/:attachment_id/extract" => 'csv#extract'
  match "/imports/:profile_id/csv/:type/attachments/:attachment_id/raw" => 'csv#raw'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Attachments
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :attachments
  resources :keys
  match "/imports/:profile_id/csv/:type/attachments/:id/status" => 'attachments#status'
  match "/imports/:profile_id/csv/:type/attachments/:attachment_id/delete" => 'attachments#destroy'
  match "/imports/:profile_id/csv/:type/attachments/:id/status" => 'attachments#status'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Desk
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  resources :desk,path: "/desk"
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  resources :sessions  
  get 'sessions/new'
  get 'signup', to: 'users#new', as: 'signup'
  get 'access/login', to: 'sessions#new', as: 'login'
  get 'access/logout', to: 'sessions#destroy', as: 'logout'
  
  root :to => 'profiles#splash'
  
  mount Sidekiq::Web, at: '/sidekiq'
  #mount Sidekiq::Web, at: "/sidekiq"
  
end