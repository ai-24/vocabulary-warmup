<template>
  <div class="grid justify-items-stretch place-content-center">
    <div class="w-96">
      <p>{{ $t('quiz.question') }}</p>
      <template
        v-for="(quizResource, index) in quizResources"
        :key="quizResource.id">
        <p v-if="currentIndex === index">
          {{ quizResource.explanation }}
        </p>
      </template>
      <input
        v-if="!answered"
        v-model="userAnswer"
        :placeholder="$t('quiz.placeholder')" />
      <p v-else>{{ this.userAnswer }}</p>
      <p v-if="answered && isCorrect">◯ {{ $t('quiz.correct') }}!</p>
      <p v-else-if="answered && !this.userAnswer">
        ×{{ $t('quiz.answer', { answer: this.correctAnswer }) }}
      </p>
      <p v-else-if="answered && !isCorrect">
        ×{{ $t('quiz.incorrect') }}
        {{ $t('quiz.answer', { answer: this.correctAnswer }) }}
      </p>
      <div>
        <div v-if="isLastQuestion && answered">
          <p>{{ $t('quiz.completed') }}</p>
          <button>
            {{ $t('quiz.result') }}
          </button>
        </div>
        <button v-else-if="answered" @click="getNextQuestion">
          {{ $t('quiz.next') }}
        </button>
        <button v-else @click="onSubmit">{{ $t('quiz.submit') }}</button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'WordQuiz',
  data() {
    return {
      userAnswer: '',
      quizResources: [],
      currentIndex: 0,
      correctAnswer: '',
      answered: false,
      isCorrect: '',
      isLastQuestion: false
    }
  },
  methods: {
    onSubmit() {
      this.getCorrectAnswer()
      this.answered = true
      this.isCorrect = this.checkUserAnswer()
    },
    getNextQuestion() {
      this.answered = false
      this.currentIndex = this.currentIndex + 1
      this.checkQuestionIndex()
      this.userAnswer = ''
      this.correctAnswer = ''
    },
    async fetchQuizResources() {
      const quizResources = await fetch('/api/quiz', {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin'
      })
      return quizResources.json()
    },
    setupQuiz() {
      this.fetchQuizResources().then((response) => {
        this.quizResources = response
      })
    },
    getCorrectAnswer() {
      const currentQuiz = this.quizResources[this.currentIndex]
      this.correctAnswer = currentQuiz.content
    },
    checkUserAnswer() {
      return this.userAnswer.toLowerCase() === this.correctAnswer.toLowerCase()
    },
    checkQuestionIndex() {
      const lastIndex = this.quizResources.length - 1
      if (this.currentIndex !== lastIndex) return
      this.isLastQuestion = true
    }
  },
  mounted() {
    this.setupQuiz()
  }
}
</script>

<style scoped></style>
