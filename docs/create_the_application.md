# Create a Ruby Application  

For this example, we'll build a web application ([Book Search](https://github.com/DrewBro-Designs/book_search.rb)) that serves a search form, then returns a list of books using the [amazon-ecs](https://github.com/jugend/amazon-ecs) gem, and an example from the [Ruby Cookbook, 2nd edition](http://www.amazon.com/Ruby-Cookbook-Lucas-Carlson/dp/1449373712).  
  
```ruby
# Sample Code From:
#
# 18.1 Searching for Books on Amazon
# Ruby Cookbook, Second Edition, by Lucas Carlson
# and Leonard Richardson. Copyright 2015 Lucas Carlson
# and Leonard Richardson, 978-1-449-37371-9
require 'amazon/ecs'

Amazon::Ecs.configure do |options|
  options[:associate_tag] = '' # AWS associate tag
  options[:AWS_access_key_id] = '' # AWS access key id
  options[:AWS_secret_key] = ''# AWS secret access key
end

def price_books(keyword)
  response = Amazon::Ecs.item_search(keyword, {response_group: 'Medium', sort: 'salesrank'})
  response.items.each do |product|
    if product.get_element('ItemAttributes/listPrice')
      new_price = product.get_element('ItemAttributes/ListPrice').get('FormattedPrice')
      if product.get_element('LowestUsedPrice').nil?
        used_price = 'not available'
      else
        used_price = product.get_element('LowestUsedPrice').get('FormattedPrice')
      end
      puts "#{product.get('ItemAttributes/Title')}: #{new_price} new, #{used_price} used."
    end
  end
end

price_books('ruby')
```
  
You'll also need to have the following AWS Credentials  

  * [AWS access key id](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
  * [AWS secret access key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html)
  * [AWS associate tag](http://docs.aws.amazon.com/AWSECommerceService/latest/DG/becomingAssociate.html)

## Building the App
Let's start out with a Sinatra app. We want to have a search form that takes a search term and returns a list of books available on Amazon.  
  
So, we'll need to be able to handle a get and a post request on our home page.
```ruby
# app.rb

# Book Search App
#
# Maintainer: Drew Ogryzek <drew@drewbro.com>
#
# Display a form, and use the amazon-ecs gem to search amazon
# for books based on the search criteria (note: This search
# seems really wonky to me).
require 'sinatra'
require './book_search.rb'

get '/' do
  erb :search_form, layout: :default
end

post '/' do
  @search_term = params[:search_term]
  @books = BookSearch.new(@search_term).books
  erb :results, layout: :default
end
```
Add some views to display an input form, and the search results
```erb
<% # views/default.erb %>

<!DOCTYPE html>

<meta charset="UTF-8">

<title>AWS ECS Gem Sample App</title>

<%= yield %>
```
```erb
<% # views/search_form.erb %>

<h1>Search for Books on Amazon</h1>

<form method="post">
  <input type="text" name="search_term"></br>
  <input type="submit">
</form>
```
```erb
<% # views/results.erb %>

<h1>Results for Search Term "<%= @search_term %>"</h1>

<table>
  <tr>
    <th>title</th>
    <th>author(s)</th>
  </tr>
  <% @books.each do |title, authors| %>
    <tr>
      <td><%= title %></td>
      <td><%= authors[:authors].join(', ') %></td>
    </tr>
  <% end %>
</table>
```
Add a `book_search.rb` model
```ruby
# book_search.rb
require "./config.rb"

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
```
Add the `config.rb` with the AWS configuration options that we just required in the `book_search.rb` file, substituting the empty strings with the appropriate credentials.
```ruby
require 'amazon/ecs'

Amazon::Ecs.configure do |options|
  options[:associate_tag] = '' # AWS Associate Tag
  options[:AWS_access_key_id] = '' # AWS access key id
  options[:AWS_secret_key] =  '' # AWS Secret Key
end
```
We should be able to run the app with `ruby app.rb -p 3000`, and view it on our [localhost](http://locahost:3000)
