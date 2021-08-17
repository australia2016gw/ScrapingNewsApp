Rails.application.routes.draw do
  root 'news#index'
  get 'news/index'
  get 'news/search'
end
