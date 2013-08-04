exports.process = (data) ->
  @tree =
    'root': {}
  @stack = ['root']

  @config = require '../../config.json'
  @columns = @config.columns

  for media, query of @columns
    @["#{media}Query"] = "@#{media}-query: ~\"#{query}\";"
    @["#{media}String"] = ''
    @["#{media}Tree"] = {}

  @indent = (level) ->
    Array(level + 1).join '  '

  @toJsonString = =>
    jsonString = ""
    for line in data.split "\n"
      line = line.trim()
      jsonLine = ""

      if line.slice(-1) == '{'
        jsonLine = "\"#{line.slice(0, -1).trim()}\": {"
      else if line.slice(-1) == '}'
        jsonLine = "},"
        if prevJsonLine && prevJsonLine.slice(-1) == ','
          prevJsonLine = prevJsonLine.slice(0, -1)
      else if line.length > 0
        split = line.split ':'
        key   = split[0].trim()
        value = (split[1] || '').trim()
        jsonLine = "\"#{key}\": \"#{value}\","

      jsonString += (prevJsonLine + "\n") if prevJsonLine
      prevJsonLine = jsonLine

    jsonString += (prevJsonLine + "\n") if prevJsonLine
    jsonString

  @compose = =>
    output = ""
    node = @json
    print = (value) ->
      output += (value + "\n")

    @processNode node, print

    for media, query of @columns
      print "@media @#{media}-query {"
      @composeNode @["#{media}Tree"], print, 1
      print '}'

    output

  @composeNode = (node, print, level=0) =>
    indent = @indent(level)
    for key, value of node
      if typeof value == 'string'
        print (indent + key + ": " + value)
      else
        print "#{indent + key} {"
        @composeNode(value, print, level + 1)
        print (indent + '}')

  @processNode = (node, print, stack=[], level=0) =>
    indent = @indent(level)
    for key, value of node
      stack.push key

      if typeof value == 'string'
        if value.indexOf('|') > -1
          @saveColumns(node, print, stack, level + 1, key, value)
        else
          print (indent + key + ": " + value)
      else
        print "#{indent + key} {"
        @processNode(value, print, stack, level + 1)
        print (indent + '}')
      stack.pop()

  @printNode = (stack, key, value, print) =>
    level = 0
    for line in stack
      print "#{line} {"
      level++

    until level == 0
      print "}"

  @setNode = (treeName, stack, value) =>
    exec = ''
    for key in stack
      exec += "['#{key}']"
    eval("#{treeName}#{exec} = '#{value}'")

  @saveColumns = (node, print, stack, level, key, value) =>
    indent  = @indent(level)
    split   = value.split('|')
   
    i = 0
    values = {}
    valuesArray = []
    for media, query of @columns
      fallback = if i > 0 then valuesArray[i - 1] else ''
      values[media] = split[i + 1].trim() || fallback
      valuesArray.push values[media]
      i++

    for media, query of @columns
      @setNode @["#{media}Tree"], stack, values[media] + ';'

  @setNode = (tree, stack, value) =>
    node = tree
    for nodeName in stack
      node[nodeName] ||= {}
      if nodeName == stack[stack.length - 1]
        node[nodeName] = value
      else
        node = node[nodeName]

  @jsonString = @toJsonString()
  @json       = JSON.parse("{" + @jsonString.slice(0, -2) + "}")

  output = @compose()

  queries = ""
  for media, query of @columns
    queries += @["#{media}Query"] + "\n"

  output = queries + "\n" + output
  output

