class Room < ApplicationRecord
    has_many :patients

    validates :wing, inclusion: { in: %w(north south east west), message: "must be a valid wing (north, south, east, or west)" }
    validates :floor, numericality: {greater_than: 0, less_than: 5, only_integer: true, message: "floor must be between 1 and 4 and only integer"} 
    validates :number, numericality: { only_integer: true, greater_than:0, less_than:500}, uniqueness: true
    validates :vip, inclusion: {in: [false, true] }

end
