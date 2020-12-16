# Active Admin Caxlsx (Alpha version)

- Upgraded activeadmin-axlsx to work with most recent version of Caxlsx.

## Notice: Community Axlsx Organization

To better maintain the Axlsx ecosystem, all related gems have been forked or moved to the following community organization: http://github.com/caxlsx

[Join the Caxlsx Slack channel](https://join.slack.com/t/caxlsx/shared_invite/enQtOTI5OTM0MzI1Njk5LTBlMDQzNDk2YzkwODMxMmVkODMyYzJiZGU5NTQ3YTg5NTBlN2IwZTlmNTRjNzhiY2E0MDY2OTEyYmFlODI5NjA)

## Synopsis

This gem provides automatic OOXML (xlsx) downloads for Active Admin
resources. It lets you harness the full power of Caxlsx when you want to
but for the most part just stays out of your way and adds a link next to
the csv download for xlsx (Excel/numbers/Libre Office/Google Docs)

![Screen 1](https://raw.githubusercontent.com/caxlsx/caxlsx/master/examples/sample.png)

## Install
Add the following to your Gemfile

```
gem 'activeadmin-caxlsx', git: 'https://github.com/KRaikk/activeadmin-caxlsx'
```

For Active Admin 1.0 and above, you will also have to update config/initializers/active_admin.rb. Update the download_links setting to include xlsx:

```
config.download_links = %i[csv xml json xlsx]
```


## Localize Column Headers

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.i18n_scope = [:active_record, :models, :posts]
end
```

## Use Blocks For Adding Computed Fields

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.column('author_name') do |resource|
    resource.author.name
  end
end
```

## Change The Column Header Style

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.header_style = { :bg_color => 'FF0000',
                                       :fg_color => 'FF' }
end
```

## Remove Columns

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.delete_columns :id, :created_at, :updated_at
end
```

## Using the DSL

Everything that you do with the config'd default builder can be done via
the resource DSL.

Below is an example of the DSL

```ruby
ActiveAdmin.register Post do

  # i18n_scope and header style are set via options
  xlsx(:i18n_scope => [:active_admin, :axlsx, :post],
       :header_style => {:bg_color => 'FF0000', :fg_color => 'FF' }) do

    # Specify that you want to white list column output.
    # whitelist

    # Do not serialize the header, only output data.
    # skip_header

    # deleting columns from the report
    delete_columns :id, :created_at, :updated_at

    # adding a column to the report
    column(:author) { |resource| "#{resource.author.first_name} #{resource.author.last_name}" }

    # creating a chart and inserting additional data with after_filter
    after_filter { |sheet|
      sheet.add_row []
      sheet.add_row ['Author Name', 'Number of Posts']
      data = []
      labels = []
      User.all.each do |user|
        data << user.posts.size
        labels << "#{user.first_name} #{user.last_name}"
        sheet.add_row [labels.last, data.last]
      end
      chart_color =  %w(88F700 279CAC B2A200 FD66A3 F20062 C8BA2B 67E6F8 DFFDB9 FFE800 B6F0F8)
      sheet.add_chart(::Axlsx::Pie3DChart, :title => "post by author") do |chart|
        chart.add_series :data => data, :labels => labels, :colors => chart_color
        chart.start_at 4, 0
        chart.end_at 7, 20
      end
    }

    # inserting data with before_filter
    before_filter do |sheet|
      sheet.add_row ['Created', Time.zone.now]
      sheet.add_row []
    end
  end
end
```

## Specs

Running specs for this gem requires that you construct a rails application.
To execute the specs, navigate to the gem directory, then run bundle install and run these two rake tasks:

```
bundle exec rake setup
bundle exec rake
```

## Credits

Originally created by Randy Morgan - @randym

Forked in 2020, to enable the community to maintain the Caxlsx ecosystem - http://github.com/caxlsx

Open source software is a community effort. None of this could have been done without the help of [our Contributors](https://github.com/caxlsx/activeadmin-caxlsx/graphs/contributors).
