namespace :fed_data_model do
  desc "Install/Uninstall fed scope."
  task install: :environment do
  	puts "adding model"

    puts "running migration"
    system "rsync -ruv --exclude=.svn ../../app/models app/"

    ActiveRecord::Migrator.up("../../db/migrate")
    puts "Migration done"
  end
  task uninstall: :environment do
    ActiveRecord::Migrator.down("../../db/migrate")
  end
end