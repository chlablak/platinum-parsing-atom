PlatinumParsingAtomView = require './platinum-parsing-atom-view'
{CompositeDisposable} = require 'atom'

module.exports = PlatinumParsingAtom =
  platinumParsingAtomView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @platinumParsingAtomView = new PlatinumParsingAtomView(state.platinumParsingAtomViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @platinumParsingAtomView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'platinum-parsing-atom:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @platinumParsingAtomView.destroy()

  serialize: ->
    platinumParsingAtomViewState: @platinumParsingAtomView.serialize()

  toggle: ->
    console.log 'PlatinumParsingAtom was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
