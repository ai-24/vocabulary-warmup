<template>
  <p>{{ $t('quiz.result.showUserAnswers') }}</p>
  <ul>
    <div v-for="userAnswer in userAnswers" :key="userAnswer.id">
      <li v-if="userAnswer === '× '">× {{ $t('quiz.result.blank') }}</li>
      <li v-else>{{ userAnswer }}</li>
    </div>
  </ul>
</template>

<script>
export default {
  name: 'WordQuizResult',
  props: {
    userAnswers: {
      type: Array,
      required: true
    }
  }
}
</script>

<style scoped></style>
