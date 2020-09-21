class ArticlesController < ApplicationController
  def index
    @articles = if search_param.present?
                  Article.where('content like ?', "%#{search_param.gsub(/[\\%_]/) { |m| "\\#{m}" }}%")
                else
                  Article.all
                end
  end

  private

  def search_param
    params.fetch(:q, {})
  end
end
