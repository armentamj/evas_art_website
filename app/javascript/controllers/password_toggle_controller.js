import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "password" ]

  toggle(event) {
    this.passwordTarget.type = event.target.checked ? "text" : "password"
  }
}
