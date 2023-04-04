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
          const attribute = element.dataset
          const i18n = createI18n({
            locale: 'ja',
            messages: ja
          })
          const app = createApp(component, this._convertProps(attribute))
          app.use(i18n)
          app.component('font-awesome-icon', FontAwesomeIcon)
          app.mount(`[data-vue=${name}]`)
        })
      }
    })
  }

  _convertProps(props) {
    const objects = {}

    Object.keys(props)
      .filter((key) => key.match(/^vue.+/g))
      .forEach((key) => {
        const rawKey = key.replace(/^vue/, '')
        const keyWithType = this._toCamelCase(rawKey)
        const matches = keyWithType.match(/:(.+)$/)
        const type = matches ? matches[1] : undefined
        const propKey = matches ? keyWithType.replace(/:.+$/, '') : keyWithType
        const value = matches ? this._parse(props[key], type) : props[key]

        objects[propKey] = value
      })
    return objects
  }

  _toCamelCase(prop) {
    return prop.charAt(0).toLowerCase() + prop.slice(1)
  }

  _parse(value, type) {
    if (type === 'number') {
      return Number(value)
    } else if (type === 'boolean') {
      const v = value.toLowerCase()
      if (v === 'false' || v === 'nil' || v === '') {
        return false
      } else {
        return true
      }
    } else if (type === 'string') {
      return String(value)
    } else if (type === 'json') {
      return JSON.parse(value)
    } else {
      return value
    }
  }
}
