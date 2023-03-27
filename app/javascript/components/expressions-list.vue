<template>
  <ul>
    <li
      v-for="expressionsResource in expressionsResources"
      :key="expressionsResource.id">
      <a :href="`/expressions/${expressionsResource.id}`">{{
        titles[expressionsResource.id]
      }}</a>
    </li>
  </ul>
</template>

<script>
export default {
  name: 'ExpressionsList',
  data() {
    return {
      expressionsResources: [],
      titles: []
    }
  },
  methods: {
    async fetchExpressionsResources() {
      const expressionsResources = await fetch('api/expressions', {
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
    this.setupExpressions()
  }
}
</script>

<style scoped></style>
