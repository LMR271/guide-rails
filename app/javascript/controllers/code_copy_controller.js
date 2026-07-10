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

    const icon = document.createElement("i")
    icon.className = "fa-solid fa-copy"

    const label = document.createElement("span")
    label.className = "d-none copied-label"
    label.textContent = "Copied!"

    button.append(icon, label)
    button.addEventListener("click", () => this.copy(pre, button, icon, label))
    wrapper.appendChild(button)
  }

  async copy(pre, button, icon, label) {
    const code = pre.querySelector("code") || pre

    try {
      await navigator.clipboard.writeText(code.textContent)
      icon.classList.add("d-none")
      label.classList.remove("d-none")
      button.classList.add("is-copying")

      setTimeout(() => {
        icon.classList.remove("d-none")
        label.classList.add("d-none")
        button.classList.remove("is-copying")
      }, 1500)
    } catch (error) {
      console.error("Copy to clipboard failed", error)
    }
  }
}
