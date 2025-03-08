## Hot Blog: A Real-Time Blog with Hotwire in Rails 8

Welcome to Hot Blog, a demonstration application designed to explore and master Hotwire technologies in Rails 8. This app showcases real-time updates, seamless navigation, and dynamic interactions powered by Turbo Streams and Stimulus. Whether you're new to Hotwire or looking to deepen your understanding, this is the perfect place to experiment and learn. Let's get started!

..............................................................................
### Table of Contents
[Getting Started](#getting-started)

[Setting Up the Project](#setting-up-the-project)

[User Authentication](#user-authentication)

[Post and Comment Functionality](#post-and-comment-functionality)

[Real-Time Updates with Turbo Streams](#real-time-updates-with-turbo-streams)

[Time Zone Configuration](#time-zone-configuration)

[Current User Management](#current-user-management)

[Routing](#routing)

[Conclusion](#conclusion)

..............................................................................


### [Getting Started](#getting-started)


#### Prerequisites

        Ruby 3.x
        Rails 8.x
        SQLite3 (or your preferred database)

#### Installation

Clone the repository:


    git clone https://github.com/your-username/hot-blog.git
    cd hot-blog

Install dependencies:

    bundle install

Set up the database:

    rails db:setup

Start the server:

    rails server

Visit http://localhost:3000 in your browser.

### [Setting Up the Project](#setting-up-the-project)
#### 1. Create the Rails Application

    rails new blog

#### 2. Create the About Page

    mkdir app/views/about && rails generate controller about index

Update ```app/views/about/index.html.erb```:
```html
<h1>Hot Blog v1</h1>
<p>The Hot Blog is a demonstration application designed to explore and master Hotwire technologies in Rails 8. This app showcases real-time updates, seamless navigation, and dynamic interactions powered by Turbo and Stimulus. Whether you're new to Hotwire or looking to deepen your understanding, this is the perfect place to experiment and learn. Welcome!</p>
```
#### 3. Create the Main Page

    mkdir app/views/main && rails generate controller main index

Update ```app/views/main/index.html.erb```:
```html
<h1>Welcome to Hot Blog!</h1>
<p>Please Sign Up first!</p>
```
#### 4. Configure Routes

Update config/routes.rb:

    Rails.application.routes.draw do
      get "about", to: "about#index"
      root "main#index"
    end


### [User Authentication](#user-authentication)
#### 1. Create the User Model


    rails generate model User email:string password_digest:string
    rails db:migrate

#### 2. Add Password Security

Add ```has_secure_password``` to ```app/models/user.rb```:


    class User < ApplicationRecord
        has_secure_password
    end

Uncomment ```bcrypt``` in your **Gemfile**:


    gem "bcrypt", "~> 3.1.7"

Run bundle install.
#### 3. Add Validations

Update ```app/models/user.rb```:

    validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :password, presence: true, length: { minimum: 6 }, confirmation: true

#### 4. Create a User

In the Rails console:

    User.create(email: "jay@gmail.com", password: "password",     password_confirmation: "password")


### Post and Comment Functionality
#### 1. Generate Post Scaffold

    rails generate scaffold post title body
    rails db:migrate

#### 2. Generate Comment Resource
bash

    rails generate resource comment post:references user:references content:text
    rails db:migrate

#### 3. Set Up Associations

Update ```app/models/post.rb```:


    class Post < ApplicationRecord
      has_many :comments, dependent: :destroy
    end

Update ```app/models/comment.rb```:

    class Comment < ApplicationRecord
      belongs_to :post
      belongs_to :user
    end

### [Real-Time Updates with Turbo Streams](#real-time-updates-with-turbo-streams)
#### 1. Add Turbo Streams to Comments

Update ```app/controllers/comments_controller.rb```:

```ruby
class CommentsController < ApplicationController
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = Current.user

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @post, notice: "Comment created successfully!" }
      end
    else
      redirect_to @post, alert: "Failed to create comment."
    end
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
```

#### 2. Create Turbo Stream Views

Create ```app/views/comments/create.turbo_stream.erb```:
```erb
<%= turbo_stream.append "comments", @comment %>
```

#### 3. Update Post Show View

Update ```app/views/posts/show.html.erb```:
erb
```erb
<%= turbo_stream_from @post %>
<%= render @post %>

<strong>Comments:</strong>
<div id="comments">
  <%= render @post.comments %>
</div>

<%= render "comments/new", post: @post %>
```
### [Time Zone Configuration](#time-zone-configuration)
#### 1. Set Local Time Zone

Update ```config/application.rb```:

```erb
config.time_zone = "America/Porto_Velho"
config.active_record.default_timezone = :local
```
#### 2. Add Local-Time Library

Run:
```bin/importmap pin local-time```

Update ```app/javascript/application.js```:
javascript
```js
import LocalTime from "local-time"
LocalTime.start()
```

### [Current User Management](#current-user-management)
#### 1. Create Current Class

Create ```app/models/current.rb```:

```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :user
end
```

#### 2. Set Current User in Controller

Update ```app/controllers/application_controller.rb```:

```ruby
class ApplicationController < ActionController::Base
  before_action :set_current_user

  private

  def set_current_user
    Current.user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
end
```
### [Routing](#routing)

Update ```config/routes.rb```:
```ruby
Rails.application.routes.draw do
  resources :posts do
    resources :comments
  end

  get "about", to: "about#index"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  delete "sign_out", to: "sessions#destroy"
  root "main#index"
end
```
### [Conclusion](#conclusion)

Congratulations! You've built a real-time blog using Hotwire in Rails 8. This app demonstrates how to create dynamic, fast, and seamless user experiences with minimal code. Feel free to explore further and customize the app to suit your needs.

If you get stuck, check out the repository for reference.

Happy coding! 🚀

Let me know if you need further refinements or additional sections!
## Authors

- [@jaythree](https://github.com/giljr)


## Acknowledgements

 - [Hotwire Intro Series](https://medium.com/jungletronics/hotwire-demo-intro-12afa9eec059)
 - [Hotwire Chat App Series](https://medium.com/jungletronics/hotwire-chat-app-building-a-scalable-infrastructure-with-docker-84a003dc75fd)
 - [Hotwire Demo: Broadcasting](https://medium.com/jungletronics/hotwire-demo-broadcasting-1bbc30599c8f)

