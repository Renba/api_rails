Rails.application.routes.draw do

  namespace :api,
            default: {format: :json},
            constraints: { subdomain: 'api'}, path:'/' do

  end

end
