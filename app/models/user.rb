# frozen_string_literal: true

class User < ApplicationRecord
  def self.find_or_create_from_auth_hash!(auth_hash)
    uid = auth_hash[:uid]
    name = auth_hash[:info][:name]

    find_or_create_by!(uid:) do |user|
      user.name = name
    end
  end
end
