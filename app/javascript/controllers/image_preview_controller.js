import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  // Triggered whenever new files selected on phone
  show() {
    // Clear previous temporary previews
    this.previewTarget.innerHTML = ""

    const files = Array.from(this.inputTarget.files)
    
    files.forEach(file => {
      const reader = new FileReader()
      
      reader.onload = (e) => {
        // Create a thumbnail that matches your existing scroll style
        const previewHtml = `
          <div class="relative flex-none w-24 h-24 rounded-lg border border-blue-400 bg-gray-50 shadow-inner">
            <img src="${e.target.result}" class="w-full h-full object-cover rounded-lg">
            <div class="absolute bottom-0 left-0 right-0 bg-blue-600 text-white text-[10px] text-center rounded-b-lg">
              New
            </div>
          </div>
        `
        this.previewTarget.insertAdjacentHTML("beforeend", previewHtml)
      }
      
      reader.readAsDataURL(file)
    })
  }
}