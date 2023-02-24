<template>
  <div class="grid justify-items-stretch place-content-center">
    <form action="/expressions" method="POST">
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
              id="first-example-of-first-expression"
              name="first-example-of-first-expression"
              class="w-full"
              v-model="firstExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-first-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              id="second-example-of-first-expression"
              name="second-example-of-first-expression"
              class="w-full"
              v-model="firstExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-first-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              id="third-example-of-first-expression"
              name="third-example-of-first-expression"
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
              id="first-example-of-second-expression"
              name="first-example-of-second-expression"
              class="w-full"
              v-model="secondExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-second-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              id="second-example-of-second-expression"
              name="second-example-of-second-expression"
              class="w-full"
              v-model="secondExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-second-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              id="third-example-of-second-expression"
              name="third-example-of-second-expression"
              class="w-full"
              v-model="secondExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getSecondPage">{{ $t('back') }}</button>
        <button
          v-if="thirdExpression || fourthExpression || fifthExpression"
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
              id="first-example-of-third-expression"
              name="first-example-of-third-expression"
              class="w-full"
              v-model="thirdExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-third-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              id="second-example-of-third-expression"
              name="second-example-of-third-expression"
              class="w-full"
              v-model="thirdExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-third-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              id="third-example-of-third-expression"
              name="third-example-of-third-expression"
              class="w-full"
              v-model="thirdExpressionDetails.thirdExample" />
          </li>
        </ul>
        <button type="button" @click="getThirdPage">{{ $t('back') }}</button>
        <button
          v-if="fourthExpression || fifthExpression"
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
              id="first-example-of-fourth-expression"
              name="first-example-of-fourth-expression"
              class="w-full"
              v-model="fourthExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-fourth-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              id="second-example-of-fourth-expression"
              name="second-example-of-fourth-expression"
              class="w-full"
              v-model="fourthExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-fourth-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              id="third-example-of-fourth-expression"
              name="third-example-of-fourth-expression"
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
              id="first-example-of-fifth-expression"
              name="first-example-of-fifth-expression"
              class="w-full"
              v-model="fifthExpressionDetails.firstExample" />
          </li>
          <li>
            <label for="second-example-of-fifth-expression">{{
              $t('form.secondExample')
            }}</label>
            <input
              id="second-example-of-fifth-expression"
              name="second-example-of-fifth-expression"
              class="w-full"
              v-model="fifthExpressionDetails.secondExample" />
          </li>
          <li>
            <label for="third-example-of-fifth-expression">{{
              $t('form.thirdExample')
            }}</label>
            <input
              id="third-example-of-fifth-expression"
              name="third-example-of-fifth-expression"
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
          <li>
            <label for="tags">{{ $t('form.tags') }}</label>
            <input id="tags" name="tags" class="w-full" v-model="tag" />
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
        <button>{{ $t('form.create') }}</button>
      </div>
    </form>
  </div>
</template>

<script>
export default {
  name: 'ExpressionsForm',
  data() {
    return {
      currentPage: 1,
      previousPage: Number,
      firstExpression: '',
      secondExpression: '',
      thirdExpression: '',
      fourthExpression: '',
      fifthExpression: '',
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
      expressionsError: false,
      explanationError: false
    }
  },
  methods: {
    getFirstPage() {
      this.currentPage = 1
    },
    getSecondPage() {
      this.explanationError = false
      this.comparedExpressions = ''
      this.getComparedExpressions([
        this.secondExpression,
        this.thirdExpression,
        this.fourthExpression,
        this.fifthExpression
      ])
      if (this.currentPage === 1) {
        if (this.firstExpression === '' || this.secondExpression === '') {
          this.expressionsError = true
        }
      }
      if (!this.expressionsError) {
        this.currentPage = 2
      }
    },
    getThirdPage() {
      if (this.currentPage === 2) {
        if (!this.firstExpressionDetails.explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
        }
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
      if (this.currentPage === 3) {
        if (!this.secondExpressionDetails.explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
        }
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
      if (this.currentPage === 4) {
        if (!this.thirdExpressionDetails.explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
        }
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
      if (this.currentPage === 5) {
        if (!this.fourthExpressionDetails.explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
        }
      }
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
      if (!explanation) {
        this.explanationError = true
      } else {
        this.explanationError = false
      }
      this.previousPage = this.currentPage
      if (!this.explanationError) {
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
    }
  }
}
</script>

<style scoped></style>
