class Committee < ActiveRecord::Base
  has_many :posts, primary_key: :slug, foreign_key: :group_id
  translates :title, :description
  globalize_accessors

  validates :slug, :name, *globalize_attribute_names, :url, :email, presence: true
  validates :slug, :name, uniqueness: true

  def to_param
    slug
  end
  def positions
    Rails.cache.fetch("positions/#{self.slug}", expires_in: 30.minutes) do
      group = open(Rails.configuration.account_ip+"/groups/#{slug}.json",
      'Authorization' => "Bearer #{Rails.application.secrets.client_credentials}")
      JSON.parse(group.read)["positions"].map { |i| i.split(';').reverse }.to_h
    end
  end
end
