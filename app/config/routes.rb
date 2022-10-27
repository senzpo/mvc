-> do
  get '/users', to: 'web#users#index'
  post '/users', to: 'web#users#create'
  get '/users/new', to: 'web#users#new'
  get '/users/:id', to: 'web#users#show'
  post '/users/:id', to: 'web#users#update'
  get '/users/:id/edit', to: 'web#users#edit'
  get '/', to: 'web#home#index'
end
