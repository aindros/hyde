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
    |o| options[:pageNames] = o
  }
end.parse!

#puts options

class Page
  attr_reader :title
  attr_reader :pageFileName
  attr_reader :description
  attr_reader :date
  attr_reader :classes
  attr_reader :category

  def initialize title, pageFileName, pageNames, description, date, classes, category
    @title = title
    @pageFileName = pageFileName
    @pageNames = pageNames
    @description = description
    @date = date
    @classes = classes
    @category = category
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
      pages.append(Page.new(config['title'], file, nil, config['description'], date, config['classes'], nil))
      max = max - 1
      if (max == 0)
        break
      end
    end
  }

  return pages
end

if(!File.exist?(options[:fileName] + '.config') && !options[:fileName].end_with?("tmpl"))
  puts 'Cannot find: ' + options[:fileName] + '.config'
  exit -1
end

if(File.exist?(options[:fileName] + '.config'))
  config = YAML.load_file(options[:fileName] + '.config')

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



