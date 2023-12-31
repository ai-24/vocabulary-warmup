<template>
  <ol class="w-full step-navigation px-2">
    <li
      v-if="previousPage === 2 && currentPage === 1"
      class="w-1/3 text-center inline-block px-0.5 sm:px-2 border-b-6 border-lavender-600 text-darklavender-800">
      <p>
        <font-awesome-icon icon="fa-regular fa-circle-check" /><span
          class="pl-2"
          >Step1</span
        >
      </p>
      <p class="text-sm my-1">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
    </li>
    <li
      v-if="previousPage === 2 && currentPage === 1 && !completedStep2"
      class="inline-block w-1/3 text-center px-0.5 sm:px-2 border-b-6 border-gray-300 text-gray-400">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step2</span
        >
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="previousPage === 2 && currentPage === 1 && completedStep2"
      class="inline-block w-1/3 text-center px-0.5 sm:px-2 border-b-6 border-gray-300">
      <p>
        <font-awesome-icon
          icon="fa-regular fa-circle-check"
          class="text-darklavender-800" /><span class="pl-2">Step2</span>
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="currentPage === 1 && previousPage !== 2"
      class="text-center w-1/3 inline-block px-0.5 sm:px-2 border-b-6 border-lavender-600 text-darklavender-800">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step1</span
        >
      </p>
      <p class="text-sm my-1">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
    </li>
    <li
      v-if="currentPage === 1 && previousPage !== 2"
      class="text-center w-1/3 inline-block px-0.5 sm:px-2 border-b-6 border-gray-300 text-gray-400">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step2</span
        >
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="currentPage !== 1"
      class="w-1/3 text-center inline-block px-0.5 sm:px-2 border-b-6 border-gray-300">
      <p>
        <font-awesome-icon
          icon="fa-regular fa-circle-check"
          class="text-darklavender-800" /><span class="pl-2">Step1</span>
      </p>
      <p class="text-sm my-1">{{ $t('stepNavigation.wordsOrPhrases') }}</p>
    </li>
    <li
      v-if="currentPage === 7"
      class="text-center w-1/3 inline-block px-0.5 sm:px-2 border-b-6 border-gray-300">
      <p>
        <font-awesome-icon
          icon="fa-regular fa-circle-check"
          class="text-darklavender-800" /><span class="pl-2">Step2</span>
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="currentPage === 7"
      class="text-center w-1/3 inline-block px-0.5 sm:px-2 border-b-6 border-lavender-600 text-darklavender-800">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step3</span
        >
      </p>
      <p class="text-sm my-1">{{ $t('stepNavigation.noteAndTags') }}</p>
    </li>
    <li
      v-if="currentPage !== 7 && currentPage !== 1 && completedStep2"
      class="w-1/3 text-center inline-block px-0.5 sm:px-2 border-b-6 border-lavender-600 text-darklavender-800">
      <p>
        <font-awesome-icon icon="fa-regular fa-circle-check" /><span
          class="pl-2"
          >Step2</span
        >
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="currentPage !== 7 && currentPage !== 1 && !completedStep2"
      class="w-1/3 text-center inline-block px-0.5 sm:px-2 border-b-6 border-lavender-600 text-darklavender-800">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step2</span
        >
      </p>
      <p class="text-sm my-1">
        {{ $t('stepNavigation.explanationAndExamples') }}
      </p>
    </li>
    <li
      v-if="currentPage < 7"
      class="w-1/3 text-center inline-block px-0.5 sm:px-2 border-b-6 border-gray-300 text-gray-400">
      <p>
        <font-awesome-icon icon="fa-regular fa-pen-to-square" /><span
          class="pl-2"
          >Step3</span
        >
      </p>
      <p class="text-sm my-1">{{ $t('stepNavigation.noteAndTags') }}</p>
    </li>
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
