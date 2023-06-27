<template>
  <ul
    class="expressions-list border border-lavender-800 h-auto max-h-80 overflow-x-auto overflow-y-auto">
    <li
      v-for="expressionsResource in expressionsResources"
      :key="expressionsResource.id"
      class="expression py-2 px-3 border-b border-lavender-800 hover:bg-lavender-50 font-medium">
      <a :href="`/expressions/${expressionsResource.id}`">{{
        titles[expressionsResource.id]
      }}</a>
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
