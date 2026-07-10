import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { source: String }

  async copy(event) {
    event.preventDefault()
    const button = event.currentTarget
    const text = this.hasSourceValue ? this.sourceValue : this.element.textContent

    try {
      await navigator.clipboard.writeText(text)
      this.flash(button)
    } catch (error) {
      console.error("Copy to clipboard failed", error)
    }
  }

  flash(button) {
    const original = button.innerHTML
    button.innerHTML = "Copied!"
    button.disabled = true

    setTimeout(() => {
      button.innerHTML = original
      button.disabled = false
    }, 1500)
  }
}
