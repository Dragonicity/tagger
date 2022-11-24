Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get 'tags/:tag', to: 'articles#index', as: :tag
    resources :articles
    resources :tags
    root to: "tags#index" 
    resources :templates
  end
end
