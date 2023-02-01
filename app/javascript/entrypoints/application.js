// Load Rails libraries in Vite.
import * as Turbo from '@hotwired/turbo'
// Import a stylesheet
import '../../assets/stylesheets/application.tailwind.css'

Turbo.start()

// Example
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.globEager('./**/*_channel.js')

console.log('Vite ⚡️ Rails')

console.log(
  'Visit the guide for more information: ',
  'https://vite-ruby.netlify.app/guide/rails'
)
