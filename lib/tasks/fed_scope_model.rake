namespace :fed_data_model do
  desc "Install/Uninstall fed scope."
  task install: :environment do
  	puts "adding model"

    puts "running migration"
    system "rsync -ruv --exclude=.svn #{File.expand_path('../../app/models app/', __FILE__)} app/"

    ActiveRecord::Migrator.up(File.expand_path('../../db/migrate/', __FILE__))
    puts "Migration done"
  end
  task uninstall: :environment do
    ActiveRecord::Migrator.down(File.expand_path('../../db/migrate/', __FILE__))
  end
end
