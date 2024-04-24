# A static website generator
# Copyright (C) 2022-2024  Alessandro Iezzi <aiezzi AT alessandroiezzi DOT it>
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

class Page
  attr_reader :pageFileName

	attr :fileName
	attr :title
	attr :pageNames
	attr :description
	attr :date
	attr :classes
	attr :category
	attr :master
	attr :baseHref

	def initialize(fileName, date = nil, baseHref = nil)
		@fileName = fileName
		@date     = date
		@baseHref = baseHref
		parseConfig(fileName + '.config')
	end

	def includeFile(fileName)
		t = ERB.new(File.read(File.expand_path(fileName)))
		return t.result(binding)
	end

	def render
		if (@master != nil)
			t = ERB.new(File.read(File.expand_path(@fileName)))

			masterPage = Page.new(@master)
			masterPage.title       = @title
			masterPage.pageNames   = @pageNames
			masterPage.description = @description
			masterPage.date        = @date
			masterPage.classes     = @classes
			masterPage.baseHref    = @baseHref
			masterPage.content = t.result(binding)
			masterPage.render
		else
			content = File.read(File.expand_path(@fileName))
			t = ERB.new(content)
			print t.result(binding)
		end
	end

	private

	def parseConfig(configFile)
		if (File.exist?(configFile))
			config = YAML.load_file(configFile)
			if (config != nil)
				@title       = config['title']
				@pageNames   = config['pageNames']
				@description = config['description']
				@classes     = config['classes']
				@master      = config['master']
				@category    = config['category']
				if (@date == nil)
					@date = config['date']
				end
				if (@baseHref == nil)
					@baseHref= config['baseHref']
				end
			end
		end
	end

	def renderContent
		return @content&.strip || @content
	end

	protected

	attr_writer :fileName
	attr_writer :title
	attr_writer :pageNames
	attr_writer :description
	attr_writer :date
	attr_writer :classes
	attr_writer :category
	attr_writer :master
	attr_writer :content
	attr_writer :baseHref

  def initialize1 title, pageFileName, pageNames, description, date, classes, category
    @title = title
    @pageFileName = pageFileName
    @pageNames = pageNames
    @description = description
    @date = date
    @classes = classes
    @category = category
  end

  def render1 path
    content = File.read(File.expand_path(path))
    t = ERB.new(content)
    t.result(binding)
  end
end
