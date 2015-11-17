# Book Search
Adaptation of 18.1 the [Ruby Cookbook, 2nd Edition](http://www.amazon.com/Ruby-Cookbook-Lucas-Carlson/dp/1449373712), using [sinatra](http://www.sinatrarb.com/) and [amazon-ecs](https://github.com/jugend/amazon-ecs) gems.

## Installation
Make sure to have dependencies installed, which include Ruby, and the sinatra and amazon-ecs gems.  
  
**Note**: Add your AWS credentials to the settings.rb

```shell
git clone git@github.com:drewbro-designs/book_search.git && cd book_search
cp settings.rb.example settings.rb # add AWS credentials
bundle install
rackup -p 3000
```
If everything went well, you should be able to view the app at your [localhost](http://localhost:3000) on port 3000.

## Running as Docker Container
To run this as a docker container, make sure to have [Docker installed](https://docs.docker.com/linux/step_one/).
```
docker build -t book_search .
docker run -p 3000:3000 book_search
```
It should then be viewable though a browser at "`your docker container ip`" on port 3000.
