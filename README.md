
Megabus best days
=================

A script to retrieve the best days to buy a Megabus ticket.  Given a route,
the program will respond with the 'best days' to buy a ticket.  'best days' is
defined by the ticket cost of 1 pound and departure time before 1pm.

Running with selenium
[http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_selenium_and_webkit.html]
* xvfb-run [program ex. irb -I search.rb]

* currently providing basic searching with predefined locations due to mechanize
  library
  for ruby not being able to handle javascript on the page.
* requires phantomjs or some other web driver for javascript interop
