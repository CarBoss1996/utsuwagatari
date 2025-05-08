import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

export function registerControllers(application, include = null) {
  eagerLoadControllersFrom("controllers", application, include)
}
