PlatinumParsingAtom = require '../lib/platinum-parsing-atom'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "PlatinumParsingAtom", ->
  [workspaceElement, activationPromise] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    activationPromise = atom.packages.activatePackage('platinum-parsing-atom')

  describe "when the platinum-parsing-atom:toggle event is triggered", ->
    it "hides and shows the modal panel", ->
      # Before the activation event the view is not on the DOM, and no panel
      # has been created
      expect(workspaceElement.querySelector('.platinum-parsing-atom')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'platinum-parsing-atom:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(workspaceElement.querySelector('.platinum-parsing-atom')).toExist()

        platinumParsingAtomElement = workspaceElement.querySelector('.platinum-parsing-atom')
        expect(platinumParsingAtomElement).toExist()

        platinumParsingAtomPanel = atom.workspace.panelForItem(platinumParsingAtomElement)
        expect(platinumParsingAtomPanel.isVisible()).toBe true
        atom.commands.dispatch workspaceElement, 'platinum-parsing-atom:toggle'
        expect(platinumParsingAtomPanel.isVisible()).toBe false

    it "hides and shows the view", ->
      # This test shows you an integration test testing at the view level.

      # Attaching the workspaceElement to the DOM is required to allow the
      # `toBeVisible()` matchers to work. Anything testing visibility or focus
      # requires that the workspaceElement is on the DOM. Tests that attach the
      # workspaceElement to the DOM are generally slower than those off DOM.
      jasmine.attachToDOM(workspaceElement)

      expect(workspaceElement.querySelector('.platinum-parsing-atom')).not.toExist()

      # This is an activation event, triggering it causes the package to be
      # activated.
      atom.commands.dispatch workspaceElement, 'platinum-parsing-atom:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        # Now we can test for view visibility
        platinumParsingAtomElement = workspaceElement.querySelector('.platinum-parsing-atom')
        expect(platinumParsingAtomElement).toBeVisible()
        atom.commands.dispatch workspaceElement, 'platinum-parsing-atom:toggle'
        expect(platinumParsingAtomElement).not.toBeVisible()
