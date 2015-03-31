require 'test_helper'
 
class EventTest < ActiveSupport::TestCase
  
  test "one simple test example" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
 
    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "recurring and non recurring openings" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-07 12:30"), ends_at: DateTime.parse("2014-08-07 16:00"), weekly_recurring: true
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-14 08:00"), ends_at: DateTime.parse("2014-08-14 13:00"), weekly_recurring: false
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 11:30")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-14 13:00"), ends_at: DateTime.parse("2014-08-14 13:30")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-14 14:30"), ends_at: DateTime.parse("2014-08-14 15:00")
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-14 08:30"), ends_at: DateTime.parse("2014-08-14 09:00")

    availabilities = Event.availabilities DateTime.parse("2014-08-10")
    assert_equal Date.new(2014, 8, 10), availabilities[0][:date]
    assert_equal [], availabilities[0][:slots]
    assert_equal Date.new(2014, 8, 11), availabilities[1][:date]
    assert_equal ["9:30", "10:00", "11:30", "12:00"], availabilities[1][:slots]
    assert_equal Date.new(2014, 8, 14), availabilities[4][:date]
    assert_equal ["8:00", "9:00", "9:30", "10:00", "10:30", "11:00", "11:30", "12:00", "12:30", "13:30", "14:00", "15:00", "15:30"], availabilities[4][:slots]
    assert_equal Date.new(2014, 8, 16), availabilities[6][:date]
    assert_equal 7, availabilities.length
  end

  test "recurring appointment" do
    Event.create kind: 'opening', starts_at: DateTime.parse("2014-08-04 09:30"), ends_at: DateTime.parse("2014-08-04 12:30"), weekly_recurring: true
    Event.create kind: 'appointment', starts_at: DateTime.parse("2014-08-11 10:30"), ends_at: DateTime.parse("2014-08-11 12:00"), weekly_recurring: true
    availabilities = Event.availabilities DateTime.parse("2014-08-18")
    assert_equal ["9:30", "10:00", "12:00"], availabilities[0][:slots]
  end 

end
