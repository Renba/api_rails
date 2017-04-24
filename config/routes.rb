Rails.application.routes.draw do

  namespace :api,
            default: {format: :json},
            constraints: { subdomain: 'api'}, path:'/' do
    scope module: :v1 do

    end
  end

end
