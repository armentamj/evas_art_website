import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
  static targets = [ "navi", "bod", "lineOne", "lineTwo", "lineThree", "authen", "nonauthen", "eva" ]

  toggle() {
    // Toggles rotation for the "X" effect
    this.lineOneTarget.classList.toggle("rotate-45")
    this.lineThreeTarget.classList.toggle("-rotate-45")
    
    // Toggles visibility for the middle line and menus
    this.lineTwoTarget.classList.toggle("hidden")
    this.authenTarget.classList.toggle("hidden")
    this.nonauthenTarget.classList.toggle("hidden")
    this.evaTarget.classList.toggle('hidden')
  }
}
