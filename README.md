# Fedscope

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/fedscope`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fedscope'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fedscope

## Usage

TODO: Write usage instructions here

## Development

After bundle run the commend to generate fedscope model and migations.

* rake fed_data_model:install

and then Run Rake task according to need

Export the data
* rake fed_scope_download:download_fed_zip

Import the data
* rake import_def_scope_data:store_data
