namespace :db do
  desc "Complete reset of the TIRS environment for demo purposes"
  task reset_demo: :environment do
    puts "💥 Terminating existing database connections..."
    db_name = Rails.configuration.database_configuration[Rails.env]["database"]
    terminate_query = %(psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '#{db_name}' AND pid <> pg_backend_pid();")
    system(terminate_query)

    puts "Stopping the world..."
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rake::Task["db:migrate"].invoke

    puts "Clearing storage..."
    FileUtils.rm_rf(Rails.root.join("storage"))
    FileUtils.mkdir_p(Rails.root.join("storage"))

    puts "TIRS is now in a clean, forensic-ready state."
  end
end
