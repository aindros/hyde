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

class Page
  attr_reader :title
  attr_reader :pageFileName
  attr_reader :description
  attr_reader :date
  attr_reader :classes
  attr_reader :category

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
