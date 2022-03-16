# A simple website generator
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

def optparse
  options = {}
  optparse = OptionParser.new do |opt|
    opt.on("-f", "--file-name FILENAME", "File name of the page you want to render") {
      |o| options[:fileName] = o
    }
    opt.on("-t", "--title TITLE", "Title of the rendered page") {
      |o| options[:title] = o
    }
    opt.on("-m", "--master MASTER", "Master file page") {
      |o| options[:master] = o
    }
    opt.on("-n", "--page-name NAME", "Page name") {
      |o| options[:pageNames] = o
    }
    opt.on_tail("-h", "--help", "Show this message") do
      puts opt
      exit
    end
  end

  if ARGV.length < 1 then
    puts optparse.help
    exit 1
  end

  optparse.parse!

  return options

end
