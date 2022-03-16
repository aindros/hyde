hyde - Static website generator
===============================

Introduction
------------

Hyde is a simple tool to generate static websites. Its strength lies in its ease of use. The wheel is not invented
again; hyde is written in Ruby and uses ERB templates.
Hyde works with a master page that defines a layout and multiple files are used as content. In this way is possible
to split down UI and content.

Guide
-----

Let's create a website with only two pages. First, let's create a `master.rhtml` file used as template.
```
<html>
  <head>
    <title><%= @title %></title>
  </head>
  <body>
    <div style="border: 1px solid orange">
      <%= render @pageFileName %>
    </div>
  </body>
</html>
```
There are two variables:

- `@title` is the page's title, it's defined inside config file;
- `@pageFileName` is the file name to render, in this example will be rendered `page1.rhtml` and `page2.rhtml`.

`page1.rhtml`:
```
<h1>Page one</h1>
<p>Content of page one.</p>
<a href="page2.html">Page 2 &‍gt;</a>
```
`page2.rhtml`
```
<h1>Page two</h1>
<p>Content of page 2.</p>
<a href="page1.html">&‍lt; Page 1</a>
```

`page1.rhtml.config`:
```
title: Page 1
```

`page2.rhtml.config`:
```
title: Page 2
```

After creating the files, you'll see this:
```
$ ls -1
master.rhtml
page1.rhtml
page1.rhtml.config
page2.rhtml
page2.rhtml.config
```
At this point, let's execute the following commands:
```
hyde -f page1.rhtml > page1.html
hyde -f page2.rhtml > page2.html
```
Open the two HTML files (page1.html and page2.html) on your browser.
