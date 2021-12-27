#!/usr/local/bin/ruby

require "erb"
require "optparse"
require "yaml"

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
  def initialize title, pageFileName, pageName
    @title = title
    @pageFileName = pageFileName
    @pageName = pageName
  end

  def render path
    content = File.read(File.expand_path(path))
    t = ERB.new(content)
    t.result(binding)
  end
end

if(!File.exist?(options[:fileName] + '.config'))
  puts 'Cannot find: ' + options[:fileName] + '.config'
  exit -1
end

config = YAML.load_file(options[:fileName] + '.config')

title = config['title']
pageName = config['pageName']

page = Page.new(title, options[:fileName], pageName)

if options[:master] == nil
  puts page.render("master.rhtml")
else
  puts page.render(options[:master])
end
