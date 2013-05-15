Simple ruby script to convert a cs.ubbcluj.ro student's schedule to a more
digestable icalendar.

Momentarily you have to modify the script manually to add dates for the start and end of the semester and of the vacation.

Also, only works for student groups timetables for the time being.
Instalation
-----------

Clone the repo and run

```bash
bundle install
```
in your command line.
You'll need ruby and bundler installed on your system.

Usage
-----

Once installed, simply run it with the first option being the url to the timetable page you want to convert
```bash
$ ./ubb_ics_maker.rb http://www.cs.ubbcluj.ro/files/orar/2012-2/tabelar/IIe3.html
```
Options
-------

* no_courses - "Ignore courses (why'd you do that?)", :default => true
* no_seminars - "Ignore seminars"
* no_labs - "Ignore labs"
* group - "If you want schedule only for a specific group", :type => String
* output - "Output file name", :default => "school.ics"

