{$, View} = require 'space-pen'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'

class BlockDetails extends View

  instance: null
  modalPanel: null
  self: this

  @content: (state, pkg) ->
    @div class: 'block-details', =>
      @span click: 'close', class:"icon icon-remove-close float-right"
      @h1 state.block.name, =>
      @div class: 'block-details-content', =>
        @pre =>
          @code js_beautify(state.block.content)

  initialize: (@state, @pkg) ->
    @subs = new CompositeDisposable

  close: (event, element) ->
    self.modalPanel.hide()
    console.log 'BlockDetails: close '+event


  @detect: (pkg,block) ->
    return if @instance?
    console.log 'BlockDetails: detect '+block
    $.ajax 'http://localhost:8080/rest/blocks/original/'+block.name,
        success  : (block, status, xhr) ->
          state = {}
          state.block = block
          @instance = new BlockDetails(state, pkg)
          self.modalPanel = atom.workspace.addModalPanel(item: @instance, visible: true)
          console.log 'BlockDetails: fullLoaded'
        error    : (xhr, status, err) ->
            console.log("nah "+err)
        complete : (xhr, status) ->
            console.log("comp")





module.exports =
  BlockDetails: BlockDetails
