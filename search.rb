
require 'mechanize'

module MBD
  MEGABUS_URL = "http://uk.megabus.com/"
  SEARCH_FORM = "ctl01"
  FIELDS = {
    number_of_passengers: "JourneyPlanner$txtNumberOfPassengers",
    number_of_cencessions: "JourneyPlanner$txtNumberOfConcessionPassenger",
    country: "JourneyPlanner$hdnSelected",
    outbound_date: "JourneyPlanner$txtOutboundDate",
    return_date: "JourneyPlanner$txtReturnDate",
    leaving_from: "JourneyPlanner$ddlLeavingFromState",
    travelling_to: "JourneyPlanner$ddlTravellingTo",
    travelling_by: "JourneyPlanner$ddlTravellingBy"}

  class Agent
    def initialize()
      @agent = Mechanize.new()
      @agent.user_agent_alias = "Mac Safari"
      @agent.get(MEGABUS_URL)
    end
  end

  class Search

    def initialize(agent, passengers)
      @agent = agent
      @passengers = passengers
    end

    def set_form

    end

    def set_number_passengers(num)
      @agent.page.forms[0].fields.select {|e| e.name == MBD::FIELDS[:number_of_passengers]}.first.value = "1"
    end

    def set_travelling_from
      @agent.page.forms.first.fields.select {|e| e.type = "hidden"}.map {|e| [e.name, e.value]}.reject {|e| e[1] == nil }.push ["__ASYNCPOST", "true"]
    end

    def set_outbound_date
      @agent.page.form.fields.select {|e| e.name == MBD::FIELDS[:outbound_date]}.first.value = "17/07/2014"
    end

    def set_return_date
      @agent.page.form.fields.select {|e| e.name == MBD::FIELDS[:return_date]}.first.value = "26/07/2014"
    end

    def list_countries
      @agent.page.form.fields.select {|e| e.name == "JourneyPlanner$ddlLeavingFromState"}.first.options.map {|e| e.text}
    end

    #lists all locations, not grouped by country
    def list_leaving_from
      @agent.page.forms[0].fields.select {|e| e.name == "JourneyPlanner$ddlLeavingFrom" }.first.options.map {|e| e.text }[1..-1]
    end

    def list_travelling_to
      @agent.page.forms[0].fields.select {|e| e.name == "JourneyPlanner$ddlTravellingTo" }.first.options.map {|e| e.text }[1..-1]
    end

    def choose_england()
      @agent.page.form.fields.select {|e| e.name == "JourneyPlanner$ddlLeavingFromState"}.first.options[2].click
    end

    def choose_leaving_from(index)
      @agent.page.forms[0].fields.select {|e| e.name == "JourneyPlanner$ddlLeavingFrom" }.first.options[index].click
    end

    def choose_leaving_from(index)
      @agent.page.forms[0].fields.select {|e| e.name == "JourneyPlanner$ddlTravellingTo" }.first.options[index].click
    end

    def choose_(index)
      m.page.forms[0].fields.select {|e| e.name == "JourneyPlanner$ddlLeavingFrom" }.first.options[index].click
    end
  end
end

class UI

  def initialize(number_of_passengers)
  end
end
