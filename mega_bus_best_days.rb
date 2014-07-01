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
end

MegaBusBestDays::example_run
