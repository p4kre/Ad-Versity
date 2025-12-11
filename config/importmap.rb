# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js"
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"

# Chartkick - using CDN
pin "chartkick", to: "https://cdn.jsdelivr.net/npm/chartkick@5.2.1/dist/chartkick.min.js", preload: true
