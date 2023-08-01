<template>
  <div class="grid justify-items-stretch">
    <ExpressionsFormStepNavigation
      :current-page="currentPage"
      :previous-page="previousPage"
      :completed-step2="completedStep2"></ExpressionsFormStepNavigation>
    <form
      accept-charset="UTF-8"
      :action="url"
      method="POST"
      class="mt-10 bg-lavender-600 p-2">
      <input v-if="expressionId" name="_method" type="hidden" value="put" />
      <div v-show="currentPage === 1" class="bg-white p-2 sm:p-5">
        <h1 class="mb-7 font-bold text-lg">{{ $t('form.expressions') }}</h1>
        <p v-if="expressionsError" class="text-red-600">
          {{ $t('form.expressionsError') }}
        </p>
        <ul>
          <li class="pb-6">
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
              class="outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block w-full mt-1 pl-2 py-1"
              name="expression[expression_items_attributes][0][content]"
              v-model="firstExpression"
              placeholder="First word" />
          </li>
          <li class="pb-6">
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
              class="outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block w-full mt-1 pl-2 py-1"
              name="expression[expression_items_attributes][1][content]"
              v-model="secondExpression"
              placeholder="Second word" />
          </li>
          <li class="pb-6">
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
              class="outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block w-full mt-1 pl-2 py-1"
              name="expression[expression_items_attributes][2][content]"
              v-model="thirdExpression"
              placeholder="Third word" />
          </li>
          <li class="pb-6">
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
              class="outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block w-full mt-1 pl-2 py-1"
              name="expression[expression_items_attributes][3][content]"
              v-model="fourthExpression"
              placeholder="Fourth word" />
          </li>
          <li class="pb-6">
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
              class="outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block w-full mt-1 pl-2 py-1"
              name="expression[expression_items_attributes][4][content]"
              v-model="fifthExpression"
              placeholder="Fifth word" />
          </li>
        </ul>
        <div class="flex justify-end">
          <div class="w-1/2 text-center">
            <button
              v-if="firstExpression"
              type="button"
              @click="getSecondPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="secondExpression"
              type="button"
              @click="getThirdPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="thirdExpression"
              type="button"
              @click="getFourthPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fourthExpression"
              type="button"
              @click="getFifthPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else
              type="button"
              @click="expressionsError = true"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 2" class="bg-white p-2 sm:p-5">
        <ExpressionsFormExplanation
          v-model:explanation="firstExpressionDetails.explanation"
          v-model:first-example="firstExpressionDetails.firstExample"
          v-model:second-example="firstExpressionDetails.secondExample"
          v-model:third-example="firstExpressionDetails.thirdExample"
          :compared-expressions="comparedExpressions"
          :explanation-error="explanationError"
          :expression="firstExpression"></ExpressionsFormExplanation>
        <input
          type="hidden"
          name="expression[expression_items_attributes][0][explanation]"
          :value="firstExpressionDetails.explanation" />
        <input
          v-if="exampleId.firstExpression[0]"
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][0][id]"
          :value="exampleId.firstExpression[0].firstExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][0][content]"
          :value="firstExpressionDetails.firstExample" />
        <input
          v-if="exampleId.firstExpression[1]"
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][1][id]"
          :value="exampleId.firstExpression[1].secondExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][1][content]"
          :value="firstExpressionDetails.secondExample" />
        <input
          v-if="exampleId.firstExpression[2]"
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][2][id]"
          :value="exampleId.firstExpression[2].thirdExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][0][examples_attributes][2][content]"
          :value="firstExpressionDetails.thirdExample" />
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              type="button"
              @click="getFirstPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              v-if="secondExpression"
              type="button"
              @click="getThirdPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="thirdExpression"
              type="button"
              @click="getFourthPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fourthExpression"
              type="button"
              @click="getFifthPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fifthExpression"
              type="button"
              @click="getSixPage"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 3" class="bg-white p-2 sm:p-5">
        <ExpressionsFormExplanation
          v-model:explanation="secondExpressionDetails.explanation"
          v-model:first-example="secondExpressionDetails.firstExample"
          v-model:second-example="secondExpressionDetails.secondExample"
          v-model:third-example="secondExpressionDetails.thirdExample"
          :compared-expressions="comparedExpressions"
          :explanation-error="explanationError"
          :expression="secondExpression"></ExpressionsFormExplanation>
        <input
          type="hidden"
          name="expression[expression_items_attributes][1][explanation]"
          :value="secondExpressionDetails.explanation" />
        <input
          v-if="exampleId.secondExpression[0]"
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][0][id]"
          :value="exampleId.secondExpression[0].firstExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][0][content]"
          :value="secondExpressionDetails.firstExample" />
        <input
          v-if="exampleId.secondExpression[1]"
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][1][id]"
          :value="exampleId.secondExpression[1].secondExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][1][content]"
          :value="secondExpressionDetails.secondExample" />
        <input
          v-if="exampleId.secondExpression[2]"
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][2][id]"
          :value="exampleId.secondExpression[2].thirdExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][1][examples_attributes][2][content]"
          :value="secondExpressionDetails.thirdExample" />
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              v-if="firstExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSecondPage">
              {{ $t('back') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFirstPage">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              v-if="thirdExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFourthPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fourthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFifthPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fifthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSixPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSevenPage(secondExpressionDetails.explanation)">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 4" class="bg-white p-2 sm:p-5">
        <ExpressionsFormExplanation
          v-model:explanation="thirdExpressionDetails.explanation"
          v-model:first-example="thirdExpressionDetails.firstExample"
          v-model:second-example="thirdExpressionDetails.secondExample"
          v-model:third-example="thirdExpressionDetails.thirdExample"
          :compared-expressions="comparedExpressions"
          :explanation-error="explanationError"
          :expression="thirdExpression"></ExpressionsFormExplanation>
        <input
          type="hidden"
          name="expression[expression_items_attributes][2][explanation]"
          :value="thirdExpressionDetails.explanation" />
        <input
          v-if="exampleId.thirdExpression[0]"
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][0][id]"
          :value="exampleId.thirdExpression[0].firstExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][0][content]"
          :value="thirdExpressionDetails.firstExample" />
        <input
          v-if="exampleId.thirdExpression[1]"
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][1][id]"
          :value="exampleId.thirdExpression[1].secondExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][1][content]"
          :value="thirdExpressionDetails.secondExample" />
        <input
          v-if="exampleId.thirdExpression[2]"
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][2][id]"
          :value="exampleId.thirdExpression[2].thirdExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][2][examples_attributes][2][content]"
          :value="thirdExpressionDetails.thirdExample" />
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              v-if="secondExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getThirdPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="firstExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSecondPage">
              {{ $t('back') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFirstPage">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              v-if="fourthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFifthPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else-if="fifthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSixPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSevenPage(thirdExpressionDetails.explanation)">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 5" class="bg-white p-2 sm:p-5">
        <ExpressionsFormExplanation
          v-model:explanation="fourthExpressionDetails.explanation"
          v-model:first-example="fourthExpressionDetails.firstExample"
          v-model:second-example="fourthExpressionDetails.secondExample"
          v-model:third-example="fourthExpressionDetails.thirdExample"
          :compared-expressions="comparedExpressions"
          :explanation-error="explanationError"
          :expression="fourthExpression"></ExpressionsFormExplanation>
        <input
          type="hidden"
          name="expression[expression_items_attributes][3][explanation]"
          :value="fourthExpressionDetails.explanation" />
        <input
          v-if="exampleId.fourthExpression[0]"
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][0][id]"
          :value="exampleId.fourthExpression[0].firstExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][0][content]"
          :value="fourthExpressionDetails.firstExample" />
        <input
          v-if="exampleId.fourthExpression[1]"
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][1][id]"
          :value="exampleId.fourthExpression[1].secondExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][1][content]"
          :value="fourthExpressionDetails.secondExample" />
        <input
          v-if="exampleId.fourthExpression[2]"
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][2][id]"
          :value="exampleId.fourthExpression[2].thirdExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][3][examples_attributes][2][content]"
          :value="fourthExpressionDetails.thirdExample" />
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              v-if="thirdExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFourthPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="secondExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getThirdPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="firstExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSecondPage">
              {{ $t('back') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFirstPage">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              v-if="fifthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSixPage">
              {{ $t('form.next') }}
            </button>
            <button
              v-else
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSevenPage(fourthExpressionDetails.explanation)">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 6" class="bg-white p-2 sm:p-5">
        <ExpressionsFormExplanation
          v-model:explanation="fifthExpressionDetails.explanation"
          v-model:first-example="fifthExpressionDetails.firstExample"
          v-model:second-example="fifthExpressionDetails.secondExample"
          v-model:third-example="fifthExpressionDetails.thirdExample"
          :compared-expressions="comparedExpressions"
          :explanation-error="explanationError"
          :expression="fifthExpression"></ExpressionsFormExplanation>
        <input
          type="hidden"
          name="expression[expression_items_attributes][4][explanation]"
          :value="fifthExpressionDetails.explanation" />
        <input
          v-if="exampleId.fifthExpression[0]"
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][0][id]"
          :value="exampleId.fifthExpression[0].firstExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][0][content]"
          :value="fifthExpressionDetails.firstExample" />
        <input
          v-if="exampleId.fifthExpression[1]"
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][1][id]"
          :value="exampleId.fifthExpression[1].secondExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][1][content]"
          :value="fifthExpressionDetails.secondExample" />
        <input
          v-if="exampleId.fifthExpression[2]"
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][2][id]"
          :value="exampleId.fifthExpression[2].thirdExample" />
        <input
          type="hidden"
          name="expression[expression_items_attributes][4][examples_attributes][2][content]"
          :value="fifthExpressionDetails.thirdExample" />
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              v-if="fourthExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFifthPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="thirdExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFourthPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="secondExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getThirdPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="firstExpression"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSecondPage">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSevenPage(fifthExpressionDetails.explanation)">
              {{ $t('form.next') }}
            </button>
          </div>
        </div>
      </div>
      <div v-show="currentPage === 7" class="bg-white p-2 sm:p-5">
        <ul class="pb-6">
          <li>
            <label for="note" class="font-bold">{{ $t('form.note') }}</label>
            <textarea
              id="note"
              name="expression[note]"
              class="w-full h-40 outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block pl-2 py-1"
              v-model="note"></textarea>
          </li>
          <li class="tags mt-10">
            <label for="tags" class="font-bold">{{ $t('form.tags') }}</label>
            <div>
              <vue-tags-input
                id="tags"
                v-model="tag"
                :tags="tags"
                class="w-full"
                @tags-changed="(newTags) => (tags = newTags)"
                :placeholder="$t('form.howToUseTagInput')"></vue-tags-input>
              <ul>
                <li v-for="(tag, index) in tags" :key="tag">
                  <input
                    type="hidden"
                    :name="`expression[tags_attributes][${index}][name]`"
                    :value="tag.text" />
                </li>
              </ul>
            </div>
          </li>
        </ul>
        <div class="flex flex-row">
          <div class="basis-1/2 text-center">
            <button
              v-if="previousPage === 3"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getThirdPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="previousPage === 4"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFourthPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="previousPage === 5"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getFifthPage">
              {{ $t('back') }}
            </button>
            <button
              v-else-if="previousPage === 6"
              type="button"
              class="border-2 border-lavender-800 rounded-md px-4 hover:bg-lavender-50"
              @click="getSixPage">
              {{ $t('back') }}
            </button>
          </div>
          <div class="basis-1/2 text-center">
            <button
              v-if="expressionId"
              type="submit"
              name="button"
              class="border-2 border-lavender-800 bg-lavender-800 rounded-md px-4 hover:bg-lavender-50 text-white hover:text-black font-bold tracking-wide">
              {{ $t('form.edit') }}
            </button>
            <button
              v-else
              class="border-2 border-lavender-800 bg-lavender-800 rounded-md px-4 hover:bg-lavender-50 text-white hover:text-black font-bold tracking-wide">
              {{ $t('form.create') }}
            </button>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>

<script>
import VueTagsInput from '@sipec/vue3-tags-input'
import ExpressionsFormStepNavigation from './expressions-form-step-navigation.vue'
import ExpressionsFormExplanation from './expressions-form-explanation.vue'

export default {
  name: 'ExpressionsForm',
  components: {
    ExpressionsFormExplanation,
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
      })
      this.expressionsAmount = this.expressionsList.length
    },
    isExplanationError(explanation) {
      this.explanationError = false
      if (!explanation) this.explanationError = true
    },
    getFirstPage() {
      this.previousPage = this.currentPage
      this.currentPage = 1
    },
    checkExpressionErrorAndCompletedStep2() {
      const previousExpressionsAmount = this.expressionsAmount
      this.calculateExpressionsAmount()
      if (this.expressionsAmount < 2) this.expressionsError = true
      if (
        this.completedStep2 &&
        this.expressionsAmount !== previousExpressionsAmount
      ) {
        this.completedStep2 = false
      }
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
        this.checkExpressionErrorAndCompletedStep2()
      }
      if (!this.expressionsError) this.currentPage = 2
    },
    getThirdPage() {
      this.previousPage = this.currentPage
      this.expressionsError = false
      if (this.currentPage === 2) {
        this.isExplanationError(this.firstExpressionDetails.explanation)
      } else if (this.currentPage === 4) {
        this.explanationError = false
      } else if (this.currentPage === 1) {
        this.checkExpressionErrorAndCompletedStep2()
      }
      if (!this.explanationError && !this.expressionsError) {
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
      this.expressionsError = false
      if (this.currentPage === 3) {
        this.isExplanationError(this.secondExpressionDetails.explanation)
      } else if (this.currentPage === 5) {
        this.explanationError = false
      } else if (this.currentPage === 1) {
        this.checkExpressionErrorAndCompletedStep2()
      }
      if (!this.explanationError && !this.expressionsError) {
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
      this.expressionsError = false
      if (this.currentPage === 4) {
        this.isExplanationError(this.thirdExpressionDetails.explanation)
      } else if (this.currentPage === 6) {
        this.explanationError = false
      } else if (this.currentPage === 1) {
        this.checkExpressionErrorAndCompletedStep2()
      }
      if (!this.explanationError && !this.expressionsError) {
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
      if (this.currentPage === 5) {
        this.isExplanationError(this.fourthExpressionDetails.explanation)
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
