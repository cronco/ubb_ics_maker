Simple ruby script to convert a cs.ubbcluj.ro student's schedule to a more
digestable icalendar.

Options
=======

* no_courses - "Ignore courses (why'd you do that?)", :default => true
* no_seminars - "Ignore seminars"
* no_labs - "Ignore labs"
* group - "If you want schedule only for a specific group", :type => String
* output - "Output file name", :default => "school.ics"
