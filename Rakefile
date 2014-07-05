require File.join(File.expand_path('.'),'mega_bus_webkit')

task :store_routes do
  m = MegaBusBestDays::MegaBusWebkitDriver.new
  m.store_search_data(m.routes)
end
