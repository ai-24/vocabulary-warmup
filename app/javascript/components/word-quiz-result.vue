<template>
  <div class="pb-8">
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
  <div
    v-if="!isSaved && movableExpressionExists"
    class="move-to-bookmark-or-memorised-list pb-8">
    <div
      v-if="
        listOfWrongItems.length > 0 && !isSavedBookmark && !isBookmarkedList
      "
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
              :value="item.expressionId"
              v-model="checkedContentsToBookmark"
              @change="isCheckedAll('bookmark')" />
            <label :for="`wrong-expression${index}`">{{ item.content }}</label>
          </li>
        </ul>
      </details>
    </div>
    <div
      v-if="
        listOfCorrectItems.length > 0 &&
        !isSavedMemorisedList &&
        !isMemorisedList
      "
      class="section-of-correct-answers pt-2.5">
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
              :value="item.expressionId"
              v-model="checkedContentsToMemorisedList"
              @change="isCheckedAll('memorisedList')" />
            <label :for="`correct-expression${index}`">{{
              item.content
            }}</label>
          </li>
        </ul>
      </details>
    </div>
    <div v-if="unauthorized" class="mt-5 p-4 text-sm bg-rose-100">
      <p>
        <font-awesome-icon
          icon="fa-solid fa-triangle-exclamation"
          size="lg"
          class="mr-1" />{{ $t('quiz.result.unauthorizedTitle') }}
      </p>
      <p class="mt-1">{{ $t('quiz.result.unauthorizedSolution') }}</p>
    </div>
    <button class="pt-2.5" @click="save">{{ $t('quiz.result.save') }}</button>
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
    <div v-if="movableExpressionExists">
      <p>{{ $t('quiz.result.recommendNextAction') }}</p>
      <p class="text-red-600">{{ $t('quiz.result.important') }}</p>
    </div>
    <a>{{ $t('quiz.result.review') }}</a>
  </div>
  <button @click="getNewQuiz">{{ $t('quiz.result.tryAgain') }}</button>
</template>

<script>
import { useToast } from 'vue-toastification'

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
      isCheckedAllToMemorisedList: true,
      isSaved: false,
      isSavedBookmark: false,
      isSavedMemorisedList: false,
      toast: useToast(),
      success: [],
      warning: false,
      failure: [],
      unauthorized: false,
      isBookmarkedList: this.isBookmarkedExpressionsPath(),
      isMemorisedList: this.isMemorisedExpressionsPath(),
      movableExpressionExists: true
    }
  },
  methods: {
    xCsrfToken() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    async createBookmarksOrMemorisedList(path, expressionIds) {
      const url = `/api/${path}_expressions`
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json; charset=utf-8',
          'X-Requested-With': 'XMLHttpRequest',
          'X-CSRF-Token': this.xCsrfToken()
        },
        credentials: 'same-origin',
        redirect: 'manual',
        body: JSON.stringify({ expression_id: expressionIds })
      })
      return response
    },
    showToast() {
      const warning = this.createWarning()
      if (this.success[0] === 'bookmarked_expressions') {
        this.toast.success(`ブックマークしました！${warning}`)
      } else if (this.success[0] === 'memorised_expressions') {
        this.toast.success(
          `英単語・フレーズを覚えた語彙リストに保存しました！${warning}`
        )
      } else if (this.failure[0] === 'bookmarked_expressions') {
        this.toast.error('ブックマークできませんでした')
      } else if (this.failure[0] === 'memorised_expressions') {
        this.toast.error(
          '覚えた語彙リストに英単語・フレーズを保存できませんでした'
        )
      }
    },
    checkResponse(response) {
      const bookmark = response.url.match(/bookmarked_expressions$/g)
      const memorisedList = response.url.match(/memorised_expressions$/g)
      const bookmarkOrMemorisedList = bookmark || memorisedList
      if (response.status === 204) {
        this.success.push(...bookmarkOrMemorisedList)
      } else if (response.status === 201) {
        this.success.push(...bookmarkOrMemorisedList)
        this.warning = true
      } else if (response.status === 401) {
        this.unauthorized = true
      } else {
        this.failure.push(...bookmarkOrMemorisedList)
      }
    },
    resetCheckResponse() {
      this.success = []
      this.failure = []
      this.warning = false
    },
    createWarning() {
      return this.warning
        ? '\n(存在が確認できなかった英単語・フレーズを除く)'
        : ''
    },
    save() {
      if (
        this.checkedContentsToBookmark.length > 0 &&
        this.checkedContentsToMemorisedList.length > 0
      ) {
        Promise.all([
          this.createBookmarksOrMemorisedList(
            'bookmarked',
            this.checkedContentsToBookmark
          ),
          this.createBookmarksOrMemorisedList(
            'memorised',
            this.checkedContentsToMemorisedList
          )
        ]).then((responses) => {
          responses.forEach((response) => {
            this.checkResponse(response)
          })
          const warning = this.createWarning()
          if (this.failure.length === 2) {
            this.toast.error(
              'ブックマーク・覚えた語彙リストに英単語・フレーズを保存できませんでした'
            )
          } else if (this.success.length === 2) {
            this.isSaved = true
            this.toast.success(
              `ブックマーク・覚えた語彙リストに英単語・フレーズを保存しました！${warning}`
            )
          } else if (
            this.failure[0] === 'bookmarked_expressions' &&
            this.success[0] === 'memorised_expressions'
          ) {
            this.isSavedMemorisedList = true
            this.checkedContentsToMemorisedList = []
            this.toast.warning(
              `覚えた語彙リストに英単語・フレーズを保存しました${warning}がブックマークは出来ませんでした`
            )
          } else if (
            this.failure[0] === 'memorised_expressions' &&
            this.success[0] === 'bookmarked_expressions'
          ) {
            this.isSavedBookmark = true
            this.checkedContentsToBookmark = []
            this.toast.warning(
              `英単語・フレーズをブックマークしました${warning}が覚えた語彙リストには保存できませんでした`
            )
          }
          this.resetCheckResponse()
        })
      } else if (this.checkedContentsToBookmark.length > 0) {
        this.createBookmarksOrMemorisedList(
          'bookmarked',
          this.checkedContentsToBookmark
        ).then((response) => {
          this.checkResponse(response)
          if (this.success.length > 0) this.isSaved = true
          this.showToast()
          this.resetCheckResponse()
        })
      } else if (this.checkedContentsToMemorisedList.length > 0) {
        this.createBookmarksOrMemorisedList(
          'memorised',
          this.checkedContentsToMemorisedList
        ).then((response) => {
          this.checkResponse(response)
          if (this.success.length > 0) this.isSaved = true
          this.showToast()
          this.resetCheckResponse()
        })
      }
    },
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
      items.forEach((item) => checkedContents.push(item.expressionId))
    },
    createListOfItems() {
      this.classifyUserAnswersByExpressionId()
      this.classifyExpressionGroupsByRightOrWrong()
      if (!this.isMemorisedList) {
        this.convertExpressionIds(this.allCorrectExpressionIds, 'correct')
      }
      if (!this.isBookmarkedList) {
        this.convertExpressionIds(this.wrongExpressionIds, 'wrong')
      }
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

        const expressionItems = this.rawQuizResources.filter(
          (quizResource) => quizResource.expressionId === id
        )
        const lastIndex = expressionItems.length - 1
        expressionItems.forEach((expressionItem, index) => {
          if (index === lastIndex) {
            contents.push(`and ${expressionItem.content}`)
          } else if (expressionItems.length > 2 && index !== lastIndex - 1) {
            contents.push(`${expressionItem.content},`)
          } else {
            contents.push(expressionItem.content)
          }
        })
        if (type === 'correct') {
          this.listOfCorrectItems.push({
            content: contents.join(' '),
            expressionId: expressionItems[0].expressionId
          })
        } else if (type === 'wrong') {
          this.listOfWrongItems.push({
            content: contents.join(' '),
            expressionId: expressionItems[0].expressionId
          })
        }
      })
      if (!this.isMemorisedList) this.sortItems(this.listOfCorrectItems)
      if (!this.isBookmarkedList) this.sortItems(this.listOfWrongItems)
    },
    sortItems(items) {
      items.sort((first, second) => first.expressionId - second.expressionId)
    },
    isBookmarkedExpressionsPath() {
      return location.pathname === '/bookmarked_expressions/quiz'
    },
    isMemorisedExpressionsPath() {
      return location.pathname === '/memorised_expressions/quiz'
    },
    checkExistenceOfMovableExpressions() {
      if (
        (this.isBookmarkedList && this.listOfCorrectItems.length === 0) ||
        (this.isMemorisedList && this.listOfWrongItems.length === 0)
      ) {
        this.movableExpressionExists = false
      }
    }
  },
  mounted() {
    this.getNumberOfCorrectAnswers()
    this.createListOfItems()
    if (!this.isBookmarkedList) {
      this.defaultCheckbox(
        this.checkedContentsToBookmark,
        this.listOfWrongItems
      )
    }
    if (!this.isMemorisedList) {
      this.defaultCheckbox(
        this.checkedContentsToMemorisedList,
        this.listOfCorrectItems
      )
    }
    this.checkExistenceOfMovableExpressions()
  }
}
</script>

<style scoped></style>
