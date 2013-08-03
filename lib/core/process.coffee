exports.process = (data) ->
  @tree =
    'root': {}
  @stack = ['root']

  @createNode = =>
    exec = ''
    for key in @stack
      exec += "['#{key}']"
    eval("this.tree#{exec} = {}")

  @setNode = (value) =>
    exec = ''
    for key in @stack
      exec += "['#{key}']"
    eval("this.tree#{exec} = '#{value}'")

  @parse2 = =>
    for line in data.split "\n"
      line = line.trim()
      if line.slice(-1) == '{'
        line       = line.slice(0, -1).trim()
        @stack.push line
        @createNode()
      else if line.slice(-1) == '}'
        @stack.pop()
      else if line.length > 0
        split     = line.split ':'
        key       = split[0].trim()
        value     = (split[1] || '').trim()

        @stack.push key
        @setNode(value)
        @stack.pop()

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
    @printNode node, (value) ->
      output += (value + "\n")
    output

  @printNode = (node, print, indent='') =>
    for key, value of node
      if typeof value == 'string'
        print (indent + key + ": " + value)
      else
        print "#{indent + key} {"
        @printNode(value, print, indent + '  ')
        print (indent + '}')


  @jsonString = @toJsonString()
  @json       = JSON.parse("{" + @jsonString.slice(0, -2) + "}")
  @compose()
