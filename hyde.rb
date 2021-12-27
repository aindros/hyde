#!/usr/local/bin/ruby

require "erb"
require "optparse"
require "yaml"
require 'date'

options = {}
OptionParser.new do |opt|
  opt.on("-f", "--file-name FILENAME", "File name of the page you want to render") {
    |o| options[:fileName] = o
  }
  opt.on("-t", "--title TITLE", "Title of the rendered page") {
    |o| options[:title] = o
  }
  opt.on("-m", "--master MASTER", "Master file page") {
    |o| options[:master] = o
  }
  opt.on("-n", "--page-name NAME", "page name") {
    |o| options[:pageName] = o
  }
end.parse!

#puts options

class Page
  attr_reader :title
  attr_reader :pageFileName
  attr_reader :description
  attr_reader :date
  attr_reader :classes

  def initialize title, pageFileName, pageName, description, date, classes
    @title = title
    @pageFileName = pageFileName
    @pageName = pageName
    @description = description
    @date = date
    @classes = classes
  end

  def render path
    content = File.read(File.expand_path(path))
    t = ERB.new(content)
    t.result(binding)
  end
end

def listarticles(path, max)
  pages = Array.new
  Dir.glob(path).each { |file|
    if (file.end_with?(".rhtml") && File.file?(file))
      config = YAML.load_file(file + '.config')
      file["rhtml"] = "html"
      date = Date.parse(file.gsub(/.*\/(.*)_.*/, '\1'))
      pages.append(Page.new(config['title'], file, nil, config['description'], date, config['classes']))
      max = max - 1
      if (max == 0)
        break
      end
    end
  }

  return pages
end

if(!File.exist?(options[:fileName] + '.config'))
  puts 'Cannot find: ' + options[:fileName] + '.config'
  exit -1
end

config = YAML.load_file(options[:fileName] + '.config')

title = config['title']
pageName = config['pageName']
description = config['description']
classes = config['classes']

page = Page.new(title, options[:fileName], pageName, description, nil, classes)

if options[:master] == nil
  puts page.render("master.rhtml")
else
  puts page.render(options[:master])
end
