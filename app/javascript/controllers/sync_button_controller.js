import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 5000 } }
  static targets = ["button"]

  connect() {
    this.isProcessing = false
    if (this.hasButtonTarget) {
      this.originalText = this.buttonTarget.textContent
    }
  }

  handleSubmit(event) {
    if (this.isProcessing) {
      event.preventDefault()
      return false
    }

    event.preventDefault()
    this.isProcessing = true
    
    // Update button text to show countdown
    if (this.hasButtonTarget) {
      this.buttonTarget.disabled = true
      this.startCountdown()
    }
    
    // After delay, submit the form
    setTimeout(() => {
      this.element.submit()
    }, this.delayValue)
    
    return false
  }

  startCountdown() {
    if (!this.hasButtonTarget) return
    
    let remaining = this.delayValue / 1000 // Convert to seconds
    
    const updateButton = () => {
      if (remaining > 0 && this.hasButtonTarget) {
        this.buttonTarget.textContent = `Syncing in ${remaining}s...`
        remaining--
        setTimeout(updateButton, 1000)
      } else if (this.hasButtonTarget) {
        this.buttonTarget.textContent = "Syncing..."
      }
    }
    
    updateButton()
  }
}
