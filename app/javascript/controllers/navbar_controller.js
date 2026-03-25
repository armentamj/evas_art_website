import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "lineOne", "lineTwo", "lineThree", "authen", "nonauthen", "eva" ]

  toggle() {
    // Rotate and move to the exact vertical center (Top line moves down)
    this.lineOneTarget.classList.toggle("rotate-45")
    this.lineOneTarget.classList.toggle("translate-y-[12px]") 
    
    // Rotate and move to the exact vertical center (Bottom line moves up)
    this.lineThreeTarget.classList.toggle("-rotate-45")
    this.lineThreeTarget.classList.toggle("-translate-y-[12px]") 
    
    // Rest of your toggle logic...
    this.lineTwoTarget.classList.toggle("opacity-0")

    // Toggle menus
    this.authenTarget.classList.toggle("hidden")
    this.nonauthenTarget.classList.toggle("hidden")
    this.evaTarget.classList.toggle('hidden')
  }
}
