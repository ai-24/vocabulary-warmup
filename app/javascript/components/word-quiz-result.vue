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
      <ul class="list-of-incorrect-answers">
        <li v-for="item in listOfIncorrectItems" :key="item">
          {{ item.content }}
        </li>
      </ul>
    </details>
    <input type="checkbox" />{{ $t('quiz.result.moveToMemorisedWordsList') }}
    <details>
      <summary>{{ $t('quiz.result.memorisedWordsList') }}</summary>
      <ul class="list-of-correct-answers">
        <li v-for="item in listOfCorrectItems" :key="item">
          {{ item.content }}
        </li>
      </ul>
    </details>
    <button>{{ $t('quiz.result.save') }}</button>
  </div>
  <details>
    <summary>{{ $t('quiz.result.showUserAnswers') }}</summary>
    <ul class="user-answer-list">
      <template v-for="userAnswer in userAnswers" :key="userAnswer">
        <li v-if="userAnswer.content === '× '">
          × {{ $t('quiz.result.blank') }}
        </li>
        <li v-else>{{ userAnswer.content }}</li>
      </template>
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
    },
    rawQuizResources: {
      type: Array,
      required: true
    }
  },
  data() {
    return {
      numberOfCorrectAnswers: 0,
      expressionGroups: [],
      allCorrectExpressionIds: [],
      incorrectExpressionIds: [],
      listOfCorrectItems: [],
      listOfIncorrectItems: []
    }
  },
  methods: {
    createListOfItems() {
      this.classifyUserAnswersByExpressionId()
      this.classifyExpressionGroupsByRightOrWrong()
      this.convertExpressionIds(this.allCorrectExpressionIds, 'correct')
      this.convertExpressionIds(this.incorrectExpressionIds, 'incorrect')
    },
    getNumberOfCorrectAnswers() {
      const correctAnswers = this.userAnswers.filter((userAnswer) =>
        userAnswer.content.match(/^◯.+/g)
      )
      this.numberOfCorrectAnswers = correctAnswers.length
    },
    getNewQuiz() {
      location.reload()
    },
    classifyUserAnswersByExpressionId() {
      const copyOfUserAnswers = this.userAnswers.slice()

      this.userAnswers.forEach((userAnswer) => {
        const groupOfExpression = copyOfUserAnswers.filter(
          (copyOfUserAnswer) =>
            userAnswer.expressionId === copyOfUserAnswer.expressionId
        )

        if (groupOfExpression.length) {
          this.expressionGroups.push(groupOfExpression)
          groupOfExpression.forEach((expressionItem) => {
            const i = copyOfUserAnswers.findIndex(
              (element) => element.expressionId === expressionItem.expressionId
            )
            copyOfUserAnswers.splice(i, 1)
          })
        }
      })
    },
    classifyExpressionGroupsByRightOrWrong() {
      this.expressionGroups.forEach((expressionGroup) => {
        const correctAnswers = expressionGroup.filter((element) =>
          element.content.match(/^◯.+/g)
        )
        if (correctAnswers.length === expressionGroup.length) {
          this.allCorrectExpressionIds.push(expressionGroup[0].expressionId)
        } else {
          this.incorrectExpressionIds.push(expressionGroup[0].expressionId)
        }
      })
    },
    convertExpressionIds(listOfExpressionIds, type) {
      listOfExpressionIds.forEach((id) => {
        const contents = []

        const expression = this.rawQuizResources.filter(
          (quizResource) => quizResource.expressionId === id
        )
        const lastIndex = expression.length - 1
        expression.forEach((expressionItem, index) => {
          if (index === lastIndex) {
            contents.push(`and ${expressionItem.content}`)
          } else if (expression.length > 2 && index !== lastIndex - 1) {
            contents.push(`${expressionItem.content},`)
          } else {
            contents.push(expressionItem.content)
          }
        })
        if (type === 'correct') {
          this.listOfCorrectItems.push({
            content: contents.join(' '),
            expressionId: expression[0].expressionId
          })
        } else if (type === 'incorrect') {
          this.listOfIncorrectItems.push({
            content: contents.join(' '),
            expressionId: expression[0].expressionId
          })
        }
      })
      this.sortItems(this.listOfCorrectItems)
      this.sortItems(this.listOfIncorrectItems)
    },
    sortItems(items) {
      items.sort((first,second) => first.expressionId - second.expressionId)
    }
  },
  mounted() {
    this.getNumberOfCorrectAnswers()
    this.createListOfItems()
  }
}
</script>

<style scoped></style>
