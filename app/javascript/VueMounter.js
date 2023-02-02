import { createApp } from 'vue'

export default class VueMounter {
  constructor() {
    this.components = {}
  }

  addComponent(component) {
    const name = component.name
    this.components[name] = component
  }

  mount() {
    document.addEventListener('DOMContentLoaded', () => {
      const elements = document.querySelectorAll('div[data-vue]')
      if (elements.length > 0) {
        elements.forEach((element) => {
          const name = element.dataset.vue
          const component = this.components[name]

          createApp(component).mount(`[data-vue=${name}]`)
        })
      }
    })
  }
}
