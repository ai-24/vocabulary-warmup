module.exports = {
  content: [
    './app/views/**/*.html.slim',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.vue'
  ],
  theme: {
    extend: {
      inset: {
        '1/5': '20%'
      },
      borderWidth: {
        6: '6px'
      },
      borderRadius: {
        half: '50%'
      },
      colors: {
        'golden-yellow': {
          50: '#FFFDF7',
          200: '#FFEFB7',
          400: '#FFE177',
          800: '#FFD12A'
        },
        red: {
          600: '#D83A84'
        },
        lavender: {
          10: '#F4EFF1',
          50: '#F7F1F6',
          400: '#E4D2E4',
          600: '#C8A2C8',
          800: '#C683C6'
        },
        darklavender: {
          50: '#F6F3F6',
          200: '#CCB7CC',
          600: '#AD8CAD',
          800: '#8D628D'
        },
        black: {
          900: '#444444'
        }
      },
      maxWidth: {
        800: '800px'
      }
    }
  }
}
