require 'rake'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push "lib"
  t.test_files = FileList['specs/*_spec.rb']
  t.verbose = true
end

task :store_routes do
  m = MegaBusBestDays::MegaBusWebkitDriver.new
  m.store_search_data(m.routes)
end
