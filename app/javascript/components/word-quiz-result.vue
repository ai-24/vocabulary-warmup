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
  <div class="py-8">
    <div
      v-if="listOfWrongItems.length > 0"
      class="section-of-wrong-answers py-2.5">
      <input
        type="checkbox"
        id="move-to-bookmark"
        v-model="isCheckedAllToBookmark"
        @change="changeStatus('bookmark')" />
      <label for="move-to-bookmark">{{ $t('quiz.result.bookmark') }}</label>
      <details>
        <summary>{{ $t('quiz.result.bookmarkList') }}</summary>
        <ul class="list-of-wrong-answers">
          <li v-for="(item, index) in listOfWrongItems" :key="item">
            <input
              type="checkbox"
              :id="`wrong-expression${index}`"
              :value="item"
              v-model="checkedContentsToBookmark"
              @change="isCheckedAll('bookmark')" />
            <label :for="`wrong-expression${index}`">{{ item.content }}</label>
          </li>
        </ul>
      </details>
    </div>
    <div
      v-if="listOfCorrectItems.length > 0"
      class="section-of-correct-answers py-2.5">
      <input
        type="checkbox"
        id="move-to-memorised-list"
        v-model="isCheckedAllToMemorisedList"
        @change="changeStatus('memorisedList')" />
      <label for="move-to-memorised-list">{{
        $t('quiz.result.moveToMemorisedWordsList')
      }}</label>
      <details>
        <summary>{{ $t('quiz.result.memorisedWordsList') }}</summary>
        <ul class="list-of-correct-answers">
          <li v-for="(item, index) in listOfCorrectItems" :key="item">
            <input
              type="checkbox"
              :id="`correct-expression${index}`"
              :value="item"
              v-model="checkedContentsToMemorisedList"
              @change="isCheckedAll('memorisedList')" />
            <label :for="`correct-expression${index}`">{{
              item.content
            }}</label>
          </li>
        </ul>
      </details>
    </div>
    <button>{{ $t('quiz.result.save') }}</button>
  </div>
  <details>
    <summary>{{ $t('quiz.result.showUserAnswers') }}</summary>
    <ul class="user-answer-list">
      <template v-for="userAnswer in userAnswers" :key="userAnswer">
        <li v-if="userAnswer.content[0] === '× '">
          × {{ $t('quiz.result.blank') }}
          {{ userAnswer.content[1] }}
        </li>
        <li v-else>
          {{ userAnswer.content[0] }}
          <div v-if="userAnswer.content[1]" class="inline">
            {{ userAnswer.content[1] }}
          </div>
        </li>
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
      wrongExpressionIds: [],
      listOfCorrectItems: [],
      listOfWrongItems: [],
      checkedContentsToBookmark: [],
      checkedContentsToMemorisedList: [],
      isCheckedAllToBookmark: true,
      isCheckedAllToMemorisedList: true
    }
  },
  methods: {
    isCheckedAll(type) {
      if (type === 'bookmark') {
        this.isCheckedAllToBookmark =
          this.checkedContentsToBookmark.length === this.listOfWrongItems.length
      } else if (type === 'memorisedList') {
        this.isCheckedAllToMemorisedList =
          this.checkedContentsToMemorisedList.length ===
          this.listOfCorrectItems.length
      }
    },
    changeStatus(type) {
      if (type === 'bookmark') {
        this.checkedContentsToBookmark.length = 0
        if (this.isCheckedAllToBookmark)
          this.defaultCheckbox(
            this.checkedContentsToBookmark,
            this.listOfWrongItems
          )
      } else if (type === 'memorisedList') {
        this.checkedContentsToMemorisedList.length = 0
        if (this.isCheckedAllToMemorisedList)
          this.defaultCheckbox(
            this.checkedContentsToMemorisedList,
            this.listOfCorrectItems
          )
      }
    },
    defaultCheckbox(checkedContents, items) {
      items.forEach((item) => checkedContents.push(item))
    },
    createListOfItems() {
      this.classifyUserAnswersByExpressionId()
      this.classifyExpressionGroupsByRightOrWrong()
      this.convertExpressionIds(this.allCorrectExpressionIds, 'correct')
      this.convertExpressionIds(this.wrongExpressionIds, 'wrong')
    },
    getNumberOfCorrectAnswers() {
      const correctAnswers = this.userAnswers.filter((userAnswer) =>
        userAnswer.content[0].match(/^◯.+/g)
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
          element.content[0].match(/^◯.+/g)
        )
        if (correctAnswers.length === expressionGroup.length) {
          this.allCorrectExpressionIds.push(expressionGroup[0].expressionId)
        } else {
          this.wrongExpressionIds.push(expressionGroup[0].expressionId)
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
        } else if (type === 'wrong') {
          this.listOfWrongItems.push({
            content: contents.join(' '),
            expressionId: expression[0].expressionId
          })
        }
      })
      this.sortItems(this.listOfCorrectItems)
      this.sortItems(this.listOfWrongItems)
    },
    sortItems(items) {
      items.sort((first, second) => first.expressionId - second.expressionId)
    }
  },
  mounted() {
    this.getNumberOfCorrectAnswers()
    this.createListOfItems()
    this.defaultCheckbox(this.checkedContentsToBookmark, this.listOfWrongItems)
    this.defaultCheckbox(
      this.checkedContentsToMemorisedList,
      this.listOfCorrectItems
    )
  }
}
</script>

<style scoped></style>
