# Word Warmup

![間違いやすい英単語やフレーズの学習をサポートするツールWord Warmup](https://github.com/ai-24/word-warmup/assets/76685187/7d4fdccb-05e8-4244-a92d-b3a3846139a1)

Word Warmupは、間違いやすい英単語やフレーズの学習をサポートする英語学習者のためのツールです。
### サービスURL
https://word-warmup.fly.dev/

## 特徴
### 1. 英単語・フレーズの登録

![英単語・フレーズの登録ページ](https://github.com/ai-24/word-warmup/assets/76685187/0ed3b095-bfc2-4f05-88de-57a36d146cdc)

意味が似ている、スペルが似ているなど様々な理由で間違いやすい英単語・フレーズの意味や例文、その使い分けの解説を間違いやすいもの同士で登録できます。
### 2. クイズ

[![クイズページ](https://i.gyazo.com/58d5e8bf8513b943cd2d0bc9f728f341.gif)](https://gyazo.com/58d5e8bf8513b943cd2d0bc9f728f341)

自身で登録した英単語・フレーズを覚えたかの確認クイズが行えます。
### 3. クイズの結果を元に覚えた語彙リストとブックマークに簡単保存

![クイズの結果ページ](https://github.com/ai-24/word-warmup/assets/76685187/ef7f356d-53ad-4705-91a4-816ed127449f)

覚えた、または覚えていなかった英単語・フレーズをクイズの結果から自動で抽出し、覚えた語彙リストとブックマークに保存できます。英単語・フレーズの管理を簡単にすることで効率よく復習できます。
### 4. 英単語・フレーズ(イギリス英語)18語の閲覧とそのクイズのお試しはログイン不要

![英単語・フレーズの一覧ページ](https://github.com/ai-24/word-warmup/assets/76685187/c32f6d8d-cc55-4654-b09a-c2d0bede82b2)

これら18語の英単語・フレーズはログインした後、修正・削除も可能です。

## 技術スタック
- Ruby 3.2.0
- Rails 7.0.4
- Vue.js 3.2.47
- Tailwind CSS 3.3.1
- GitHub Actions
- Fly.io

## 環境構築
```
$ git clone https://github.com/ai-24/word-warmup.git
$ cd word-warmup
$ bin/setup
```

## 起動
```$ bin/dev```

## テスト
```$ bundle exec rspec```

## Lint
```$ bin/lint```
