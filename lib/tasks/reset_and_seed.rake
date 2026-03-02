namespace :db do
  desc "Drop, create, migrate, load Solid Queue schema, and seed"
  task reset_and_seed: :environment do
    puts "💥 Terminating existing database connections..."
    db_name = Rails.configuration.database_configuration[Rails.env]["database"]
    terminate_query = %(psql -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '#{db_name}' AND pid <> pg_backend_pid();")
    system(terminate_query)

    puts "Dropping database..."
    Rake::Task["db:drop"].invoke

    puts "Creating database..."
    Rake::Task["db:create"].invoke

    puts "Running migrations..."
    Rake::Task["db:migrate"].invoke

    puts "Seeding..."
    Rake::Task["db:seed"].invoke

    puts "✅ Reset and seeding complete!"
  end
end
