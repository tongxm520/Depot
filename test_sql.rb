class Reading < ActiveRecord::Base
  belongs_to :region,
    inverse_of: :readings
end

class Region < ActiveRecord::Base
  has_many :readings,
    inverse_of: :region

  has_many :stores,
    inverse_of: :region    
end

class Store < ActiveRecord::Base
  belongs_to :region,
    inverse_of: :stores

  belongs_to :manager,
    inverse_of: :stores
end

class Manager < ActiveRecord::Base
  has_many :stores,
    inverse_of: :region

  has_many :emails,
    inverse_of: :manager

  has_many :regions,
    through: :stores
end

class Email < ActiveRecord::Base
  belongs_to :manager,
    inverse_of: :emails
end

=begin
Assuming you want all Reading's matching a given Manager and Region:
@readings = Reading.joins(region: { stores: :manager }).where(
  manager: { name: 'John Smith' },
  region: { id: 1234567 })

Assuming you also want to eager load regions, stores and managers to avoid 1+N queries:
@readings = Reading.includes(region: { stores: :manager }).where(
  manager: { name: 'John Smith' },
  region: { id: 1234567 })

All of the above query examples return ActiveRecord::Relation's which can be further chained with where conditions, or joins, limit, group, having and order etc

You should also consider the differences of joins, includes, preload, eager_load and references methods. There is a brief on them here I would alos encourage you to read docs, guides and blogs about Arel as it supports joins and aliasing too.
=end

Manager.find(:all,
              :joins=>" JOIN stores ON stores.manager_id = managers.id  
                        JOIN regions ON stores.region_id = regions.id  
                        JOIN readings ON readings.region_number = regions.number"
              :conditions=>"managers.name = 'John Smith' AND regions.number = '1234567'"
              :limit=>100)

Manager.joins(stores: {region: :readings}).where('managers.name = ? AND regions.number = ?', 'John Smith', '1234567').limit(100) 


class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :employees
end

class Employee < ActiveRecord::Base
  belongs_to :group
  belongs_to :company
end

class Company < ActiveRecord::Base
  has_many :employees
  has_many :addresses
end

class Address < ActiveRecord::Base
  attr_accessible :city
  belongs_to :company
end

Employee.
  joins(:group).
  where(:groups => { :name => 'admin' })
Employee.
  joins(:company => :addresses).
  where(:addresses => { :city => 'Porto Alegre' })

#note that in the where clauses above the plural form of the association is always used. The keys in the where clauses refer to table names, not the association name.


class Person < ActiveRecord::Base
  self.table_name = "people"
  has_many :tickets,:foreign_key=>:buyer_id
end

class Event < ActiveRecord::Base
  has_many :shows
end

class Show < ActiveRecord::Base
  has_many :tickets
  belongs_to :event
end

class Ticket < ActiveRecord::Base
  belongs_to :buyer,:foreign_key=>:buyer_id,:class_name=>"Person"
  belongs_to :show
end

#How do I find all of the people that have tickets to a specific event?

#people inner join tickets will give you a row for every ticket owned by a person (which will contain duplicate people entries if a person has more than one ticket)
#inner join show will just add the show to the row (assuming every ticket belongs to one show only)
#inner join event will just add the event information (assuming every show belongs to one event only)
#where event.id=1 will leave in the table only the rows with event id 1

Person.joins(tickets: {show: :event}).where("events.id" => 1)


#$ rails g migration ChangeOrdersToOrdered
#db/migrate/change_orders_to_ordered_______.rb
class ChangeOrdersToOrdered < ActiveRecord::Migration
  rename_name :orders, :ordered
end

class User < ActiveRecord::Base
  #source: :follower matches with the belongs_to :follower identification in the Follow model
  has_many :followers,through: :follower_follows,source: :follower

  #follower_follows 'names' the Follow join table for accessing through the follower association
  has_many :follower_follows,foreign_key: :followee_id,class_name: "Follow"

  #source: :followee matches with the belongs_to :followee identification in the Follow model
  has_many :followees,through: :followee_follows,source: :followee

  #followee_follows 'names' the Follow join table for accessing through the followee association
  has_many :followee_follows,foreign_key: :follower_id,class_name: "Follow"
end

class Follow < ActiveRecord::Base
  belongs_to :follower,foreign_key: "follower_id",class_name: "User"
  belongs_to :followee,foreign_key: "followee_id",class_name: "User"
end





