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
    console.log exec, value
    eval("this.tree#{exec} = '#{value}'")

  @parse = =>
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

  @parse()
  return
