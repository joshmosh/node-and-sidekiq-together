require "bundler/setup"
Bundler.require(:default)

Dotenv.load

Mongoid.load!("config/mongoid.yml", :development)

class Person
  include Mongoid::Document

  field :first_name, type: String
  field :last_name, type: String
  field :processed, type: Boolean, default: false
  field :created_at, type: DateTime, default: lambda { Time.now }
  field :updated_at, type: DateTime, default: lambda { Time.now }
end

class FetchAndUpdatePersonWorker
  include Sidekiq::Worker

  def perform(person_id)
    person = Person.find(person_id)
    person.update(processed: true, updated_at: Time.now)

    puts "Updated #{person.first_name} #{person.last_name} to processed: #{person.processed} at #{person.updated_at.to_s}"
  end
end
