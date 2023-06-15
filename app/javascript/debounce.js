const debounce = (func, wait = 500) => {
  let timerId
  return function (...args) {
    if (timerId) {
      clearTimeout(timerId)
    }
    timerId = setTimeout(() => {
      func.apply(this, args)
    }, wait)
  }
}

export default debounce
