{$, ScrollView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../config.coffee'
{BlockLine} = require './component/block-line.coffee'
{AddLine} = require './component/add-line.coffee'

class FileEdit extends ScrollView

  instance: null
  blocks: null

  @content: (state, pkg) ->
    @div class: 'edit-panel pane-item', tabindex: -1, =>
      @div class: 'block-details container-fluid', outlet: 'blockDetails', =>
        @div class:'row', =>
          @div class: 'col-xs-12 ', outlet: 'blocksList'

  #Call when view is displayed, we can use outlet variable here
  initialize: (@state, @pkg) ->
    self = this
    @subs = new CompositeDisposable
    for block in @state.listOfBlocks
      addBlock = AddLine.detect(@pkg,@state.origin,Config.BEFORE_VERB,block)
      @blockDetails.append(addBlock)
      blockLine = BlockLine.detect(@pkg,@state.origin,block,true)
      @blockDetails.append(blockLine)
      addBlock = AddLine.detect(@pkg,@state.origin,Config.AFTER_VERB,block)
      @blockDetails.append(addBlock)

  close: (event,element)->

  save: (event,element) ->

  openFile: (event,element) ->

  package:(event,element) ->

  createViewElements: (viewElement) ->

  saveViewElements: (viewElement) ->

  getUri: -> Config.FILE_EDIT_URL

  getTitle: -> @state.origin

  deactivate: ->
    console.log 'FileEdit: destroy '+event
    @instance = null;
    @state = null;

  @detect: (pkg, origin, listOfBlocks ) ->
    console.log 'FileEdit: detect '+pkg+' '+origin+' '+listOfBlocks
    # return if @instance?
    @state = {}
    @state.origin = origin
    @state.listOfBlocks = listOfBlocks
    @instance = new FileEdit(@state, pkg)
    @instance



module.exports =
  FileEdit: FileEdit
