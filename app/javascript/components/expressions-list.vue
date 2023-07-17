<template>
  <ul
    class="expressions-list h-auto max-h-80 overflow-x-auto overflow-y-auto py-2">
    <li
      v-for="expressionsResource in expressionsResources"
      :key="expressionsResource.id"
      class="expression">
      <a
        class="block py-2 px-3 bg-white border-b-2 border-lavender-600 hover:bg-lavender-50 font-medium"
        :href="`/expressions/${expressionsResource.id}`"
        >{{ titles[expressionsResource.id] }}</a
      >
    </li>
  </ul>
</template>

<script>
export default {
  name: 'ExpressionsList',
  props: {
    path: {
      type: String
    },
    searchedExpressionsResources: {
      type: Array
    }
  },
  data() {
    return {
      expressionsResources: [],
      titles: []
    }
  },
  methods: {
    async fetchExpressionsResources() {
      const expressionsResources = await fetch(this.path, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin'
      })
      return expressionsResources.json()
    },
    setupExpressions() {
      this.fetchExpressionsResources().then((response) => {
        this.expressionsResources = response
        this.createTitles()
      })
    },
    createTitles() {
      this.expressionsResources.forEach((expressionsResource) => {
        const expressionItems = expressionsResource.expression_items
        const lastIndexOfExpressionItems = expressionItems.length - 1
        const expressionsGroup = []

        expressionItems.forEach((expressionItem, index) => {
          if (index === lastIndexOfExpressionItems) {
            expressionsGroup.push(`and ${expressionItem.expression}`)
          } else if (
            expressionItems.length > 2 &&
            index !== lastIndexOfExpressionItems - 1
          ) {
            expressionsGroup.push(`${expressionItem.expression},`)
          } else {
            expressionsGroup.push(expressionItem.expression)
          }
        })
        this.titles[expressionsResource.id] = expressionsGroup.join(' ')
      })
    }
  },
  mounted() {
    if (this.searchedExpressionsResources) {
      this.expressionsResources = this.searchedExpressionsResources
      this.createTitles()
    } else {
      this.setupExpressions()
    }
  }
}
</script>

<style scoped></style>
