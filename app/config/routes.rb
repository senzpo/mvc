# frozen_string_literal: true

lambda do
  get '/users', to: 'web#users#index'
  post '/users', to: 'web#users#create'
  get '/users/new', to: 'web#users#new'
  get '/users/:id', to: 'web#users#show'
  post '/users/:id', to: 'web#users#update'
  get '/users/:id/edit', to: 'web#users#edit'

  get '/api/v1/users', to: 'api#v1#users#index'
  get '/api/v1/users/:id', to: 'api#v1#users#show'
  patch '/api/v1/users/:id', to: 'api#v1#users#update'
  delete '/api/v1/users/:id', to: 'api#v1#users#delete'
  post '/api/v1/users', to: 'api#v1#users#create'

  get '/api/v1/projects', to: 'api#v1#projects#index'
  post '/api/v1/projects', to: 'api#v1#projects#create'
  patch '/api/v1/projects/:id', to: 'api#v1#projects#update'

  get '/', to: 'web#home#index'
end
