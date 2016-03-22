{$, ScrollView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../config.coffee'
{BlockLine} = require './component/block-line.coffee'
{AddLine} = require './component/add-line.coffee'
{Package} = require '../package'
{Block} = require '../model/block'
{BlockFacade} = require '../block-facade'
{PackageFacade} = require '../package-facade'


class FileEdit extends ScrollView

  instance: null
  blocks: null

  @content: (state, pkg) ->
    @div class: 'edit-panel pane-item', tabindex: -1, =>
      @span click: 'package', class:"icon icon-package float-right padding-lt-5"
      @div class: 'block-details container-fluid', outlet: 'blockDetails', =>
        @div class:'row', =>
          @div class: 'col-xs-12 ', outlet: 'blocksList'

  #Call when view is displayed, we can use outlet variable here
  initialize: (@state, @pkg) ->
    @subs = new CompositeDisposable
    self = this
    for block in Package.model.listOfSelectedBlocks
      BlockFacade.getCustomyOriginalAndVerb(block,Config.BEFORE_VERB,(customBlock) ->
          console.log("FileEdit custom block "+JSON.stringify(customBlock))
          addBlock = AddLine.detect(Package.model.pkg,Package.model.selectedOrigin,block,customBlock)
          self.blockDetails.append(addBlock)
          blockLine = BlockLine.detect(Package.model.pkg,self.state.origin,block,true)
          self.blockDetails.append(blockLine)
          BlockFacade.getCustomyOriginalAndVerb(block,Config.AFTER_VERB,(customBlock) ->
            addBlock = AddLine.detect(Package.model.pkg,Package.model.selectedOrigin,block,customBlock)
            self.blockDetails.append(addBlock)
            )
        )



  close: (event,element)->

  save: (event,element) ->

  openFile: (event,element) ->

  package:(event,element) -> PackageFacade.build(null,null)

  createViewElements: (viewElement) ->

  saveViewElements: (viewElement) ->

  getUri: -> Config.FILE_EDIT_URL

  getTitle: -> Package.model.selectedOrigin

  deactivate: ->
    console.log 'FileEdit: destroy '+event
    @instance = null;
    @state = null;

  @detect: () ->
    @state = {}
    @state.origin = Package.model.selectedOrigin
    @state.listOfBlocks = Package.model.listOfSelectedBlocks
    @state.customBlocksSortByName = Package.model.customBlocksSortByName
    console.log 'FileEdit: detect '+@state.origin+' '+@state.listOfBlocks+' '+@state.customBlocksSortByName
    @instance = new FileEdit(@state)
    @instance



module.exports =
  FileEdit: FileEdit
