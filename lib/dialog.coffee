module.exports = class Dialog
  constructor: (serializedState) ->
    @callback = null

    # Create root element
    @element = document.createElement('div')
    @element.classList.add('platinum-parsing-atom')

    # Create message element
    @message = document.createElement('a')
    @element.appendChild(@message)

    # Create input
    @editor = atom.workspace.buildTextEditor(mini: true)
    @view = atom.views.getView(@editor)
    @element.appendChild(@view)

    # Modal panel
    @modal = atom.workspace.addModalPanel(item: @element, visible: false)

    # Register events
    @view.addEventListener('keydown', @handler)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()
    @modal.destroy()

  # Ask a new question
  ask: (question, callback) ->
    @callback = callback
    @message.textContent = question
    @editor.setText ''
    @modal.show()
    @view.focus()

  # Key was pressed
  handler: (e) =>
    switch e.keyCode
      when 27 # Esc
        @modal.hide()
      when 13 # Enter
        @callback @editor.getText()
        @modal.hide()
