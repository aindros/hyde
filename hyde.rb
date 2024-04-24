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
	def self.listarticles(path, max)
		pages = Array.new
		Dir.glob(path).each { |file|
			if (file.end_with?(".rhtml") && File.file?(file))
				date = Date.parse(file.gsub(/.*\/(.*)_.*/, '\1'))
				pages.append(Page.new(file, date))
				max = max - 1
				if (max == 0)
					break
				end
			end
		}

		return pages
	end

	def self.main
		# Parse arguments from the CLI
		options = HydeOptionParser.parse
		page = Page.new(options[:fileName], nil, options[:baseHref])
	end
end

Hyde.main
exit

=begin
Considerations on file formats.
  .config -- Are configurations, written in YAML
  .tmpl   -- Are templates, they don't need configuration files
=end






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



