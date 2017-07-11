{CompositeDisposable} = require 'atom'

module.exports = PlatinumParsingAtom =
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
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register commands
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:new-project': => @newProject()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->

  newProject: ->
    console.log 'newProject fired !'
