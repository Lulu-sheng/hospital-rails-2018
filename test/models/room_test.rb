
require 'test_helper'

class RoomTest < ActiveSupport::TestCase
    test "wing test" do
        room = Room.new(wing:'love')
        assert room.invalid?
        assert_equal ["must be a valid wing (north, south, east, or west)"], room.errors[:wing]
    end

    test "floor numericality" do
        room = Room.new(floor:233.4)
        assert room.invalid?
        assert_equal ["floor must be between 1 and 4 and only integer"], room.errors[:floor]

        room2 = Room.new(floor:5)
        assert room2.invalid?
        assert_equal ["floor must be between 1 and 4 and only integer"], room.errors[:floor]

        room = Room.new(floor:0)
        assert room.invalid?
        assert_equal ["floor must be between 1 and 4 and only integer"], room.errors[:floor]
    end

    test "patients association" do
        assert_equal 3, rooms(:one).patients.size
    end

    test "valid vip" do
        room = Room.new
        assert room.invalid?
        assert room.errors[:vip].any?
    end

    test "valid room number" do
        room = Room.new(number: 123.3)
        assert room.invalid?
        assert room.errors[:number].any?

        room = Room.new(number: -123)
        assert room.invalid?
        assert room.errors[:number].any?

        room = Room.new(number: 600)
        assert room.invalid?
        assert room.errors[:number].any?

        room = Room.new(number: rooms(:one).number)
        assert room.invalid?
        assert room.errors[:number].any?
    end
=begin
validates :wing, inclusion: { in: %w(north south east west), message: "must be a valid wing (north, south, east, or west)" }
    validates :floor, numericality: {greater_than: 0, less_than: 5, only_integer: true, message: "floor must be between 1 and 4 and only integer"} 
    validates :number, numericality: {only_integer: true, greater_than:0, less_than:500}, uniqueness: true
    validates :vip, presence: true
=end
  # test "the truth" do
  #   assert true
  # end
end
