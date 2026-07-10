import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "label"]
  static values = { source: String }

  async copy(event) {
    event.preventDefault()
    const text = this.hasSourceValue ? this.sourceValue : this.element.textContent

    try {
      await navigator.clipboard.writeText(text)
      this.flash()
    } catch (error) {
      console.error("Copy to clipboard failed", error)
    }
  }

  flash() {
    if (!this.hasIconTarget || !this.hasLabelTarget) return

    this.iconTarget.classList.add("d-none")
    this.labelTarget.classList.remove("d-none")
    this.element.classList.add("is-copying")

    setTimeout(() => {
      this.iconTarget.classList.remove("d-none")
      this.labelTarget.classList.add("d-none")
      this.element.classList.remove("is-copying")
    }, 1500)
  }
}
