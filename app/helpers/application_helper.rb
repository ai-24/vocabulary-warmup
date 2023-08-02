# frozen_string_literal: true

module ApplicationHelper
  def error_or_not(alert)
    alert ? 'opacity-30' : ''
  end

  # rubocop:disable Metrics/MethodLength
  def default_meta_tags
    {
      site: 'Word Warmup',
      reverse: true,
      charset: 'utf-8',
      description: 'Word Warmupは間違いやすい英単語やフレーズの学習をサポートするツールです。英単語・フレーズの登録、登録した英単語などのクイズ、またクイズの結果を元に覚えた語彙リストとブックマークに英単語・フレーズを簡単保存できます。',
      keywords: '英語学習, 英語の勉強, 英単語, 単語帳, 間違いやすい英単語, 英語',
      og: {
        title: :title,
        description: :description,
        site_name: 'Word Warmup',
        type: 'website',
        url: 'https://word-warmup.fly.dev',
        image: image_url('ogp.png')
      },
      twitter: {
        card: 'summary',
        site: '@ai_24_ai',
        image: image_url('ogp.png'),
        domain: 'https://word-warmup.fly.dev'
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
