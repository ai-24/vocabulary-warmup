import vue from '@vitejs/plugin-vue'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from 'vite-plugin-full-reload'

export default defineConfig({
  plugins: [
    vue(),
    RubyPlugin(),
    FullReload(['config/routes.rb', 'app/views/**/*'])
  ]
})
