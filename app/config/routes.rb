-> do
  get '/users', to: 'web#users#index'
  post '/users', to: 'web#users#create'
  get '/users/new', to: 'web#users#new'
  get '/users/:id', to: 'web#users#show'
  get '/', to: 'web#home#index'
end
