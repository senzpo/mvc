-> do
  get '/users', to: 'users#index'
  get '/users/:id', to: 'users#show'
  get '/users/:id/tags/:tag_id', to: 'users#show'
end
