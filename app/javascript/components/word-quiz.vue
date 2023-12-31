<template>
  <div class="flex justify-center">
    <div class="w-full px-2.5 sm:w-10/12">
      <WordQuizResult
        v-if="isResult"
        :number-of-quiz-resources="numberOfResources"
        :raw-quiz-resources="rawQuizResources"
        :userAnswers="userAnswersList"></WordQuizResult>
      <div v-else>
        <p class="inline font-bold text-lg tracking-widest">
          {{ $t('quiz.question') }}
        </p>
        <p
          class="inline float-right count-questions text-right mr-5 tracking-wide">
          {{ currentQuestion }} / {{ numberOfResources }}
        </p>
        <div class="h-56">
          <template
            v-for="(quizResource, index) in quizResources"
            :key="quizResource">
            <p
              v-if="currentIndex === index"
              class="content-of-question border border-darklavender-200 bg-darklavender-50 rounded py-2 px-4 mt-2 h-44 overflow-y-auto">
              {{ quizResource.explanation }}
            </p>
          </template>
        </div>
        <label for="userAnswer" class="font-bold">{{
          $t('quiz.inputTheAnswer')
        }}</label>
        <input
          v-if="!answered"
          v-model="userAnswer"
          ref="input"
          class="border-2 border-gray-400 rounded w-full h-9 pl-4 mb-3"
          id="userAnswer" />
        <p
          v-else
          class="border-2 border-gray-400 rounded w-full h-9 flex items-center pl-4 mb-3">
          {{ this.userAnswer }}
        </p>
        <div class="flex justify-center font-extrabold text-lg">
          <p v-if="answered && isCorrect">
            <span class="text-blue-600 text-xl font-black">◯</span>
            {{ $t('quiz.correct') }}!
          </p>
          <p v-else-if="answered && !this.userAnswer">
            <span class="text-red-600 text-xl">×</span>
            正解は{{ correctAnswer }}です
          </p>
          <p v-else-if="answered && !isCorrect">
            <span class="text-red-600 text-xl">×</span>
            {{ $t('quiz.wrong') }} 正解は{{ correctAnswer }}です
          </p>
        </div>
        <div class="flex justify-center">
          <div
            v-if="isLastQuestion && answered"
            class="flex flex-col grid justify-items-center w-3/5 mt-7">
            <p class="font-semibold text-sm pb-1">{{ $t('quiz.completed') }}</p>
            <button
              @click="getResult"
              class="rounded font-bold py-2 px-3.5 sm:px-10 bg-darklavender-200 hover:bg-darklavender-600 hover:text-white">
              {{ $t('quiz.resultButton') }}
            </button>
          </div>
          <div v-else-if="answered" class="mt-3">
            <button
              @click="getNextQuestion"
              class="rounded bg-darklavender-200 font-bold py-2 px-10 hover:bg-darklavender-600 hover:text-white">
              {{ $t('quiz.next') }}
            </button>
          </div>
          <div v-else class="mt-3">
            <button
              @click="onSubmit"
              class="rounded bg-darklavender-200 font-bold py-2 px-10 hover:bg-darklavender-600 hover:text-white">
              {{ $t('quiz.submit') }}
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import WordQuizResult from './word-quiz-result.vue'

export default {
  name: 'WordQuiz',
  props: {
    path: {
      type: String
    }
  },
  components: {
    WordQuizResult
  },
  data() {
    return {
      currentQuestion: 1,
      userAnswer: '',
      userAnswersList: [],
      quizResources: [],
      rawQuizResources: [],
      numberOfResources: 0,
      currentIndex: 0,
      correctAnswer: '',
      answered: false,
      isCorrect: '',
      isLastQuestion: false,
      isResult: false,
      expressionId: 0
    }
  },
  methods: {
    onSubmit() {
      this.getCorrectAnswer()
      this.answered = true
      this.isCorrect = this.checkUserAnswer()
      this.createUserAnswersList()
    },
    getNextQuestion() {
      this.answered = false
      this.currentIndex = this.currentIndex + 1
      this.currentQuestion = this.currentIndex + 1
      this.checkQuestionIndex()
      this.userAnswer = ''
      this.correctAnswer = ''
      this.$nextTick(() => this.$refs.input.focus({ preventScroll: true }))
    },
    getResult() {
      this.isResult = true
    },
    async fetchQuizResources() {
      const quizResources = await fetch(this.path, {
        method: 'GET',
        headers: { 'X-Requested-With': 'XMLHttpRequest' },
        credentials: 'same-origin'
      })
      return quizResources.json()
    },
    setupQuiz() {
      this.fetchQuizResources().then((response) => {
        this.quizResources = response
        this.rawQuizResources = response
        this.numberOfResources = this.quizResources.length
        this.orderQuestions(this.numberOfResources)
      })
    },
    getCorrectAnswer() {
      const currentQuiz = this.quizResources[this.currentIndex]
      this.correctAnswer = currentQuiz.content
      this.expressionId = currentQuiz.expressionId
    },
    checkUserAnswer() {
      return this.userAnswer.toLowerCase() === this.correctAnswer.toLowerCase()
    },
    checkQuestionIndex() {
      const lastIndex = this.quizResources.length - 1
      if (this.currentIndex !== lastIndex) return
      this.isLastQuestion = true
    },
    createUserAnswersList() {
      if (this.isCorrect) {
        this.userAnswersList.push({
          content: [`◯ ${this.userAnswer}`],
          expressionId: this.expressionId
        })
      } else {
        this.userAnswersList.push({
          content: [
            `× ${this.userAnswer}`,
            `( Answer: ${this.correctAnswer} )`
          ],
          expressionId: this.expressionId
        })
      }
    },
    orderQuestions(quizLength) {
      const numbers = []
      while (numbers.length < quizLength) {
        const randomNumber = Math.floor(Math.random() * (quizLength - 0))
        if (!numbers.includes(randomNumber)) numbers.push(randomNumber)
      }
      const orderedQuizResources = []
      numbers.forEach((number) =>
        orderedQuizResources.push(this.quizResources[number])
      )
      this.quizResources = orderedQuizResources
    }
  },
  mounted() {
    this.setupQuiz()
    this.$refs.input.focus({ preventScroll: true })
  }
}
</script>
