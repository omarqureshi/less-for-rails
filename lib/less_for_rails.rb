require 'fileutils'
module LessForRails
  
  STYLESHEETS_PATH = "#{Rails.root}/public/stylesheets"

  extend self
    
  def stylesheet_path
    @stylesheet_path ||= STYLESHEETS_PATH
  end
  
  def run(options = {})
    directories_from(stylesheet_path)
  end
  
  private
  
  def directories_from(path)
    lessify(path)
    Dir["#{path}/**"].each {|dir| directories_from(dir)}
  end
  
  def lessify(path)
    Dir["#{path}/*.less"].each do |less_source|
      destination = File.join(path, "#{File.basename(less_source, File.extname(less_source))}.css")
      if !File.exists?(destination) || File.stat(less_source).mtime > File.stat(destination).mtime
        engine = Less::Engine.new(File.read(less_source))
        css = Less.version > "1.0" ? engine.to_css : engine.to_css(:desc)
        File.open(destination, "w") {|file|
          file.write css
        }
      end
    end
  end
  
end