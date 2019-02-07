namespace :fed_data_model do
  desc "Install/Uninstall fed scope."
  task install: :environment do
  	puts "adding model"

    puts "running migration"
    system "rsync -ruv --exclude=.svn vendor/gems/fedscope/app/models app/"

    ActiveRecord::Migrator.up("vendor/gems/fedscope/db/migrate")
    puts "Migration done"
  end
  task uninstall: :environment do
    ActiveRecord::Migrator.down("vendor/gems/fedscope/db/migrate")
  end
end