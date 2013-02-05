BC_VERSION=2.0

BarclampLogging::Engine.routes.draw do

  scope "#{BC_VERSION}" do
    resources :barclamps do
      collection do
        get :export
      end
      member do
      
      end
    end
  end

# configure routes for these Logging barclamps controller actions...
# (other controllers may also need routing configuration!)
#export

end
