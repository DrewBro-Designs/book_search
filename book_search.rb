require "./settings.rb"

class BookSearch
  attr_reader :books

  def initialize(keyword)
    @books = find_books(keyword)
  end

  private

    def find_books(keyword)
      books = {}
      response = Amazon::Ecs.item_search(keyword, {response_group: 'Medium', sort: 'salesrank'})
      response.items.each do |item|
        item_attributes = item.get_element('ItemAttributes')
        title = item_attributes.get('Title')
        books[title] = {authors: item_attributes.get_array('Author')}
      end
      books
    end
end
