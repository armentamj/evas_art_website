import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="artwork-email"
export default class extends Controller {
  static values = {
    email: String,
    subject: String,
    body: String,
    message: String
  }

  open(event) {
    // Prevent the default '#' click behavior
    event.preventDefault()

    // FIXED: Use this.messageValue instead of message
    if (window.confirm(this.messageValue)) {
      const mailtoUrl = `mailto:${this.emailValue}?subject=${encodeURIComponent(this.subjectValue)}&body=${encodeURIComponent(this.bodyValue)}`
      window.location.href = mailtoUrl
    }
  }
}