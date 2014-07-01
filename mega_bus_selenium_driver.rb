require 'selenium-webdriver'

################################################
# A basic web scraper for the Megabus web interface
#
# It currently uses selenium webdriver to automate
# the process of filling in the dynamic form.
#
# This is just a spike to try out selenium-webdriver.
# Had some trouble when the form would update on selection,
# when 'Element is no longer attached to the DOM'.
# So I allowed for some time for the browser to update the
# DOM.  I would rather have 'wait' blocks, but they
# did not make a difference.  I suspect my check element
# statement did not have the behaviour I was expecting.
#
# Headless selenium requires a bit more effort than
# using a webkit enabled library.
# Requirements:
# firefox > 4
# xvfb - to install see (http://tutorials.jumpstartlab.com/topics/capybara/capybara_with_selenium_and_webkit.html)
# To run headless, in an irb session:
# xvfb-run irb -r ./search.rb
# MBD::example_run
#
# The ::example_run will search based on default values
# 1 passenger, from: Southampton, to: London
# outbound_date: "17/07/2014", return_date: "26/07/2014"
# Then return the page source of the results to parse.
################################################

module MegaBusBestDays

  def self.example_run
    mbd = MegaBusBestDays::MegaBusSeleniumDriver.new
    mbd.set_number_of_passengers(1)
    mbd.set_country("England")
    mbd.set_leaving_from("Southampton")
    mbd.set_travelling_to("London")
    mbd.set_outbound_date
    mbd.set_return_date
    mbd.submit
    mbd.results
  end

  class MegaBusSeleniumDriver
    attr_accessor :driver

    def initialize
      @driver = Selenium::WebDriver.for :firefox
      @driver.manage.timeouts.implicit_wait = 10
      @driver.navigate.to MEGABUS_URL
    end

    def set_number_of_passengers(num)
      e = @driver.find_element(:name, MegaBusBestDays::FIELDS[:number_of_passengers])
      e.clear
      e.send_keys num
    end

    def list_countries
      @driver.find_elements( :tag_name => "option").map(&:text)
    end

    def set_country(country = "England")
      e = @driver.find_element(:name, MegaBusBestDays::FIELDS[:country])
      e.find_elements( :tag_name => "option").find { |o| o.text == country}.click
    end

    def selected_country?
      @driver
        .find_elements( :tag_name => "option")
        .map {|e| e if e.selected? }.compact[0].text
    end

    def list_leaving_from
      e = @driver
        .find_element(:name, "JourneyPlanner$ddlLeavingFrom")
        .find_elements( :tag_name => "option")
    end

    def set_leaving_from(from = "Southampton")
      sleep 2
      element = @driver
        .find_element(:name, "JourneyPlanner$ddlLeavingFrom")
        .find_elements( :tag_name => "option")
        .find { |o| o.text == from }.click
    end

    def list_travelling_to
      @driver
        .find_element(:name, MegaBusBestDays::FIELDS[:travelling_to])
        .find_elements( :tag_name => "option")
        .map(&:text)
    end

    def set_travelling_to(to = "London")
      sleep 2
      @driver
        .find_element(:name, MegaBusBestDays::FIELDS[:travelling_to])
        .find_elements( :tag_name => "option")
        .find { |o| o.text == to }
        .click
    end

    def set_outbound_date(date = "17/07/2014")
      sleep 4
      e = @driver.find_element(:name, MegaBusBestDays::FIELDS[:outbound_date])
      e.clear
      e.send_keys date
      e.send_keys :enter
    end

    def set_return_date(date = "26/07/2014")
      sleep 2
      e =  @driver.find_element(:name, MegaBusBestDays::FIELDS[:return_date])
      e.clear
      e.send_keys date
      e.send_keys :enter
    end

    def submit
      @driver.find_element(:name, MegaBusBestDays::FIELDS[:submit]).click
    end

    def results
      @driver.page_source
    end

    def quit
      @driver.quit
    end

  end
end
