{CompositeDisposable, Emitter} = require 'atom'
{BlockList} = require './view/block-list'
{BlockEdit}  = require './view/block-edit'
t4htmlUrl = 'atom://t4html'
path = require 'path'

module.exports = T4htmlEditor =
  BlockEditView: null
  verbsList: null
  resumeView: null
#  modalPanel: null
  subscriptions: null
  content: null
  selectedBlock: null

  activate: (state) ->

    self = this
    atom.workspace.addOpener (uri) ->
      block = {content:"content",name:"titi"}
      console.log 'BlockList: add opener block '+self.selectedBlock+" "+uri
      BlockEdit.detect(self.pkgEmitter,self.selectedBlock) if uri is t4htmlUrl;

    atom.workspace.observeTextEditors (editor) ->
      if path.extname(editor.getPath()) == ".blocks"
          editor.setGrammar(atom.grammars.grammarForScopeName('text.html.basic'))

    #Close tree view
    if atom.workspace.getLeftPanels().length > 0
      workspaceView = atom.views.getView(atom.workspace)
      atom.commands.dispatch(workspaceView, 'tree-view:toggle')

    @subs = new CompositeDisposable
    @emitter = new Emitter

    pkgEmitter =
      onBlockEdit: (callback) => @onBlockEdits(callback)
      onOpenBlock: (callback) => @onOpenBlock(callback)
      onBlockEdit: (callback) -> self.emitter.on 'edit-block', callback
      editBlock: (block) ->
        self.selectedBlock = block
        console.log 'main: edit block '+block
        atom.workspace.getActivePane().close()
        atom.workspace.open t4htmlUrl

    self = this
    console.log ('main: activate')
    # Register command that toggles this view
    @subs.add atom.commands.add 'atom-workspace', 't4html-editor:toggle': ->
      BlockList.detect(pkgEmitter)


  onBlockEdit: (callback) ->
    @emitter.on 'add-block', callback

  onOpenBlock: (callback) ->
    @emitter.on 'open-block', callback

  deactivate: ->
    @subs.dispose()
    @emitter.dispose()
