<template>
  <h1>{{ $t('form.about', {word: currentWordOrPhrase})}}</h1>
  <div v-if="explanationError" class="text-red-600">
    <p>{{ $t('form.explanation', { word: currentWordOrPhrase, comparison: comparedWords})}}</p>
  </div>
  <div v-else>
    <p>{{ $t('form.explanation', { word: currentWordOrPhrase, comparison: comparedWords})}}</p>
  </div>
  <textarea class="w-full" v-model="explanation" :placeholder="$t('form.notice')"></textarea>
  <p>{{ $t('form.example')}}</p>
  <input class="w-full" v-model="example1">
  <input class="w-full" v-model="example2">
  <input class="w-full" v-model="example3">
  <div v-if="currentPage === 2">
    <button @click="$emit('onFirstPage', explanation, example1, example2, example3)">{{ $t('back')}}</button>
    <button @click.prevent="$emit('onThirdPage', explanation, example1, example2, example3)">{{ $t('form.next')}}</button>
  </div>
  <div v-else-if="currentPage === 3">
    <button @click="$emit('onSecondPage', explanation, example1, example2, example3)">{{ $t('back')}}</button>
    <button v-if="wordOrPhrase3 || wordOrPhrase4 || wordOrPhrase5" @click.prevent="$emit('onFourthPage', explanation, example1, example2, example3)">
      {{ $t('form.next')}}
    </button>
    <button v-else @click.prevent="$emit('onSevenPage', explanation, example1, example2, example3)">{{ $t('form.next')}}</button>
  </div>
  <div v-else-if="currentPage === 4">
    <button @click="$emit('onThirdPage', explanation, example1, example2, example3)">{{ $t('back')}}</button>
    <button v-if="wordOrPhrase4 || wordOrPhrase5" @click.prevent="$emit('onFifthPage', explanation, example1, example2, example3)">
      {{ $t('form.next')}}
    </button>
    <button v-else @click.prevent="$emit('onSevenPage', explanation, example1, example2, example3)">{{ $t('form.next')}}</button>
  </div>
  <div v-else-if="currentPage === 5">
    <button @click="$emit('onFourthPage', explanation, example1, example2, example3)">{{ $t('back')}}</button>
    <button v-if="wordOrPhrase5" @click.prevent="$emit('onSixPage', explanation, example1, example2, example3)">
      {{ $t('form.next')}}
    </button>
    <button v-else @click.prevent="$emit('onSevenPage', explanation, example1, example2, example3)">{{ $t('form.next')}}</button>
  </div>
  <div v-else-if="currentPage === 6">
    <button @click="$emit('onFifthPage', explanation, example1, example2, example3)">{{ $t('back')}}</button>
    <button @click.prevent="$emit('onSevenPage', explanation, example1, example2, example3)">{{ $t('form.next')}}</button>
  </div>
</template>

<script>
export default {
  name: 'WordsAndPhrasesDetailsForm',
  emits: ['onFirstPage', 'onSecondPage', 'onThirdPage','onFourthPage', 'onFifthPage', 'onSixPage', 'onSevenPage'],
  props: {
    currentWordOrPhrase: {
      type: String,
      required: true
    },
    wordOrPhrase3: {
      type: String
    },
    wordOrPhrase4: {
      type: String
    },
    wordOrPhrase5: {
      type: String
    },
    comparedWords: {
      type: String,
      required: true
    },
    currentPage: {
      type: Number,
      required: true
    },
    typedExplanation: {
      type: String
    },
    typedExample1: {
      type: String
    },
    typedExample2: {
      type: String
    },
    typedExample3: {
      type: String
    },
    explanationError: {
      type: Boolean
    }
  },
  data() {
    return {
      explanation: '',
      example1: '',
      example2: '',
      example3: ''
    }
  },
  mounted () {
    this.explanation = this.typedExplanation
    this.example1 = this.typedExample1
    this.example2 = this.typedExample2
    this.example3 = this.typedExample3
  }
}
</script>

<style scoped></style>
