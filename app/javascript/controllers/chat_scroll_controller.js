import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Scroll when opening an existing chat
    this.scrollToBottom()

    // Scroll whenever new messages are added
    this.observer = new MutationObserver(() => {
      this.scrollToBottom()
    })

    this.observer.observe(this.element, {
      childList: true,
      subtree: true
    })
  }

  disconnect() {
    if (this.observer) {
      this.observer.disconnect()
    }
  }

  scrollToBottom() {
    requestAnimationFrame(() => {
      this.element.scrollTop = this.element.scrollHeight
    })
  }
}
