{CompositeDisposable} = require 'atom'
AddBlockView = require './add-block-view'

module.exports = T4htmlEditor =
  addBlockView: null
  verbsList: null
  resumeView: null
#  modalPanel: null
  subscriptions: null
  content: null

  activate: (state) ->
    self = this
    console.log ('main: activate')
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    self.subscriptions = new CompositeDisposable

    # Register command that toggles this view
    self.subscriptions.add atom.commands.add 'atom-workspace', 't4html-editor:toggle': => self.toggle()

  deactivate: ->
    @addBlockView.destroy()

  serialize: ->

  toggle: ->
    self.addBlockView = new AddBlockView()
    self.content = document.createElement('div')
    self.content.className = "createBlocks"
    console.log ('main: content:'+self.content)
    console.log ('main: appendChild:'+self.addBlockView.getContent())
    self.content.appendChild(self.addBlockView.getContent())
    atom.workspace.addModalPanel({
      item:  self.content
      })
    self.addBlockView.toggle()
