# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  content    :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Article < ApplicationRecord
    include Elasticsearch::Model

    index_name "es_article_#{Rails.env}"

    settings do
      mappings dynamic: false do
        indexes :id,      type: 'integer'
        indexes :title,   type: 'text', analyzer: 'kuromoji'
        indexes :content, type: 'text', analyzer: 'kuromoji'
      end
    end

    def as_indexed_json(*)
      attributes.symbolize_keys.slice(:id, :title, :content)
    end

    def self.create_index!
      client = __elasticsearch__.client

      client.indices.delete index: self.index_name rescue nil

      client.indices.create(
        index: self.index_name,
        body: {
          settings: self.settings.to_hash,
          mappings: self.mappings.to_hash,
        }
      )
    end

    def self.search(query)
      __elasticsearch__.search({
        query: {
          multi_match: {
             fields: %w(title content),
             type: 'cross_fields',
             query: query,
             operator: 'and'
          }
        },
        size: 1000,
      })
    end
end
