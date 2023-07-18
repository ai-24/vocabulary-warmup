<template>
  <ol>
    <div class="inline" v-if="previousPage === 2 && currentPage === 1">
      <div class="inline-block w-1/3 text-center">
        <li
          class="w-full inline-block px-0.5 sm:px-2 border-b-4 border-golden-yellow-400">
          <p><font-awesome-icon icon="fa-regular fa-circle-check" />Step1</p>
          <p class="text-sm">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
        </li>
      </div>
      <div v-if="!completedStep2" class="inline-block w-1/3 text-center">
        <li
          class="w-full px-0.5 sm:px-2 border-b-4 border-gray-300 text-gray-400">
          <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step2</p>
          <p class="text-sm">
            {{ $t('stepNavigation.explanationAndExamples') }}
          </p>
        </li>
      </div>
      <div v-else class="inline-block w-1/3 text-center">
        <li class="w-full px-0.5 sm:px-2 border-b-4 border-gray-300">
          <p>
            <font-awesome-icon
              icon="fa-regular fa-circle-check"
              class="text-golden-yellow-400" />Step2
          </p>
          <p class="text-sm">
            {{ $t('stepNavigation.explanationAndExamples') }}
          </p>
        </li>
      </div>
    </div>
    <div class="inline-block w-2/3 text-center" v-else-if="currentPage === 1">
      <li
        class="w-1/2 inline-block px-0.5 sm:px-2 border-b-4 border-golden-yellow-400">
        <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step1</p>
        <p class="text-sm">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
      </li>
      <li
        class="w-1/2 inline-block px-0.5 sm:px-2 border-b-4 border-gray-300 text-gray-400">
        <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step2</p>
        <p class="text-sm">{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div class="inline-block w-1/3 text-center" v-else>
      <li class="w-full inline-block px-0.5 sm:px-2 border-b-4 border-gray-300">
        <p>
          <font-awesome-icon
            icon="fa-regular fa-circle-check"
            class="text-golden-yellow-400" />Step1
        </p>
        <p class="text-sm">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
      </li>
    </div>
    <div class="inline-block w-2/3 text-center" v-if="currentPage === 7">
      <li class="w-1/2 inline-block px-0.5 sm:px-2 border-b-4 border-gray-300">
        <p>
          <font-awesome-icon
            icon="fa-regular fa-circle-check"
            class="text-golden-yellow-400" />Step2
        </p>
        <p class="text-sm">{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
      <li
        class="w-1/2 inline-block px-0.5 sm:px-2 border-b-4 border-golden-yellow-400">
        <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step3</p>
        <p class="text-sm">{{ $t('stepNavigation.noteAndTags') }}</p>
      </li>
    </div>
    <div
      class="inline-block w-1/3 text-center"
      v-else-if="currentPage !== 1 && completedStep2">
      <li
        class="w-full inline-block px-0.5 sm:px-2 border-b-4 border-golden-yellow-400">
        <p><font-awesome-icon icon="fa-regular fa-circle-check" />Step2</p>
        <p class="text-sm">{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div class="inline-block w-1/3 text-center" v-else-if="currentPage !== 1">
      <li
        class="w-full inline-block px-0.5 sm:px-2 border-b-4 border-golden-yellow-400">
        <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step2</p>
        <p class="text-sm">{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div class="inline-block w-1/3 text-center" v-if="currentPage < 7">
      <li
        class="w-full inline-block px-0.5 sm:px-2 border-b-4 border-gray-300 text-gray-400">
        <p><font-awesome-icon icon="fa-regular fa-pen-to-square" />Step3</p>
        <p class="text-sm">{{ $t('stepNavigation.noteAndTags') }}</p>
      </li>
    </div>
  </ol>
</template>

<script>
export default {
  name: 'expressionsFormStepNavigation',
  props: {
    currentPage: {
      type: Number,
      required: true
    },
    previousPage: {
      type: Number,
      required: true
    },
    completedStep2: {
      type: Boolean,
      required: true
    }
  }
}
</script>

<style scoped></style>
