class Fedscope::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/fed_scope_model.rake'
    load 'tasks/fed_scope_download.rake'
    load 'tasks/import_fed_scope_data.rake'
  end
end