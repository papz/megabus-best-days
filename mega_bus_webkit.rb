require 'capybara-webkit'
require 'capybara/dsl'
require 'yaml/store'
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
Capybara.run_server = false
Capybara.current_driver = :webkit
Capybara.app_host = "http://uk.megabus.com/"

module MegaBusBestDays

  class MegaBusWebkitDriver
    include Capybara::DSL
    attr_accessor :driver

    def initialize
      visit "http://uk.megabus.com/"
    end

    def fill_form
      puts "filling in pass" if find(:id, "JourneyPlanner_txtNumberOfPassengers")
      fill_in "JourneyPlanner$txtNumberOfPassengers", with: "1"
      puts "filling in #{"JourneyPlanner$hdnSelected"}"
      select('England', :from => "JourneyPlanner_ddlLeavingFromState")
      save_screenshot '/tmp/w1.png'
      sleep 3
      puts "leave found" if find(:id, "JourneyPlanner_ddlLeavingFrom")
      select('Southampton', :from => "JourneyPlanner$ddlLeavingFrom")
      save_screenshot '/tmp/w2.png'
      sleep 3
      puts "to found" if find(:id, "JourneyPlanner_ddlTravellingTo")
      find(:id, "JourneyPlanner_ddlTravellingTo").click
      select('London', :from => "JourneyPlanner$ddlTravellingTo")
      save_screenshot '/tmp/w3.png'
      puts "to outbounddate" if find(:id, "JourneyPlanner_txtOutboundDate")
      fill_in "JourneyPlanner$txtOutboundDate", with: "18/07/2014"
      find(:id, "JourneyPlanner_txtOutboundDate").click
      find(:id, "JourneyPlanner_txtNumberOfPassengers").click
      save_screenshot '/tmp/w32.png'
      puts "to outbounddate" if find(:id, "JourneyPlanner_txtReturnDate").click
      fill_in "JourneyPlanner$txtReturnDate", with: "27/07/2014"
      save_screenshot '/tmp/w4.png'
      find(:id, "searchandbuy").click
      save_screenshot '/tmp/w5.png'
      find(:id, "JourneyPlanner_btnSearch").click
      save_screenshot '/tmp/w5.png'
      @driver
    end

    def get_countries
      find(:id, "JourneyPlanner_ddlLeavingFromState").text.split(' ')
    end

    def store_countries(countries)
      store = YAML::Store.new("countries.yml")
      store.transaction do
        store[:countries] = countries
      end
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
