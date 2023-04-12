<template>
  <div>
    <p>{{ $t('quiz.result.wellDone') }}</p>
    <p>
      {{
        $t('quiz.result.numberOfCorrectAnswers', {
          totalQuestions: this.numberOfQuizResources,
          numberOfCorrectAnswers: this.numberOfCorrectAnswers
        })
      }}
    </p>
  </div>
  <div>
    <input type="checkbox" />{{ $t('quiz.result.bookmark') }}
    <details>
      <summary>{{ $t('quiz.result.bookmarkList') }}</summary>
    </details>
    <input type="checkbox" />{{ $t('quiz.result.moveToMemorisedWordsList') }}
    <details>
      <summary>{{ $t('quiz.result.memorisedWordsList') }}</summary>
    </details>
    <button>{{ $t('quiz.result.save') }}</button>
  </div>
  <details>
    <summary>{{ $t('quiz.result.showUserAnswers') }}</summary>
    <ul>
      <div v-for="userAnswer in userAnswers" :key="userAnswer.id">
        <li v-if="userAnswer === '× '">× {{ $t('quiz.result.blank') }}</li>
        <li v-else>{{ userAnswer }}</li>
      </div>
    </ul>
  </details>
  <div>
    <p>{{ $t('quiz.result.recommendNextAction') }}</p>
    <p class="text-red-600">{{ $t('quiz.result.important') }}</p>
    <a>{{ $t('quiz.result.review') }}</a>
  </div>
  <button @click="getNewQuiz">{{ $t('quiz.result.tryAgain') }}</button>
</template>

<script>
export default {
  name: 'WordQuizResult',
  props: {
    userAnswers: {
      type: Array,
      required: true
    },
    numberOfQuizResources: {
      type: Number,
      required: true
    }
  },
  data() {
    return {
      numberOfCorrectAnswers: 0
    }
  },
  methods: {
    getNumberOfCorrectAnswers() {
      const correctAnswers = this.userAnswers.filter((userAnswer) =>
        userAnswer.match(/^◯.+/g)
      )
      this.numberOfCorrectAnswers = correctAnswers.length
    },
    getNewQuiz() {
      location.reload()
    }
  },
  mounted() {
    this.getNumberOfCorrectAnswers()
  }
}
</script>

<style scoped></style>
