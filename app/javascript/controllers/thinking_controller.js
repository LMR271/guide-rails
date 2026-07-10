  import { Controller } from "@hotwired/stimulus"

  export default class extends Controller {
    static targets = ["spinner", "messages"]

    show() {
      this.messagesTarget.appendChild(this.spinnerTarget)
      this.spinnerTarget.classList.remove("d-none")
      this.spinnerTarget.classList.add("d-flex")
    }

    hide() {
      this.spinnerTarget.classList.remove("d-flex")
      this.spinnerTarget.classList.add("d-none")
    }
  }
