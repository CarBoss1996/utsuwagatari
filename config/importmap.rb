# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "popper", to: "popper.js", preload: true
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.1/dist/jquery.js"
pin "@rails/ujs", to: "https://ga.jspm.io/npm:@rails/ujs@6.1.5/lib/assets/compiled/rails-ujs.js"
pin "js-cookie", to: "https://ga.jspm.io/npm:js-cookie@3.0.1/dist/js.cookie.mjs"
pin "underscore", to: "https://ga.jspm.io/npm:underscore@1.13.4/modules/index-all.js"
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js"
pin "stimulus-sortable", to: "https://ga.jspm.io/npm:stimulus-sortable@4.1.0/dist/stimulus-sortable.mjs"
pin "select2", to: "https://ga.jspm.io/npm:select2@4.1.0-rc.0/dist/js/select2.js"
pin "stimulus-carousel", to: "https://ga.jspm.io/npm:stimulus-carousel@5.0.1/dist/stimulus-carousel.mjs"
pin "dom7", to: "https://ga.jspm.io/npm:dom7@4.0.6/dom7.esm.js"
pin "ssr-window", to: "https://ga.jspm.io/npm:ssr-window@4.0.2/ssr-window.esm.js"
pin "swiper/bundle", to: "https://ga.jspm.io/npm:swiper@8.4.7/swiper-bundle.esm.js"
pin "intl-tel-input", to: "https://ga.jspm.io/npm:intl-tel-input@18.2.1/index.js"
pin "chartkick", to: "chartkick.js"
pin "Chart.bundle", to: "Chart.bundle.js"

pin "jdenticon" # @3.2.0
pin "tinymce" # @5.10.0
pin "rellax" # @1.12.1

pin "moment" # @2.30.1pin "chart.js" # @4.4.7
pin "stimulus", to: "stimulus.min.js", preload: true
pin "process" # @2.1.0
