{BufferedProcess, File} = require 'atom'
OP = require(atom.packages.resolvePackagePath 'output-panel')

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

  # Execute with output-panel
  execOP: (args) ->
    OP.run('auto', @command, @cargs.concat args)

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

  # check if a path is a PP project
  isProjectPath: (path) ->
    (new File(path + '/pp.yaml')).existsSync()
