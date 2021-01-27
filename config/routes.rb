Rails.application.routes.draw do
  root to: "parsings#index"
  get 'parse_catalog', to: "parsings#parse_catalog"
  get 'parse_products', to: "parsings#parse_products"
  get 'export', to: "parsings#export_excel"

end
