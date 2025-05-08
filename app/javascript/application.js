import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import { registerControllersFrom } from "@hotwired/stimulus-importmap-autoloader"

import "bootstrap"
import Rails from "@rails/ujs"
Rails.start()

const application = Application.start()
registerControllersFrom("controllers", application)

import "controllers"
