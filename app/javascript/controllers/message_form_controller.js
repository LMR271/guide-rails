import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  submitOnEnter(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.element.querySelector('input[type="submit"]').click()
    }
  }

  appendOptimistic() {
    const textarea = this.element.querySelector("textarea")
    const messages = document.getElementById("messages")
    if (!textarea || !messages) return

    const text = textarea.value.trim()
    if (!text) return

    document.getElementById("empty-chat-placeholder")?.remove()
    document.getElementById("optimistic-message")?.remove()

    const row = document.createElement("div")
    row.id = "optimistic-message"
    row.className = "d-flex flex-column align-items-end mb-3"

    const wrapper = document.createElement("div")
    wrapper.className = "message-bubble-wrapper"

    const bubble = document.createElement("div")
    bubble.className = "message-bubble bg-danger text-white px-3 py-2 rounded"
    bubble.textContent = text

    wrapper.appendChild(bubble)
    row.appendChild(wrapper)
    messages.appendChild(row)
  }

  removeSubsequent() {
    const messageRow = this.element.closest('[id^="message_"]')
    if (!messageRow) return

    let sibling = messageRow.nextElementSibling
    while (sibling) {
      const next = sibling.nextElementSibling
      if (sibling.id?.startsWith("message_")) sibling.remove()
      sibling = next
    }
  }

  showOptimisticEdit() {
    const textarea = this.element.querySelector("textarea")
    const messageRow = this.element.closest('[id^="message_"]')
    if (!textarea || !messageRow) return

    const text = textarea.value.trim()
    if (!text) return

    const display = messageRow.querySelector('[data-message-edit-target="display"]')
    if (display) {
      display.textContent = text
      display.classList.remove("d-none")
    }
    this.element.classList.add("d-none")
  }
}
