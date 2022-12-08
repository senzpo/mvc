# frozen_string_literal: true

lambda do
  get '/api/v1/users', to: 'api#v1#users#index'
  get '/api/v1/users/:id', to: 'api#v1#users#show'
  patch '/api/v1/users/:id', to: 'api#v1#users#update'
  delete '/api/v1/users/:id', to: 'api#v1#users#delete'
  post '/api/v1/users', to: 'api#v1#users#create'

  get '/api/v1/projects', to: 'api#v1#projects#index'
  post '/api/v1/projects', to: 'api#v1#projects#create'
  get '/api/v1/projects/:id', to: 'api#v1#projects#show'
  patch '/api/v1/projects/:id', to: 'api#v1#projects#update'
  delete '/api/v1/projects/:id', to: 'api#v1#projects#delete'

  get '/', to: 'web#home#index'
  get '/signup', to: 'web#home#signup'
  post '/users', to: 'web#users#create'
  get '/login', to: 'web#sessions#new'
  post '/sessions', to: 'web#sessions#create'

  get '/projects', to: 'web#projects#index'
  get '/projects/:id', to: 'web#projects#show'

  any to: 'web#errors#_404'
end
