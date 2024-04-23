#!/usr/local/bin/ruby

# A static website generator
# Copyright (C) 2022  Alessandro Iezzi <aiezzi AT alessandroiezzi DOT it>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

require "erb"
require "optparse"
require "yaml"
require 'date'

require_relative 'page.rb'
require_relative 'optparser.rb'

class Hyde
	def self.main
	end
end

=begin
Considerations on file formats.
  .config -- Are configurations, written in YAML
  .tmpl   -- Are templates, they don't need configuration files
=end

def listarticles(path, max)
  pages = Array.new
  Dir.glob(path).each { |file|
    if (file.end_with?(".rhtml") && File.file?(file))
      config = YAML.load_file(file + '.config')
      file["rhtml"] = "html"
      date = Date.parse(file.gsub(/.*\/(.*)_.*/, '\1'))
      pages.append(Page.new(config['title'], file, nil, config['description'], date, config['classes'], nil))
      max = max - 1
      if (max == 0)
        break
      end
    end
  }

  return pages
end

# Parse arguments from the CLI
options = optparse

# Every file needs a config file. It is similar to the YAML block in head to files processed by gohugo or jekyll.
configfile = options[:fileName] + '.config'

if(!File.exist?(configfile) && !options[:fileName].end_with?("tmpl"))
  puts 'Cannot find configuration file: ' + configfile
  exit 1
end

if(File.exist?(configfile))
  config = YAML.load_file(configfile)

  if(config != nil)
    title = config['title']
    pageNames = config['pageNames']
    description = config['description']
    classes = config['classes']
    master = config['master']
    category = config['category']
  end
end

page = Page.new(title, options[:fileName], pageNames, description, nil, classes, category)

if (options[:master] != nil)
  master = options[:master]
end

if (options[:master] == nil && master == nil)
  master = "master.rhtml"
end

if (master.kind_of?(Array))
  i = 0
  filesToDelete = Array.new
  fileName = nil
  master.each { |m|
    fileName = options[:fileName] + "." + i.to_s + ".tmp";
    filesToDelete.append(fileName)
    output = File.open(fileName, "w")
    output << page.render(m)
    page = Page.new(title, fileName, pageNames, description, nil, classes, category)
    output.close
    i = i + 1
  }

  if (fileName != nil)
    output = File.open(fileName)
    puts output.read
    output.close
  end

  filesToDelete.each { |f|
    File.delete(f) if File.exist?(f)
  }

else
  puts page.render(master)
end



