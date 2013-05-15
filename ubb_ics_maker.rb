#! /usr/bin/env ruby
require 'open-uri'
require 'icalendar'
require 'nokogiri'
require 'date'
require 'trollop'

include Icalendar
#cal = Calendar.new

opts = Trollop::options do
  banner <<-EOS
  This will parse a cs.ubbcluj.ro schedule for fun and profit.
  Usage: cal_parser <url> [options]
  where [options] are:
  EOS
  opt :no_courses, "Ignore courses (why'd you do that?)", :default => true
  opt :no_seminars, "Ignore seminars"
  opt :no_labs, "Ignore labs"
  opt :group, "If you want schedule only for a specific group", :type => String
  opt :output, "Output file name", :default => "school.ics"
end

start_date = DateTime.civil(2013, 2, 25, 0, 0, 0, '+2')
end_date = DateTime.civil(2013, 6, 10, 0, 0, 0, '+2')
vacation_start = DateTime.civil(2013, 5, 6, 0, 0, 0, '+2') - 2
vacation_end = DateTime.civil(2013, 5, 13, 0, 0, 0, '+2')

#a course/lab has two hours, in secounds
end_hour = 2 * 60 * 60

cal = Calendar.new

days = ['Luni', 'Marti', 'Miercuri', 'Joi', 'Vineri']
def convert_days(str, days) 
  return days.index(str)
end

doc = Nokogiri::HTML(open(ARGV[0]))
# First column, day
# Second column, hours
# Third column, (frequency, if even or odd week)
# Fourth Column, Where
# Fifth Column, Group
# Sixth Column Type
# Seventh Column Subject
# Eight column Who with

trs = doc.css('tr')
trs.each do |node|
  tds = node.css('td')
  unless tds.empty? 

    start_day = convert_days(tds[0].content, days)
    start_hour = Integer(tds[1].content.split('-').first)
    freq = tds[2].content.split(' ')[1]
    interval = 1
    if freq
      freq = Integer(freq) or 0
      interval = 2
      if freq == 2 
        start_day += 7
      end
    end
    where = tds[3].content
    group = tds[4].content
    type = tds[5].content
    summ = tds[6].css('a').first.content
    who = tds[7].content
     
      
     unless (opts[:no_courses] and type == "Curs") or (opts[:no_labs] and type == "Laborator") or (opts[:no_seminars] and type == "Seminar")
       #until vacation 
       cal.event do
         dtstart    ((start_date + start_day).to_time + (start_hour * 60 * 60)).to_datetime
         dtend      ((start_date + start_day).to_time + ((start_hour + 2) * 60 * 60)).to_datetime
         summary    type + ' ' + summ
         add_recurrence_rule "FREQ=WEEKLY;INTERVAL=#{interval};UNTIL=#{vacation_start.to_ical}"
         location   where
         add_category type
       end
       #after vacation
       cal.event do
         dtstart    ((vacation_end + start_day).to_time + (start_hour * 60 * 60)).to_datetime
         dtend      ((vacation_end + start_day).to_time + ((start_hour + 2) * 60 * 60)).to_datetime
         summary    type + ' ' + summ
         add_recurrence_rule "FREQ=WEEKLY;INTERVAL=#{interval};UNTIL=#{end_date.to_ical}"
         location   where
         add_category type
       end
     end
  end
end
puts cal.to_ical
File.open(opts[:output], 'w') { |file| file.write(cal.to_ical)}
