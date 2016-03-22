{$, View} = require 'space-pen'
{CompositeDisposable, Emitter} = require 'atom'
{BlockDetails}  = require './block-details'
{FileEdit}  = require './file-edit'
{BlockFacade}  = require '../block-facade'
{Package} = require '../package'

class BlockList extends View

  instance: null
  pkg: null


  @content: (state, pkg) ->
    @div class: 'select-block-list width-200', =>
      @ol class: 'list-group', =>
        for origin,blocks of state.originalBlocks
          @h2 origin, class: 'origin', id: origin, click: 'viewFileContent'
          for block in blocks
            @li =>
              @div click: 'viewBlock', id: block.name, class: 'icon icon-file-text', =>
              @text block.name

  initialize: (@state, @pkg) ->
    @pkg = pkg
    @subs = new CompositeDisposable

  viewBlock: (event, element) ->
    BlockDetails.detect(@pkg,{name:element.attr('id')})
    console.log 'BlockList: viewBlock '+element.attr('id')

  viewFileContent: (event,element) ->
    self = this
    selectedOrigin = element.attr('id')
    listOfBlocks = @state.originalBlocks[selectedOrigin]
    console.log 'BlockList: view file content '+selectedOrigin+' '+listOfBlocks
    Package.model.pkg.editFile(selectedOrigin,listOfBlocks)
    console.log 'FileEdit: viewBlock '+selectedOrigin


  @detect: (pkg) ->
    return if @instance?
    console.log 'BlockList: detect'

    BlockFacade.getAllOriginal(
      (blockSortByOrigin) ->
        console.log 'BlockList: original loaded'
        state = {}
        state.originalBlocks = blockSortByOrigin
        @instance = new BlockList(state, pkg)
        atom.workspace.addLeftPanel item: @instance
    ,null)

module.exports =
  BlockList: BlockList
