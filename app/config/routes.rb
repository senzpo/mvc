-> do
  get '/users', to: 'users#index'
  get '/users/new', to: 'users#new'
  get '/users/:id', to: 'users#show'
  get '/users/:id/tags/:tag_id', to: 'users#show'
  get '/', to: 'web#home#index'
end
