namespace :jasmine do
  task :initialize do
    ENV['JASMINE_CONFIG_PATH'] = "/Users/smiams/Bitsimplicity/projects/mobonotes/mobonotes/jasmine/support/jasmine.yml"
  end

  desc "Compile coffeescript files in the Jasmine test suite"
  task :compile => ["assets:clobber", "assets:precompile", :initialize, :configure] do
    javascript_dir = Jasmine.config.spec_dir
    coffeescript_dir = Jasmine.config.spec_dir.gsub("javascript", "coffeescript")
    Thread.new do
      system "coffee --watch --output #{javascript_dir} #{coffeescript_dir}"
    end
  end  

  desc "Compile coffeescript and boot the Jasmine test suite"
  task :boot => [:compile] do
    Rake::Task["jasmine"].invoke
  end
end