require 'minitest/autorun'

require 'mega_bus_webkit'

describe MegaBusBestDays::MegaBusWebkitDriver do

  let(:driver) {MegaBusBestDays::MegaBusWebkitDriver.new}
  let(:routes) {MegaBusBestDays::Routes.new}

  it "must have at least England as a country" do
    routes.countries.size.must_be :==, 10
    routes.countries.must_include "England"
  end

end
