import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.querySelectorAll("pre").forEach((pre) => this.addCopyButton(pre))
  }

  addCopyButton(pre) {
    if (pre.dataset.copyButtonAdded) return
    pre.dataset.copyButtonAdded = "true"

    const wrapper = document.createElement("div")
    wrapper.className = "code-block-wrapper"
    pre.replaceWith(wrapper)
    wrapper.appendChild(pre)

    const button = document.createElement("button")
    button.type = "button"
    button.className = "btn btn-sm code-copy-btn"
    button.innerHTML = '<i class="fa-solid fa-copy"></i>'
    button.addEventListener("click", () => this.copy(pre, button))
    wrapper.appendChild(button)
  }

  async copy(pre, button) {
    const code = pre.querySelector("code") || pre

    try {
      await navigator.clipboard.writeText(code.textContent)
      const original = button.innerHTML
      button.innerHTML = "Copied!"
      setTimeout(() => { button.innerHTML = original }, 1500)
    } catch (error) {
      console.error("Copy to clipboard failed", error)
    }
  }
}
