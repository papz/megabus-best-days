
Megabus best days
=================

A script to retrieve the best days to buy a Megabus ticket.  Given a route,
the program will respond with the 'best days' to buy a ticket.  'best days' is
defined by the ticket cost of 1 pound and departure time before 1pm.

Running with selenium
[http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_selenium_and_webkit.html]
* xvfb-run [program ex. irb -I search.rb]

Running with capybara-webkit
for headless, use of simple capybara dsl and speed.
Requirements:
QtWebKit
linux - sudo apt-get install libqt4-dev

* currently providing basic searching with predefined locations due to mechanize
  library
  for ruby not being able to handle javascript on the page.
* requires phantomjs or some other web driver for javascript interop

todo
----
* command line console menu to select routes and display results
* options to choose date range and criteria for your price and time
* provide an update of previously purchased route and display the difference in price
* fix vulnerabilities
