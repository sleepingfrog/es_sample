class ArticlesController < ApplicationController
  def index
    @articles = if search_param.present?
                  Article.search(search_param).records
                else
                  Article.all
                end
  end

  private

  def search_param
    params.fetch(:q, {})
  end
end
