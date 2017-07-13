fs = require 'fs'

module.exports = class AstViewer
  constructor: (serializedState) ->
    @element = document.createElement 'div'
    @element.classList.add 'platinum-parsing-atom'
    title = document.createElement 'h1'
    title.textContent = 'AST Viewer'
    @element.appendChild title
    @list = document.createElement 'div'
    @element.appendChild @list

    @panel = atom.workspace.addRightPanel(item: @element, visible: false)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->

  # Toggle viewer
  toggle: ->
    if @panel.isVisible()
      @panel.hide()
    else
      @panel.show()

  show: ->
    @panel.show()

  # Set AST data
  setAst: (file) ->
    @list.innerHTML = fs.readFileSync file
