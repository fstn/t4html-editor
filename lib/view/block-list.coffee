{$, View} = require 'space-pen'
{CompositeDisposable, Emitter} = require 'atom'
{BlockDetails}  = require './block-details'
{FileEdit}  = require './file-edit'

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

  # TODO remove this not used yet
  addBlock: (event, element) ->
    self = this
    $.ajax 'http://localhost:8080/rest/blocks/original/'+element.attr('id'),
      success  : (block, status, xhr) ->
        console.log 'BlockList: block fullLoaded '+block
        self.pkg.editBlock(block)
      error    : (xhr, status, err) ->
          console.log("nah "+err)
      complete : (xhr, status) ->
          console.log("comp")

  viewFileContent: (event,element) ->
    self = this
    selectedOrigin = element.attr('id')
    listOfBlocks = @state.originalBlocks[selectedOrigin]
    console.log 'BlockList: view file content '+selectedOrigin+' '+listOfBlocks
    self.pkg.editFile(selectedOrigin,listOfBlocks)
    console.log 'FileEdit: viewBlock '+selectedOrigin


  @detect: (pkg) ->
    return if @instance?
    console.log 'BlockList: detect'
    $.ajax 'http://localhost:8080/rest/blocks/original',
        success  : (data, status, xhr) ->
            blockSortByOrigin = data.reduce(((map, obj) ->
                if map[obj.origin] == undefined
                  map[obj.origin] = []
                map[obj.origin].push  obj
                map
            ), {})
            state = {}
            state.originalBlocks = blockSortByOrigin
            @instance = new BlockList(state, pkg)
            atom.workspace.addLeftPanel item: @instance
            console.log 'BlockList: fullLoaded'
        error    : (xhr, status, err) ->
            console.log("nah "+err)
        complete : (xhr, status) ->
            console.log("comp")


module.exports =
  BlockList: BlockList
