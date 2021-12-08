# frozen_string_literal: true

require './app'

if ActiveRecord::Base.connection.migration_context.needs_migration?
  raise 'Migrations are pending, please run rake db:migrate before starting'
end

run Sinatra::Application
