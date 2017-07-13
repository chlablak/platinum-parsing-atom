{CompositeDisposable, Directory} = require 'atom'
Dialog = require './dialog'
PP = require './pp'
AstViewer = require './ast-viewer'

module.exports = PlatinumParsingAtom =
  dialog: null
  pp: null
  subscriptions: null
  config:
    ppPath:
      type: 'string'
      default: ''
      order: 10
      title: 'Path to executable: pp'
      description: 'By default executables are expected to be accessing directly from the *PATH*.<br/>
                    You can override this behaviour by giving the full path by yourself.'
    useWork:
      type: 'boolean'
      default: true
      order: 20
      title: 'Reuse previous computation'
      description: 'Allow **pp** to reuse previous computation to save time.'

  activate: (state) ->
    @dialog = new Dialog(state.dialogState)
    @pp = new PP(state.ppState)
    @astViewer = new AstViewer(state.astViewerState)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:new-project': => @newProject()
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:build-project': => @buildProject()
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:parse-file': => @parseFile()
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:toggle-ast-viewer': => @toggleAstViewer()

    console.log 'platinum-parsing-atom activated.'

  deactivate: ->
    @subscriptions.dispose()
    @dialog.destroy()
    @pp.destroy()
    @astViewer.destroy()

  serialize: ->
    dialogState: @dialog.serialize()
    ppState: @pp.serialize()
    astViewerState: @astViewer.serialize()

  newProject: ->
    @dialog.ask 'Enter the name of the new project, you will choose folder afterwards:', (name) =>
      atom.pickFolder((folders) =>
        if folders?
          path = (new Directory(folders[0])).getRealPathSync() + '/'
          @pp.path path
          @pp.execOP ['new', '-n', name]
          atom.open
            pathsToOpen: [path + name + '/']
            newWindow: true
      )

  findProject: (callback) ->
    path = atom.project.getPaths().filter(@pp.isProjectPath)
    if path.length == 0
      atom.confirm
        message: 'Build error'
        detailedMessage: 'No PP project opened'
        buttons: ['Ok']
    else if path.length > 1
      atom.confirm
        message: 'Build error'
        detailedMessage: 'More than 1 PP project are opened'
        buttons: ['Ok']
    else
      callback path

  buildProject: ->
    @findProject (path) =>
      @pp.path path
      @pp.execOP ['build']

  parseFile: ->
    @findProject (path) =>
      @dialog.ask 'Enter the file to parse (relatively to project path):', (file) =>
        @pp.path path
        @pp.execOP ['build', '--no-template', '--no-test', '-t', file, '--ast-to-html', "#{file}.ast.html"]
        @astViewer.setAst "#{path}/#{file}.ast.html"
        @astViewer.show()

  toggleAstViewer: ->
    @astViewer.toggle()
