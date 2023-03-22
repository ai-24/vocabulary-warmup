<template>
  <ol class="flex flex-row">
    <div v-if="previousPage === 2 && currentPage === 1">
      <li
        class="inline-block p-2 bg-yellow-200 border-y-2 border-l-2 border-yellow-200">
        <h1>
          <font-awesome-icon icon="fa-regular fa-circle-check" size="xl" />Step1
        </h1>
        <p>{{ $t('stepNavigation.wordsOrPhrases') }}</p>
      </li>
      <div v-if="!completedStep2" class="inline-block">
        <li class="p-2 border-y-2 border-r-2 border-gray-300 text-gray-400">
          <h1>
            <font-awesome-icon
              icon="fa-regular fa-pen-to-square"
              size="xl" />Step2
          </h1>
          <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
        </li>
      </div>
      <div v-else class="inline-block">
        <li class="p-2 border-y-2 border-r-2 border-gray-300">
          <h1>
            <font-awesome-icon
              icon="fa-regular fa-circle-check"
              class="text-yellow-400"
              size="xl" />Step2
          </h1>
          <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
        </li>
      </div>
    </div>
    <div v-else-if="currentPage === 1">
      <li
        class="inline-block p-2 bg-yellow-200 border-y-2 border-r-2 border-yellow-200">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-pen-to-square"
            size="xl" />Step1
        </h1>
        <p>{{ $t('stepNavigation.wordsOrPhrases') }}</p>
      </li>
      <li
        class="inline-block p-2 border-y-2 border-r-2 border-gray-300 text-gray-400">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-pen-to-square"
            size="xl" />Step2
        </h1>
        <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div v-else>
      <li class="inline-block p-2 border-y-2 border-l-2 border-gray-300">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-circle-check"
            class="text-yellow-400"
            size="xl" />Step1
        </h1>
        <p>{{ $t('stepNavigation.wordsOrPhrases') }}</p>
      </li>
    </div>
    <div v-if="currentPage === 7">
      <li class="inline-block p-2 border-y-2 border-l-2 border-gray-300">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-circle-check"
            class="text-yellow-400"
            size="xl" />Step2
        </h1>
        <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
      <li
        class="inline-block p-2 bg-yellow-200 border-y-2 border-r-2 border-yellow-200">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-pen-to-square"
            size="xl" />Step3
        </h1>
        <p>{{ $t('stepNavigation.noteAndTags') }}</p>
      </li>
    </div>
    <div v-else-if="currentPage !== 1 && completedStep2">
      <li
        class="inline-block bg-yellow-200 p-2 border-y-2 border-l-2 border-yellow-200">
        <h1>
          <font-awesome-icon icon="fa-regular fa-circle-check" size="xl" />Step2
        </h1>
        <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div v-else-if="currentPage !== 1">
      <li
        class="inline-block p-2 bg-yellow-200 border-y-2 border-r-2 border-yellow-200">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-pen-to-square"
            size="xl" />Step2
        </h1>
        <p>{{ $t('stepNavigation.explanationAndExamples') }}</p>
      </li>
    </div>
    <div v-if="currentPage < 7">
      <li
        class="inline-block p-2 border-y-2 border-r-2 border-gray-300 text-gray-400">
        <h1>
          <font-awesome-icon
            icon="fa-regular fa-pen-to-square"
            size="xl" />Step3
        </h1>
        <p>{{ $t('stepNavigation.noteAndTags') }}</p>
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
