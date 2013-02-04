Rails.application.routes.draw do

  mount BarclampLogging::Engine => "/barclamp_logging"
end
