{$, View} = require 'space-pen'
{CompositeDisposable} = require 'atom'

class BlockList extends View

  instance: null

  @content: (state, pkg) ->
    @div class: 'select-list width-200', =>
      @ol class: 'list-group', =>
        for {path: name, name} in state.originalBlocks
          @li =>
            @div click: 'addBlock', class: 'icon icon-diff-added ', =>
            @div click: 'viewBlock', class: 'icon icon-file-text', =>
            @text name

  initialize: (@state, @pkg) ->
    @subs = new CompositeDisposable

  viewBlock: (event, element) ->
    console.log 'BlockList: viewBlock'+event

  addBlock: (event, element) ->
    console.log 'BlockList: addBlock'+event

  @detect: (pkg) ->
    return if @instance?
    console.log 'BlockList: detect'
    $.ajax 'http://localhost:8080/rest/blocks/original',
        success  : (data, status, xhr) ->
            state = {}
            state.originalBlocks = data
            @instance = new BlockList(state, pkg)
            atom.workspace.addRightPanel item: @instance
            console.log 'BlockList: fullLoaded'
        error    : (xhr, status, err) ->
            console.log("nah "+err)
        complete : (xhr, status) ->
            console.log("comp")


module.exports =
  BlockList: BlockList
