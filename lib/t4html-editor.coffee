BlockList = require './t4html-block-list'
VerbList = require './t4html-verb-list'
ResumeView = require './t4html-resume'
{CompositeDisposable} = require 'atom'

module.exports = T4htmlEditor =
  blocksList: null
  verbsList: null
  resumeView: null
#  modalPanel: null
  subscriptions: null


  activate: (state) ->

    self = this
    console.log ('test')
    self.blocksList = new BlockList(state.blocksListViewState)
    self.verbsList = new VerbList(state.verbsListViewState)
    self.resumeView = new ResumeView()

    self.verbsList.emitter.on 'selected-verb-changed', (verb) ->
      self.resumeView.setSelectedVerb verb

    self.blocksList.emitter.on 'selected-block-changed', (block) ->
      self.resumeView.setSelectedBlock  block


  #  @modalPanel = atom.workspace.addModalPanel(item: @t4htmlEditorView.getElement(), visible: true)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    self.subscriptions = new CompositeDisposable

    # Register command that toggles this view
    self.subscriptions.add atom.commands.add 'atom-workspace', 't4html-editor:toggle': => self.toggle()

  deactivate: ->
  #  @modalPanel.destroy()
    @subscriptions.dispose()
    @blocksList.destroy()
    @verbsList.destroy()

  serialize: ->
    blocksListViewState: @blocksList.serialize()
    verbsListViewState: @verbsList.serialize()

  toggle: ->
    editor = atom.workspace.getActiveTextEditor()
    content = document.createElement('div')
    selectedValue = document.createElement('div')
    selectedValue.className = 'col-xs-2 '
    content.className = 'row'
    console.log("log"+@blocksList[0])
    content.appendChild(@blocksList[0])
    content.appendChild(@verbsList[0])
    console.log @resumeView
    content.appendChild(@resumeView[0])
    atom.workspace.addTopPanel({
      item:  content
      })
