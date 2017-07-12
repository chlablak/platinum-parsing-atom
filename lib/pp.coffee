{BufferedProcess} = require('atom')

module.exports = class PP
  constructor: (serializedState) ->
    @proc = null
    @command = atom.config.get 'platinum-parsing-atom.ppPath'
    @command = 'pp' if @command is ''
    @cargs = ['-v', '0']
    if atom.config.get 'platinum-parsing-atom.useWork'
      @cargs.push '-w'
    @cargs.push '--path'
    @cargs.push '.'

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->

  # Change folder
  path: (path) ->
    @cargs.pop()
    @cargs.push path

  # Execute pp
  exec: (args) ->
    options =
      command: @command
      args: @cargs.concat args
      stdout: @stdout
      stderr: @stderr
      exit: @exit
    console.log "exec: #{options.command} #{options.args}"
    @proc = new BufferedProcess(options)

  # stdout callback
  stdout: (output) ->
    console.log "stdout: #{output}"

  # stderr callback
  stderr: (output) ->
    console.log "stderr: #{output}"

  # exit callback
  exit: (code) ->
    console.log "exit: #{code}"
    @proc = null
