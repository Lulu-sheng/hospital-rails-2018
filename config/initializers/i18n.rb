#encoding: utf-8
I18n.default_locale = :en

LANGUAGES = [
  ['English', 'en'],
  ["Fran&ccedilais".html_safe, 'fr'] 
]

I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
