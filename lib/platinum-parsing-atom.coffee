{CompositeDisposable, Directory} = require 'atom'
Dialog = require './dialog'
PP = require './pp'

module.exports = PlatinumParsingAtom =
  dialog: null
  pp: null
  subscriptions: null
  config:
    ppPath:
      type: 'string'
      default: ''
      order: 10
      title: 'Path to **pp** executable'
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

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:new-project': => @newProject()
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:build-project': => @buildProject()

  deactivate: ->
    @subscriptions.dispose()
    @dialog.destroy()
    @pp.destroy()

  serialize: ->
    dialogState: @dialog.serialize()
    ppState: @pp.serialize()

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

  buildProject: ->
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
      @pp.path path
      @pp.execOP ['build']
