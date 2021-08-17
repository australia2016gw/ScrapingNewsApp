class NewsController < ApplicationController

require './lib/tasks/scrape_news'

  def index
    @hash = scrape_news(nil)
    @title_ary = @hash.keys
    @link_ary = @hash.values
  end
  
  def search
    @hash = scrape_news(params[:search])
    @title_ary = @hash.keys
    @link_ary = @hash.values
    render :index
  end
end
