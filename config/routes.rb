Rails.application.routes.draw do
  resources :servers

  root "tools#calculator"

  get 'calculator', to: 'tools#calculator'
  post 'calculate', to: 'tools#calculate'

end
