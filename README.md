# 🦆 Ducktrails

Automatically generates breadcrumbs based on routes.

**Warning: This API is still alpha; we welcome PRs and ideas as issues.**

[![Ducktails Theme](http://i.imgur.com/g0PXjHX.png)](https://www.youtube.com/watch?v=CMU2NwaaXEA "Ducktails Theme")

## Usage
For basic applications using a restful architecture, ducktrails should generate the breadcrumbs automatically.

For example, if the uri is `/users/#{user-id}/posts/#{post-id}`

Would render:

`Home / All Users / user-name / All Posts / post-name`

Simply include `= breadcrumbs` in your view. `breadcrumbs` takes a block argument.

Resources are inferred and will be used to manipulate each URI segment. If a resource is not found, Ducktrails will fallback to the URI.

```erb
<%=
  breadcrumbs do
    {
      users: {
        resource: @user,
        key: :first_name,
        collection_prefix: 'Some'
      }
    }
  end
%>
```
Will output

Action | Breadcrumb
---|---
index |`Home / Some Users`
show |`Home / Some Users / Kevin`
new |`Home / Some Users / New`
edit |`Home /Some Users / Kevin / edit`

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ducktrails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ducktrails
```

## Contributing

Please refer to each project's style guidelines and guidelines for submitting patches and additions. In general, we follow the "fork-and-pull" Git workflow.

1. Fork the repo on GitHub
2. Clone the project to your own machine
  1. `bundle`
  2. Create the test db `bundle exec rake --rakefile test/dummy/Rakefile db:setup`
  3. `bundle exec rake` to test.
3. Ensure your test coverage is A+
4. Commit changes to your own branch
5. Push your work back up to your fork
6. Submit a Pull request so that we can review your changes

NOTE: **Be sure to merge the latest from "upstream" before making a pull request!**

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
