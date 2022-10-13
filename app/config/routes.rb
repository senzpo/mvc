-> do
  get '/users', to: 'users#index'
  post '/users/:id', to: 'users#show'
end
