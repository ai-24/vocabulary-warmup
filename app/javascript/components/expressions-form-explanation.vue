<template>
  <h2 class="font-bold text-lg border-b border-lavender-600">
    {{ expression }}について
  </h2>
  <div :class="{ 'text-red-600': explanationError }" class="mt-8 font-semibold">
    <label for="explanation-of-expression">
      {{ expression }}の意味や前ページで登録した他の英単語・フレーズ（{{
        comparedExpressions
      }}）との違いを入力してください
    </label>
  </div>
  <textarea
    id="explanation-of-expression"
    class="w-full mt-2 h-40 px-2 outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block"
    :value="explanation"
    @input="$emit('update:explanation', $event.target.value)"
    :placeholder="$t('form.notice')"></textarea>
  <p class="pt-10 font-semibold">{{ $t('form.example') }}</p>
  <ul class="pb-6">
    <li class="pt-1">
      <label for="first-example-of-expression">{{
        $t('form.firstExample')
      }}</label>
      <input
        id="first-example-of-expression"
        class="w-full outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block pl-2 py-1"
        :value="firstExample"
        @input="$emit('update:firstExample', $event.target.value)" />
    </li>
    <li class="pt-1.5">
      <label for="second-example-of-expression">{{
        $t('form.secondExample')
      }}</label>
      <input
        id="second-example-of-expression"
        class="w-full outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block pl-2 py-1"
        :value="secondExample"
        @input="$emit('update:secondExample', $event.target.value)" />
    </li>
    <li class="pt-1.5">
      <label for="third-example-of-expression">{{
        $t('form.thirdExample')
      }}</label>
      <input
        id="third-example-of-expression"
        class="w-full outline outline-offset-0 outline-1 outline-neutral-400 focus:outline-blue-600 block pl-2 py-1"
        :value="thirdExample"
        @input="$emit('update:thirdExample', $event.target.value)" />
    </li>
  </ul>
</template>

<script>
export default {
  name: 'expressionsFormExplanation',
  props: {
    expression: {
      type: String,
      required: true
    },
    explanationError: {
      type: Boolean,
      required: true
    },
    comparedExpressions: {
      type: String,
      required: true
    },
    explanation: String,
    firstExample: String,
    secondExample: String,
    thirdExample: String
  },
  emits: [
    'update:explanation',
    'update:firstExample',
    'update:secondExample',
    'update:thirdExample'
  ]
}
</script>
