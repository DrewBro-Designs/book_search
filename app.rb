# Book Search App
#
# Maintainer: Drew Ogryzek <drew@drewbro.com>
#
# Display a form, and use the amazon-ecs gem to search amazon
# for books based on the search criteria (note: This search
# seems really wonky to me).
require './book_search.rb'

class App < Sinatra::Base
  get '/' do
    erb :search_form, layout: :default
  end

  post '/' do
    @search_term = params[:search_term]
    @books = BookSearch.new(@search_term).books
    erb :results, layout: :default
  end
end
