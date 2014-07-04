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

    def initialize
      @logger = Logger.new('log/search.log', 'monthly')
      visit "http://uk.megabus.com/"
    end

    def fill_form(num_pass, country, from, to, outbound_date, return_date)
      @logger.info "Filling in number of Passengers with #{num_pass}"
      fill_in "JourneyPlanner$txtNumberOfPassengers", with: num_pass
      @logger.info "Selecting country"
      select(country, :from => "JourneyPlanner_ddlLeavingFromState")
      sleep 3
      @logger.info "Selecting from #{from}"
      select('Southampton', :from => "JourneyPlanner$ddlLeavingFrom")
      sleep 3
      find(:id, "JourneyPlanner_ddlTravellingTo").click
      @logger.info "Selecting to #{to}"
      select(to, :from => "JourneyPlanner$ddlTravellingTo")
      @logger.info "Fill in outbound date"
      fill_in "JourneyPlanner$txtOutboundDate", with: outbound_date
      find(:id, "JourneyPlanner_txtOutboundDate").click
      find(:id, "JourneyPlanner_txtNumberOfPassengers").click
      fill_in "JourneyPlanner$txtReturnDate", with: return_date
      find(:id, "searchandbuy").click
      @logger.info "Submit"
      find(:id, "JourneyPlanner_btnSearch").click
    end

    def list_countries
      all(:xpath, '//select[@id="JourneyPlanner_ddlLeavingFromState"]/option')
        .map {|e| e.text }
    end

    def list_leaving_from
      all(:xpath, '//select[@id="JourneyPlanner_ddlLeavingFrom"]/option')
        .map {|e| e.text }
    end

    def list_leaving_to
      all(:xpath, '//select[@id="JourneyPlanner_ddlTravellingTo"]/option')
        .map {|e| e.text }
    end

    def store_search_data(countries, from, to)
      store = YAML::Store.new("search_data.yml")
      store.transaction do
        store[:countries] = countries
        store[:from] = from
        store[:to] = to
      end
    end

  end

end
