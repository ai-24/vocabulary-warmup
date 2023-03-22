import { createApp } from 'vue'
import { createI18n } from 'vue-i18n'
import ja from './locales/ja.json'
import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import {
  faCircleCheck,
  faPenToSquare
} from '@fortawesome/free-regular-svg-icons'

library.add(faCircleCheck, faPenToSquare)

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

          const i18n = createI18n({
            locale: 'ja',
            messages: ja
          })
          const app = createApp(component)
          app.use(i18n)
          app.component('font-awesome-icon', FontAwesomeIcon)
          app.mount(`[data-vue=${name}]`)
        })
      }
    })
  }
}
