{CompositeDisposable, Emitter} = require 'atom'
{BlockList} = require './view/block-list'
{BlockEdit}  = require './view/block-edit'
{FileEdit} = require './view/file-edit'
path = require 'path'
{Config} = require './config'
{Package} = require './package'
{BlockFacade} = require './block-facade'

module.exports = T4htmlEditor =
  BlockEditView: null
  verbsList: null
  resumeView: null
#  modalPanel: null
  subscriptions: null
  content: null

  activate: (state) ->
    self = this

    atom.workspace.observeTextEditors (editor) ->
      if path.extname(editor.getPath()) == ".blocks"
          editor.setGrammar(atom.grammars.grammarForScopeName('text.html.basic'))

    @subs = new CompositeDisposable
    @emitter = new Emitter

    Package.model.pkg =
      onBlockEdit: (callback) => @onBlockEdits(callback)
      onOpenBlock: (callback) => @onOpenBlock(callback)
      onBlockEdit: (callback) -> self.emitter.on 'edit-block', callback
      editBlock: (block) ->
        Package.model.selectedBlock = block
        console.log 'Main: edit block '+block
        atom.workspace.getActivePane().close()
        atom.workspace.open Config.BLOCK_EDIT_URL
      editFile: (origin,listOfBlocks) ->
        Package.model.listOfSelectedBlocks = listOfBlocks
        Package.model.selectedOrigin = origin
        BlockFacade.getAllCustom(
          (blockSortByOriginalName) ->
            console.log 'Main: All custom blocks loaded '
            Package.model.customBlocksSortByName = blockSortByOriginalName
            atom.workspace.getActivePane().close()
            atom.workspace.open Config.FILE_EDIT_URL
          , null)

    atom.workspace.addOpener (uri) ->
      block = {content:"content",name:"titi"}
      console.log('Main Open URL '+uri+' pkg: '+Package.model.pkg+' model: '+Package.model)
      BlockEdit.detect(Package.model.pkg,Package.model.selectedBlock) if uri is Config.BLOCK_EDIT_URL
      FileEdit.detect() if uri is Config.FILE_EDIT_URL

    #Close tree view
    if atom.workspace.getLeftPanels().length > 0
      workspaceView = atom.views.getView(atom.workspace)
      atom.commands.dispatch(workspaceView, 'tree-view:toggle')

    console.log ('Main: activate')
    # Register command that toggles this view
    @subs.add atom.commands.add 'atom-workspace', 't4html-editor:toggle': ->
      BlockList.detect(Package.model.pkg)

  onBlockEdit: (callback) ->
    @emitter.on 'add-block', callback

  onOpenBlock: (callback) ->
    @emitter.on 'open-block', callback

  deactivate: ->
    @subs.dispose()
    @emitter.dispose()
