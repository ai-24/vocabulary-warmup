<template>
  <div class="grid justify-items-stretch place-content-center">
    <ExpressionsFormStepNavigation
      :current-page="currentPage"
      :previous-page="previousPage"
      :completed-step2="completedStep2"></ExpressionsFormStepNavigation>

    <form accept-charset="UTF-8" :action="url" method="POST">
      <input v-if="expressionId" name="_method" type="hidden" value="put" />
      <div v-show="currentPage === 1">
        <p>{{ $t('form.expressions') }}</p>
        <p v-if="expressionsError" class="text-red-600">
          {{ $t('form.expressionsError') }}
        </p>
        <ul>
          <li>
            <label for="first-expression">{{
              $t('form.firstExpression')
            }}</label>
            <input
              v-if="expressionItemId[0]"
              type="hidden"
              name="expression[expression_items_attributes][0][id]"
              :value="expressionItemId[0].firstExpression" />
            <input
              id="first-expression"
              name="expression[expression_items_attributes][0][content]"
              v-model="firstExpression"
              placeholder="First word" />
          </li>
          <li>
            <label for="second-expression">{{
              $t('form.secondExpression')
            }}</label>
            <input
              v-if="expressionItemId[1]"
              type="hidden"
              name="expression[expression_items_attributes][1][id]"
              :value="expressionItemId[1].secondExpression" />
            <input
              id="second-expression"
              name="expression[expression_items_attributes][1][content]"
              v-model="secondExpression"
              placeholder="Second word" />
          </li>
          <li>
            <label for="third-expression">{{
              $t('form.thirdExpression')
            }}</label>
            <input
              v-if="expressionItemId[2]"
              type="hidden"
              name="expression[expression_items_attributes][2][id]"
              :value="expressionItemId[2].thirdExpression" />
            <input
              id="third-expression"
              name="expression[expression_items_attributes][2][content]"
              v-model="thirdExpression"
              placeholder="Third word (Optional)" />
          </li>
          <li>
            <label for="fourth-expression">{{
              $t('form.fourthExpression')
            }}</label>
            <input
              v-if="expressionItemId[3]"
              type="hidden"
              name="expression[expression_items_attributes][3][id]"
              :value="expressionItemId[3].fourthExpression" />
            <input
              id="fourth-expression"
              name="expression[expression_items_attributes][3][content]"
              v-model="fourthExpression"
              placeholder="Fourth word (Optional)" />
          </li>
          <li>
            <label for="fifth-expression">{{
              $t('form.fifthExpression')
            }}</label>
            <input
              v-if="expressionItemId[4]"
              type="hidden"
              name="expression[expression_items_attributes][4][id]"
              :value="expressionItemId[4].fifthExpression" />
            <input
              id="fifth-expression"
              name="expression[expression_items_attributes][4][content]"
              v-model="fifthExpression"
              placeholder="Fifth word (Optional)" />
          </li>
        </ul>
        <button type="button" @click="getSecondPage">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 2">
        <h1>{{ $t('form.about', { word: firstExpression }) }}</h1>
        <div v-if="explanationError" class="text-red-600">
          <label for="explanation-of-first-expression">{{
            $t('form.explanation', {
              word: firstExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <div v-else>
          <label for="explanation-of-first-expression">{{
            $t('form.explanation', {
              word: firstExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <textarea
          id="explanation-of-first-expression"
          name="expression[expression_items_attributes][0][explanation]"
          rows="3"
          class="w-full"
          v-model="firstExpressionDetails.explanation"
          :placeholder="$t('form.notice')"></textarea>
        <p>{{ $t('form.example') }}</p>
        <ul>
          <li>
            <label for="first-example-of-first-expression">{{
              $t('form.firstExample')
            }}</label>
            <input
              v-if="exampleId.firstExpression[0]"
              type="hidden"
              name="expression[expression_items_attributes][0][examples_attributes][0][id]"
              :value="exampleId.firstExpression[0].firstExample" />
            <input
              id="first-example-of-first-expression"
              name="expression[expression_items_attributes][0][examples_attributes][0][content]"
              class="w-full"
              v-model="firstExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-first-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              v-if="exampleId.firstExpression[1]"
              type="hidden"
              name="expression[expression_items_attributes][0][examples_attributes][1][id]"
              :value="exampleId.firstExpression[1].secondExample" />
            <input
              id="second-example-of-first-expression"
              name="expression[expression_items_attributes][0][examples_attributes][1][content]"
              class="w-full"
              v-model="firstExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-first-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              v-if="exampleId.firstExpression[2]"
              type="hidden"
              name="expression[expression_items_attributes][0][examples_attributes][2][id]"
              :value="exampleId.firstExpression[2].thirdExample" />
            <input
              id="third-example-of-first-expression"
              name="expression[expression_items_attributes][0][examples_attributes][2][content]"
              class="w-full"
              v-model="firstExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getFirstPage">{{ $t('back') }}</button>
        <button type="button" @click="getThirdPage">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 3">
        <h1>{{ $t('form.about', { word: secondExpression }) }}</h1>
        <div v-if="explanationError" class="text-red-600">
          <label for="explanation-of-second-expression">{{
            $t('form.explanation', {
              word: secondExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <div v-else>
          <label for="explanation-of-second-expression">{{
            $t('form.explanation', {
              word: secondExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <textarea
          id="explanation-of-second-expression"
          name="expression[expression_items_attributes][1][explanation]"
          rows="3"
          class="w-full"
          v-model="secondExpressionDetails.explanation"
          :placeholder="$t('form.notice')"></textarea>
        <p>{{ $t('form.example') }}</p>
        <ul>
          <li>
            <label for="first-example-of-second-expression">{{
              $t('form.firstExample')
            }}</label>
            <input
              v-if="exampleId.secondExpression[0]"
              type="hidden"
              name="expression[expression_items_attributes][1][examples_attributes][0][id]"
              :value="exampleId.secondExpression[0].firstExample" />
            <input
              id="first-example-of-second-expression"
              name="expression[expression_items_attributes][1][examples_attributes][0][content]"
              class="w-full"
              v-model="secondExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-second-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              v-if="exampleId.secondExpression[1]"
              type="hidden"
              name="expression[expression_items_attributes][1][examples_attributes][1][id]"
              :value="exampleId.secondExpression[1].secondExample" />
            <input
              id="second-example-of-second-expression"
              name="expression[expression_items_attributes][1][examples_attributes][1][content]"
              class="w-full"
              v-model="secondExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-second-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              v-if="exampleId.secondExpression[2]"
              type="hidden"
              name="expression[expression_items_attributes][1][examples_attributes][2][id]"
              :value="exampleId.secondExpression[2].thirdExample" />
            <input
              id="third-example-of-second-expression"
              name="expression[expression_items_attributes][1][examples_attributes][2][content]"
              class="w-full"
              v-model="secondExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getSecondPage">{{ $t('back') }}</button>
        <button
          v-if="expressionsAmount > 2"
          type="button"
          @click="getFourthPage">
          {{ $t('form.next') }}
        </button>
        <button
          v-else
          type="button"
          @click="getSevenPage(secondExpressionDetails.explanation)">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 4">
        <h1>{{ $t('form.about', { word: thirdExpression }) }}</h1>
        <div v-if="explanationError" class="text-red-600">
          <label for="explanation-of-third-expression">{{
            $t('form.explanation', {
              word: thirdExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <div v-else>
          <label for="explanation-of-third-expression">{{
            $t('form.explanation', {
              word: thirdExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <textarea
          id="explanation-of-third-expression"
          name="expression[expression_items_attributes][2][explanation]"
          rows="3"
          class="w-full"
          v-model="thirdExpressionDetails.explanation"
          :placeholder="$t('form.notice')"></textarea>
        <p>{{ $t('form.example') }}</p>
        <ul>
          <li>
            <label for="first-example-of-third-expression">{{
              $t('form.firstExample')
            }}</label>
            <input
              v-if="exampleId.thirdExpression[0]"
              type="hidden"
              name="expression[expression_items_attributes][2][examples_attributes][0][id]"
              :value="exampleId.thirdExpression[0].firstExample" />
            <input
              id="first-example-of-third-expression"
              name="expression[expression_items_attributes][2][examples_attributes][0][content]"
              class="w-full"
              v-model="thirdExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-third-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              v-if="exampleId.thirdExpression[1]"
              type="hidden"
              name="expression[expression_items_attributes][2][examples_attributes][1][id]"
              :value="exampleId.thirdExpression[1].secondExample" />
            <input
              id="second-example-of-third-expression"
              name="expression[expression_items_attributes][2][examples_attributes][1][content]"
              class="w-full"
              v-model="thirdExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-third-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              v-if="exampleId.thirdExpression[2]"
              type="hidden"
              name="expression[expression_items_attributes][2][examples_attributes][2][id]"
              :value="exampleId.thirdExpression[2].thirdExample" />
            <input
              id="third-example-of-third-expression"
              name="expression[expression_items_attributes][2][examples_attributes][2][content]"
              class="w-full"
              v-model="thirdExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getThirdPage">{{ $t('back') }}</button>
        <button
          v-if="expressionsAmount > 3"
          type="button"
          @click="getFifthPage">
          {{ $t('form.next') }}
        </button>
        <button
          v-else
          type="button"
          @click="getSevenPage(thirdExpressionDetails.explanation)">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 5">
        <h1>{{ $t('form.about', { word: fourthExpression }) }}</h1>
        <div v-if="explanationError" class="text-red-600">
          <label for="explanation-of-fourth-expression">{{
            $t('form.explanation', {
              word: fourthExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <div v-else>
          <label for="explanation-of-fourth-expression">{{
            $t('form.explanation', {
              word: fourthExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <textarea
          id="explanation-of-fourth-expression"
          name="expression[expression_items_attributes][3][explanation]"
          rows="3"
          class="w-full"
          v-model="fourthExpressionDetails.explanation"
          :placeholder="$t('form.notice')"></textarea>
        <p>{{ $t('form.example') }}</p>
        <ul>
          <li>
            <label for="first-example-of-fourth-expression">{{
              $t('form.firstExample')
            }}</label>
            <input
              v-if="exampleId.fourthExpression[0]"
              type="hidden"
              name="expression[expression_items_attributes][3][examples_attributes][0][id]"
              :value="exampleId.fourthExpression[0].firstExample" />
            <input
              id="first-example-of-fourth-expression"
              name="expression[expression_items_attributes][3][examples_attributes][0][content]"
              class="w-full"
              v-model="fourthExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-fourth-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              v-if="exampleId.fourthExpression[1]"
              type="hidden"
              name="expression[expression_items_attributes][3][examples_attributes][1][id]"
              :value="exampleId.fourthExpression[1].secondExample" />
            <input
              id="second-example-of-fourth-expression"
              name="expression[expression_items_attributes][3][examples_attributes][1][content]"
              class="w-full"
              v-model="fourthExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-fourth-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              v-if="exampleId.fourthExpression[2]"
              type="hidden"
              name="expression[expression_items_attributes][3][examples_attributes][2][id]"
              :value="exampleId.fourthExpression[2].thirdExample" />
            <input
              id="third-example-of-fourth-expression"
              name="expression[expression_items_attributes][3][examples_attributes][2][content]"
              class="w-full"
              v-model="fourthExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getFourthPage">{{ $t('back') }}</button>
        <button v-if="fifthExpression" type="button" @click="getSixPage">
          {{ $t('form.next') }}
        </button>
        <button
          v-else
          type="button"
          @click="getSevenPage(fourthExpressionDetails.explanation)">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 6">
        <h1>{{ $t('form.about', { word: fifthExpression }) }}</h1>
        <div v-if="explanationError" class="text-red-600">
          <label for="explanation-of-fifth-expression">{{
            $t('form.explanation', {
              word: fifthExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <div v-else>
          <label for="explanation-of-fifth-expression">{{
            $t('form.explanation', {
              word: fifthExpression,
              comparison: comparedExpressions
            })
          }}</label>
        </div>
        <textarea
          id="explanation-of-fifth-expression"
          name="expression[expression_items_attributes][4][explanation]"
          rows="3"
          class="w-full"
          v-model="fifthExpressionDetails.explanation"
          :placeholder="$t('form.notice')"></textarea>
        <p>{{ $t('form.example') }}</p>
        <ul>
          <li>
            <label for="first-example-of-fifth-expression">{{
              $t('form.firstExample')
            }}</label>
            <input
              v-if="exampleId.fifthExpression[0]"
              type="hidden"
              name="expression[expression_items_attributes][4][examples_attributes][0][id]"
              :value="exampleId.fifthExpression[0].firstExample" />
            <input
              id="first-example-of-fifth-expression"
              name="expression[expression_items_attributes][4][examples_attributes][0][content]"
              class="w-full"
              v-model="fifthExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-fifth-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              v-if="exampleId.fifthExpression[1]"
              type="hidden"
              name="expression[expression_items_attributes][4][examples_attributes][1][id]"
              :value="exampleId.fifthExpression[1].secondExample" />
            <input
              id="second-example-of-fifth-expression"
              name="expression[expression_items_attributes][4][examples_attributes][1][content]"
              class="w-full"
              v-model="fifthExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-fifth-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              v-if="exampleId.fifthExpression[2]"
              type="hidden"
              name="expression[expression_items_attributes][4][examples_attributes][2][id]"
              :value="exampleId.fifthExpression[2].thirdExample" />
            <input
              id="third-example-of-fifth-expression"
              name="expression[expression_items_attributes][4][examples_attributes][2][content]"
              class="w-full"
              v-model="fifthExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getFifthPage">{{ $t('back') }}</button>
        <button
          type="button"
          @click="getSevenPage(fifthExpressionDetails.explanation)">
          {{ $t('form.next') }}
        </button>
      </div>
      <div v-show="currentPage === 7">
        <ul>
          <li>
            <label for="note">{{ $t('form.note') }}</label>
            <textarea
              id="note"
              name="expression[note]"
              class="w-full"
              v-model="note"></textarea>
          </li>
          <li class="tags">
            <label for="tags">{{ $t('form.tags') }}</label>
            <div>
              <vue-tags-input
                id="tags"
                v-model="tag"
                :tags="tags"
                @tags-changed="updateTags"
                :placeholder="$t('form.howToUseTagInput')"></vue-tags-input>
              <ul>
                <li v-for="(tagValue, index) in tagsValue" :key="tagValue.id">
                  <input
                    type="hidden"
                    :name="`expression[tags_attributes][${index}][name]`"
                    :value="tagValue" />
                </li>
              </ul>
            </div>
          </li>
        </ul>
        <button v-if="previousPage === 3" type="button" @click="getThirdPage">
          {{ $t('back') }}
        </button>
        <button
          v-else-if="previousPage === 4"
          type="button"
          @click="getFourthPage">
          {{ $t('back') }}
        </button>
        <button
          v-else-if="previousPage === 5"
          type="button"
          @click="getFifthPage">
          {{ $t('back') }}
        </button>
        <button
          v-else-if="previousPage === 6"
          type="button"
          @click="getSixPage">
          {{ $t('back') }}
        </button>
        <button v-if="expressionId" type="submit" name="button">
          {{ $t('form.edit') }}
        </button>
        <button v-else>{{ $t('form.create') }}</button>
      </div>
    </form>
  </div>
</template>

<script>
import VueTagsInput from '@sipec/vue3-tags-input'
import ExpressionsFormStepNavigation from './expressions-form-step-navigation.vue'

export default {
  name: 'ExpressionsForm',
  components: {
    ExpressionsFormStepNavigation,
    VueTagsInput
  },
  props: {
    expressionId: {
      type: Number
    }
  },
  data() {
    return {
      currentPage: 1,
      previousPage: 0,
      firstExpression: '',
      secondExpression: '',
      thirdExpression: '',
      fourthExpression: '',
      fifthExpression: '',
      expressionsList: [],
      expressionsAmount: 0,
      firstExpressionDetails: {
        explanation: '',
        firstExample: '',
        secondExample: '',
        thirdExample: ''
      },
      secondExpressionDetails: {
        explanation: '',
        firstExample: '',
        secondExample: '',
        thirdExample: ''
      },
      thirdExpressionDetails: {
        explanation: '',
        firstExample: '',
        secondExample: '',
        thirdExample: ''
      },
      fourthExpressionDetails: {
        explanation: '',
        firstExample: '',
        secondExample: '',
        thirdExample: ''
      },
      fifthExpressionDetails: {
        explanation: '',
        firstExample: '',
        secondExample: '',
        thirdExample: ''
      },
      comparedExpressions: '',
      note: '',
      tag: '',
      tags: [],
      tagsValue: [],
      completedStep2: false,
      expressionsError: false,
      explanationError: false,
      url: '',
      expressionItemId: [],
      exampleId: {
        firstExpression: [],
        secondExpression: [],
        thirdExpression: [],
        fourthExpression: [],
        fifthExpression: []
      }
    }
  },
  methods: {
    async fetchExpressionResource() {
      const expressionResource = await fetch(
        `/api/expressions/${this.expressionId}/edit`,
        {
          method: 'GET',
          headers: { 'X-Requested-With': 'XMLHttpRequest' },
          credentials: 'same-origin'
        }
      )
      return expressionResource.json()
    },
    setupExpression() {
      this.fetchExpressionResource().then((response) => {
        this.expressionItemId = []
        response.expressionItems.forEach((expressionItem, index) => {
          if (index === 0) {
            this.firstExpression = expressionItem.expression
            this.getExpressionDetails(expressionItem, 'firstExpression')
            this.expressionItemId.push({ firstExpression: expressionItem.id })
          } else if (index === 1) {
            this.secondExpression = expressionItem.expression
            this.getExpressionDetails(expressionItem, 'secondExpression')
            this.expressionItemId.push({ secondExpression: expressionItem.id })
          } else if (index === 2) {
            this.thirdExpression = expressionItem.expression
            this.getExpressionDetails(expressionItem, 'thirdExpression')
            this.expressionItemId.push({ thirdExpression: expressionItem.id })
          } else if (index === 3) {
            this.fourthExpression = expressionItem.expression
            this.getExpressionDetails(expressionItem, 'fourthExpression')
            this.expressionItemId.push({ fourthExpression: expressionItem.id })
          } else if (index === 4) {
            this.fifthExpression = expressionItem.expression
            this.getExpressionDetails(expressionItem, 'fifthExpression')
            this.expressionItemId.push({ fifthExpression: expressionItem.id })
          }
        })
        this.note = response.note
        response.tags.forEach((tag) => {
          this.tags.push({ text: tag })
        })
      })
    },
    getUrl() {
      this.expressionId
        ? (this.url = `/expressions/${this.expressionId}`)
        : (this.url = '/expressions')
    },
    updateTags(newTags) {
      this.tags = newTags
      const tagsArray = newTags.map((tag) => {
        return tag.text
      })
      this.tagsValue = tagsArray
    },
    calculateExpressionsAmount() {
      this.expressionsList = []
      const expressions = [
        this.firstExpression,
        this.secondExpression,
        this.thirdExpression,
        this.fourthExpression,
        this.fifthExpression
      ]
      expressions.forEach((expression) => {
        if (expression) this.expressionsList.push(expression)
        this.expressionsAmount = this.expressionsList.length
      })
    },
    isExplanationError(explanation) {
      this.explanationError = false
      if (!explanation) this.explanationError = true
    },
    getFirstPage() {
      this.previousPage = this.currentPage
      this.currentPage = 1
    },
    getSecondPage() {
      this.previousPage = this.currentPage
      this.explanationError = false
      this.expressionsError = false
      this.comparedExpressions = ''
      this.getComparedExpressions([
        this.secondExpression,
        this.thirdExpression,
        this.fourthExpression,
        this.fifthExpression
      ])
      if (this.currentPage === 1) {
        if (this.firstExpression === '' || this.secondExpression === '')
          this.expressionsError = true
        const previousExpressionsAmount = this.expressionsAmount
        this.calculateExpressionsAmount()
        if (
          this.completedStep2 &&
          this.expressionsAmount !== previousExpressionsAmount
        ) {
          this.completedStep2 = false
        }
      }
      if (!this.expressionsError) this.currentPage = 2
    },
    getThirdPage() {
      this.previousPage = this.currentPage
      if (this.currentPage === 2) {
        this.isExplanationError(this.firstExpressionDetails.explanation)
      } else if (this.currentPage === 4) {
        this.explanationError = false
      }
      if (!this.explanationError) {
        this.comparedExpressions = ''
        this.getComparedExpressions([
          this.firstExpression,
          this.thirdExpression,
          this.fourthExpression,
          this.fifthExpression
        ])
        this.currentPage = 3
      }
    },
    getFourthPage() {
      this.previousPage = this.currentPage
      if (this.currentPage === 3) {
        this.isExplanationError(this.secondExpressionDetails.explanation)
      } else if (this.currentPage === 5) {
        this.explanationError = false
      }
      if (!this.explanationError) {
        this.comparedExpressions = ''
        this.getComparedExpressions([
          this.firstExpression,
          this.secondExpression,
          this.fourthExpression,
          this.fifthExpression
        ])
        this.currentPage = 4
      }
    },
    getFifthPage() {
      this.previousPage = this.currentPage
      if (this.currentPage === 4) {
        this.isExplanationError(this.thirdExpressionDetails.explanation)
      } else if (this.currentPage === 6) {
        this.explanationError = false
      }
      if (!this.explanationError) {
        this.comparedExpressions = ''
        this.getComparedExpressions([
          this.firstExpression,
          this.secondExpression,
          this.thirdExpression,
          this.fifthExpression
        ])
        this.currentPage = 5
      }
    },
    getSixPage() {
      this.previousPage = this.currentPage
      if (this.currentPage === 5)
        this.isExplanationError(this.fourthExpressionDetails.explanation)
      if (!this.explanationError) {
        this.comparedExpressions = ''
        this.getComparedExpressions([
          this.firstExpression,
          this.secondExpression,
          this.thirdExpression,
          this.fourthExpression
        ])
        this.currentPage = 6
      }
    },
    getSevenPage(explanation) {
      this.isExplanationError(explanation)
      this.previousPage = this.currentPage
      if (!this.explanationError) {
        this.completedStep2 = true
        this.currentPage = 7
      }
    },
    getComparedExpressions(expressionsList) {
      expressionsList.forEach((element) => {
        if (element) {
          const newComparedExpressionsList = this.comparedExpressions.concat(
            `${element}, `
          )
          this.comparedExpressions = newComparedExpressionsList
        }
      })
      const comparedExpressions = this.comparedExpressions.slice(0, -2)
      this.comparedExpressions = comparedExpressions
    },
    getExpressionDetails(expressionItem, specificExpression) {
      const expressionDetails = this.getSpecificExpression(specificExpression)
      expressionDetails.explanation = expressionItem.explanation
      let exampleId = ''
      if (specificExpression === 'firstExpression') {
        exampleId = this.exampleId.firstExpression
      } else if (specificExpression === 'secondExpression') {
        exampleId = this.exampleId.secondExpression
      } else if (specificExpression === 'thirdExpression') {
        exampleId = this.exampleId.thirdExpression
      } else if (specificExpression === 'fourthExpression') {
        exampleId = this.exampleId.fourthExpression
      } else if (specificExpression === 'fifthExpression') {
        exampleId = this.exampleId.fifthExpression
      }
      expressionItem.examples.forEach((example, index) => {
        if (index === 0) {
          exampleId.push({ firstExample: example[0] })
          expressionDetails.firstExample = example[1]
        } else if (index === 1) {
          exampleId.push({ secondExample: example[0] })
          expressionDetails.secondExample = example[1]
        } else if (index === 2) {
          exampleId.push({ thirdExample: example[0] })
          expressionDetails.thirdExample = example[1]
        }
      })
    },
    getSpecificExpression(specificExpression) {
      if (specificExpression === 'firstExpression') {
        return this.firstExpressionDetails
      } else if (specificExpression === 'secondExpression') {
        return this.secondExpressionDetails
      } else if (specificExpression === 'thirdExpression') {
        return this.thirdExpressionDetails
      } else if (specificExpression === 'fourthExpression') {
        return this.fourthExpressionDetails
      } else if (specificExpression === 'fifthExpression') {
        return this.fifthExpressionDetails
      }
    }
  },
  created() {
    this.getUrl()
    if (this.expressionId) {
      this.setupExpression()
    }
  }
}
</script>

<style scoped></style>
