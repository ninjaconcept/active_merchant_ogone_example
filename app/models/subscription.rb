class Subscription < ActiveRecord::Base
  attr_accessible :amount
  validates_presence_of :amount
  validates_numericality_of :amount  
end
