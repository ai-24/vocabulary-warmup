<template>
  <div class="grid justify-items-stretch place-content-center">
    <form @submit="onSubmit">
      <div v-if="currentPage === 1">
        <p>{{ $t('form.wordsAndPhrases')}}</p>
        <p v-if="wordsOrPhrasesError" class="text-red-600">{{ $t('form.wordsAndPhrasesError') }}</p>
        <input v-model="wordOrPhrase1" placeholder="First word">
        <input v-model="wordOrPhrase2" placeholder="Second word">
        <input v-model="wordOrPhrase3" placeholder="Third word (Optional)">
        <input v-model="wordOrPhrase4" placeholder="Fourth word (Optional)">
        <input v-model="wordOrPhrase5" placeholder="Fifth word (Optional)">
        <button @click.prevent="getSecondPage">{{ $t('form.next')}}</button>
      </div>
      <div v-else-if="currentPage === 2">
        <WordsAndPhrasesDetailsForm
            :currentWordOrPhrase="wordOrPhrase1"
            :comparedWords="comparedWords"
            :currentPage="currentPage"
            :typedExplanation="firstWordOrPhraseInfo.explanation"
            :typedExample1="firstWordOrPhraseInfo.example1"
            :typedExample2="firstWordOrPhraseInfo.example2"
            :typedExample3="firstWordOrPhraseInfo.example3"
            :explanationError="explanationError"
            @on-first-page="getFirstPage"
            @on-third-page="getThirdPage"></WordsAndPhrasesDetailsForm>
      </div>
      <div v-else-if="currentPage === 3">
        <WordsAndPhrasesDetailsForm
            :currentWordOrPhrase="wordOrPhrase2"
            :comparedWords="comparedWords"
            :currentPage="currentPage"
            :wordOrPhrase3="wordOrPhrase3"
            :wordOrPhrase4="wordOrPhrase4"
            :wordOrPhrase5="wordOrPhrase5"
            :typedExplanation="secondWordOrPhraseInfo.explanation"
            :typedExample1="secondWordOrPhraseInfo.example1"
            :typedExample2="secondWordOrPhraseInfo.example2"
            :typedExample3="secondWordOrPhraseInfo.example3"
            :explanationError="explanationError"
            @on-second-page="getSecondPage"
            @on-fourth-page="getFourthPage"
            @on-seven-page="getSevenPage"></WordsAndPhrasesDetailsForm>
      </div>
      <div v-else-if="currentPage === 4">
        <WordsAndPhrasesDetailsForm
            :currentWordOrPhrase="wordOrPhrase3"
            :comparedWords="comparedWords"
            :currentPage="currentPage"
            :wordOrPhrase4="wordOrPhrase4"
            :wordOrPhrase5="wordOrPhrase5"
            :typedExplanation="thirdWordOrPhraseInfo.explanation"
            :typedExample1="thirdWordOrPhraseInfo.example1"
            :typedExample2="thirdWordOrPhraseInfo.example2"
            :typedExample3="thirdWordOrPhraseInfo.example3"
            :explanationError="explanationError"
            @on-third-page="getThirdPage"
            @on-fifth-page="getFifthPage"
            @on-seven-page="getSevenPage"
        ></WordsAndPhrasesDetailsForm>
      </div>
      <div v-else-if="currentPage === 5">
        <WordsAndPhrasesDetailsForm
            :currentWordOrPhrase="wordOrPhrase4"
            :comparedWords="comparedWords"
            :currentPage="currentPage"
            :wordOrPhrase5="wordOrPhrase5"
            :typedExplanation="fourthWordOrPhraseInfo.explanation"
            :typedExample1="fourthWordOrPhraseInfo.example1"
            :typedExample2="fourthWordOrPhraseInfo.example2"
            :typedExample3="fourthWordOrPhraseInfo.example3"
            :explanationError="explanationError"
            @on-fourth-page="getFourthPage"
            @on-six-page="getSixPage"
            @on-seven-page="getSevenPage"
        ></WordsAndPhrasesDetailsForm>
      </div>
      <div v-else-if="currentPage === 6">
        <WordsAndPhrasesDetailsForm
            :currentWordOrPhrase="wordOrPhrase5"
            :comparedWords="comparedWords"
            :currentPage="currentPage"
            :typedExplanation="fifthWordOrPhraseInfo.explanation"
            :typedExample1="fifthWordOrPhraseInfo.example1"
            :typedExample2="fifthWordOrPhraseInfo.example2"
            :typedExample3="fifthWordOrPhraseInfo.example3"
            :explanationError="explanationError"
            @on-fifth-page="getFifthPage"
            @on-seven-page="getSevenPage"
        ></WordsAndPhrasesDetailsForm>
      </div>
      <div v-else-if="currentPage === 7">
        <p>{{ $t('form.note')}}</p>
        <textarea class="w-full" v-model="note"></textarea>
        <p>{{ $t('form.tag')}}</p>
        <input class="w-full" v-model="tag">
        <button v-if="previousPage === 3" @click="getThirdPage">{{ $t('back')}}</button>
        <button v-else-if="previousPage === 4" @click="getFourthPage">{{ $t('back')}}</button>
        <button v-else-if="previousPage === 5" @click="getFifthPage">{{ $t('back')}}</button>
        <button v-else-if="previousPage === 6" @click="getSixPage">{{ $t('back')}}</button>
        <button>{{ $t('form.create') }}</button>
      </div>
    </form>
  </div>
</template>

<script>
import WordsAndPhrasesDetailsForm from './words-and-phrases-details-form.vue'

export default {
  name: 'WordsAndPhrasesForm',
  components: {
    WordsAndPhrasesDetailsForm
  },
  data() {
    return {
      currentPage: 1,
      previousPage: Number,
      wordOrPhrase1: '',
      wordOrPhrase2: '',
      wordOrPhrase3: '',
      wordOrPhrase4: '',
      wordOrPhrase5: '',
      firstWordOrPhraseInfo: {explanation: '',example1: '', example2: '', example3: ''},
      secondWordOrPhraseInfo: {explanation: '',example1: '', example2: '', example3: ''},
      thirdWordOrPhraseInfo: {explanation: '',example1: '', example2: '', example3: ''},
      fourthWordOrPhraseInfo: {explanation: '',example1: '', example2: '', example3: ''},
      fifthWordOrPhraseInfo: {explanation: '',example1: '', example2: '', example3: ''},
      comparedWords: '',
      note: '',
      tag: '',
      wordsOrPhrasesError: false,
      explanationError: false
    }
  },
  methods: {
    getFirstPage(explanation, example1, example2, example3) {
      this.currentPage = 1
      this.saveFirstWordOrPhraseDetails(explanation, example1, example2, example3)
    },
    getSecondPage(explanation, example1, example2, example3) {
      this.explanationError = false
      this.comparedWords = ''
      this.getComparedWords([this.wordOrPhrase2, this.wordOrPhrase3, this.wordOrPhrase4, this.wordOrPhrase5])
      if (this.currentPage === 3) {
        this.saveSecondWordOrPhraseDetails(explanation, example1, example2, example3)
      } else if (this.currentPage === 1) {
        this.wordsOrPhrasesError = this.wordOrPhrase1 && this.wordOrPhrase2 ? false : true
      }
      if (!this.wordsOrPhrasesError) {
        this.currentPage = 2
      }
    },
    getThirdPage(explanation, example1, example2, example3) {
      if (this.currentPage === 2) {
        if (!explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
          this.saveFirstWordOrPhraseDetails(explanation, example1, example2, example3)
        }
      } else if (this.currentPage === 4) {
        this.explanationError = false
        this.saveThirdWordOrPhraseDetails(explanation, example1, example2, example3)
      }
      if (!this.explanationError) {
        this.comparedWords = ''
        this.getComparedWords([this.wordOrPhrase1, this.wordOrPhrase3, this.wordOrPhrase4, this.wordOrPhrase5])
        this.currentPage = 3
      }
    },
    getFourthPage(explanation, example1, example2, example3) {
      if (this.currentPage === 3) {
        if (!explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
          this.saveSecondWordOrPhraseDetails(explanation, example1, example2, example3)
        }
      } else if (this.currentPage === 5) {
        this.explanationError = false
        this.saveFourthWordOrPhraseDetails(explanation, example1, example2, example3)
      }
      if (!this.explanationError) {
        this.comparedWords = ''
        this.getComparedWords([this.wordOrPhrase1, this.wordOrPhrase2, this.wordOrPhrase4, this.wordOrPhrase5])
        this.currentPage = 4
      }
    },
    getFifthPage(explanation, example1, example2, example3) {
      if (this.currentPage === 4) {
        if (!explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
          this.saveThirdWordOrPhraseDetails(explanation, example1, example2, example3)
        }
      } else if (this.currentPage === 6) {
        this.explanationError = false
        this.saveFifthWordOrPhraseDetails(explanation, example1, example2, example3)
      }
      if (!this.explanationError) {
        this.comparedWords = ''
        this.getComparedWords([this.wordOrPhrase1, this.wordOrPhrase2, this.wordOrPhrase3, this.wordOrPhrase5])
        this.currentPage = 5
      }
    },
    getSixPage(explanation, example1, example2, example3) {
      if (this.currentPage === 5) {
        if (!explanation) {
          this.explanationError = true
        } else {
          this.explanationError = false
          this.saveFourthWordOrPhraseDetails(explanation, example1, example2, example3)
        }
      }
      if (!this.explanationError) {
        this.comparedWords = ''
        this.getComparedWords([this.wordOrPhrase1, this.wordOrPhrase2, this.wordOrPhrase3, this.wordOrPhrase4])
        this.currentPage = 6
      }
    },
    getSevenPage(explanation, example1, example2, example3) {
      if (!explanation) {
        this.explanationError = true
      } else {
        this.explanationError = false
      }
      if (this.currentPage === 3) {
        this.saveSecondWordOrPhraseDetails(explanation, example1, example2, example3)
      } else if (this.currentPage === 4) {
        this.saveThirdWordOrPhraseDetails(explanation, example1, example2, example3)
      } else if (this.currentPage === 5) {
        this.saveFourthWordOrPhraseDetails(explanation, example1, example2, example3)
      } else if (this.currentPage === 6) {
        this.saveFifthWordOrPhraseDetails(explanation, example1, example2, example3)
      }
      this.previousPage = this.currentPage
      if (!this.explanationError) {
        this.currentPage = 7
      }
    },
    saveFirstWordOrPhraseDetails(explanation, example1, example2, example3) {
      this.firstWordOrPhraseInfo.explanation = explanation
      this.firstWordOrPhraseInfo.example1 = example1
      this.firstWordOrPhraseInfo.example2 = example2
      this.firstWordOrPhraseInfo.example3 = example3
    },
    saveSecondWordOrPhraseDetails(explanation, example1, example2, example3) {
      this.secondWordOrPhraseInfo.explanation = explanation
      this.secondWordOrPhraseInfo.example1 = example1
      this.secondWordOrPhraseInfo.example2 = example2
      this.secondWordOrPhraseInfo.example3 = example3
    },
    saveThirdWordOrPhraseDetails(explanation, example1, example2, example3) {
      this.thirdWordOrPhraseInfo.explanation = explanation
      this.thirdWordOrPhraseInfo.example1 = example1
      this.thirdWordOrPhraseInfo.example2 = example2
      this.thirdWordOrPhraseInfo.example3 = example3
    },
    saveFourthWordOrPhraseDetails(explanation, example1, example2, example3) {
      this.fourthWordOrPhraseInfo.explanation = explanation
      this.fourthWordOrPhraseInfo.example1 = example1
      this.fourthWordOrPhraseInfo.example2 = example2
      this.fourthWordOrPhraseInfo.example3 = example3
    },
    saveFifthWordOrPhraseDetails(explanation, example1, example2, example3) {
      this.fifthWordOrPhraseInfo.explanation = explanation
      this.fifthWordOrPhraseInfo.example1 = example1
      this.fifthWordOrPhraseInfo.example2 = example2
      this.fifthWordOrPhraseInfo.example3 = example3
    },
    getComparedWords(wordsAndPhrasesList) {
      wordsAndPhrasesList.forEach(element => {
            if (element) {
              const newComparedWordsList = this.comparedWords.concat(`${element}, `)
              this.comparedWords = newComparedWordsList
            }
          }
      )
      const comparedWords = this.comparedWords.slice(0, -2)
      this.comparedWords = comparedWords
    },
    onSubmit(){

    }
  }
}
</script>

<style scoped></style>
