require_relative 'mega_bus_selenium_driver'

module MegaBusBestDays
  MEGABUS_URL = "http://uk.megabus.com/"
  SEARCH_FORM = "ctl01"
  FIELDS = {
    number_of_passengers: "JourneyPlanner$txtNumberOfPassengers",
    number_of_cencessions: "JourneyPlanner$txtNumberOfConcessionPassenger",
    country: "JourneyPlanner$hdnSelected",
    outbound_date: "JourneyPlanner$txtOutboundDate",
    return_date: "JourneyPlanner$txtReturnDate",
    country: "JourneyPlanner$ddlLeavingFromState",
    leaving_from: "JourneyPlanner$ddlLeavingFrom",
    travelling_to: "JourneyPlanner$ddlTravellingTo",
    travelling_by: "JourneyPlanner$ddlTravellingBy",
    submit: "JourneyPlanner$btnSearch"}

  def self.selenium_example
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

end
