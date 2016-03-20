{$, ScrollView} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../config.coffee'

class BlockEdit extends ScrollView

  instance: null
  modalPanel: null
  beforeModel: null
  prependModel: null
  appendModel: null
  afterModel: null
  viewElements: []
  customBlocks: null

  @content: (state, pkg) ->
    @div class: 'edit-panel pane-item', tabindex: -1, =>
      @div class: 'block-details container-fluid', outlet: 'blockDetails', =>
        @div class:'row', =>
          @div class: 'col-xs-12 ', =>
            @span click: 'save', class:"icon icon-mirror float-right padding-lt-5"
            @h2 'Before Content'
            @span click: 'close', class:"icon icon-eye-unwatch float-right padding-lt-5"
            @div class: 'field block-before', outlet: 'blockBefore'
            @div class: 'inside-block-tags', =>
              @h2 'Prepend Content'
              @span click: 'close', class:"icon icon-eye-unwatch float-right padding-lt-5"
              @div class: 'field block-prepend', outlet: 'blockPrepend'
              @h2 'Content'
              @pre class:"row", =>
                @code js_beautify(state.block.content)
              @h2 'Append Content'
              @span click: 'close', class:"icon icon-eye-unwatch float-right padding-lt-5"
              @div class: 'field block-append', outlet: 'blockAppend'
            @h2 'After Content'
            @span click: 'close', class:"icon icon-eye-unwatch float-right padding-lt-5"
            @div class: 'field block-after', outlet: 'blockAfter'

  #Call when view is displayed, we can use outlet variable here
  initialize: (@state, @pkg) ->
    self = this
    @subs = new CompositeDisposable

    @viewElements = [
      {verb:Config.BEFORE_VERB,model: @beforeModel,parent: @blockBefore }
      {verb:Config.PREPEND_VERB,model: @prependModel,parent: @blockPrepend }
      {verb:Config.APPEND_VERB,model: @appendModel,parent: @blockAppend }
      {verb:Config.AFTER_VERB,model: @afterModel,parent: @blockAfter }
    ]

    $.ajax Config.WS_URL+'available/'+@state.block.name,
      type: 'GET',
      success  : (customBlocks, status, xhr) ->
        self.customBlocks = customBlocks
        self.createViewElements(viewElement) for viewElement in  self.viewElements
        console.log('Custom blocks load completed '+customBlocks)
      error    : (xhr, status, err) ->
        console.log('Unable to load custom blocks')
      complete : (xhr, status) ->
        console.log("comp")

  close: (event,element)->
    if element.hasClass("icon-eye-unwatch")
      element.removeClass("icon-eye-unwatch")
      element.addClass("icon-eye")
      element.next().css("max-height","20px")
      element.next().css("overflow","hidden")
    else
      element.removeClass("icon-eye")
      element.addClass("icon-eye-unwatch")
      element.next().css("max-height","1000px")
      element.next().css("overflow","visible")

  save: (event,element)->
    @saveViewElements(viewElement) for viewElement in  @viewElements

  createViewElements: (viewElement) ->
    self = this
    viewElement.model = atom.workspace.buildTextEditor()
    for customBlock in self.customBlocks
      if viewElement.verb  == customBlock.verb
        customBlock.content= @cleanContent(customBlock.content)
        customBlockWithoutTag = customBlock.content.replace(/<!--start-block:describe:.*-->([\s\S]*?)<!--end-block:describe:.*-->/, "$1");
        viewElement.model.setText(customBlockWithoutTag)
    line_edit = atom.views.getView(viewElement.model)
    line_edit.className = 'block-content'
    viewElement.parent.append(line_edit)

  cleanContent: (blockConent) ->
    blockConent = blockConent.replace(/^\s*$[\n\r]{1,}/gm,'')
    blockConent

  saveViewElements: (viewElement) ->
    if viewElement.model.getText() != ""
      newBlockName = "PS_"+viewElement.verb+"_"+@state.block.name
      #Adding block describe subtags
      blockContentWithTags =  Config.START_FLAG+":"+Config.DESCRIBE_VERB+":"+newBlockName+"-->\n"+
                              viewElement.model.getText()+"\n"+Config.END_FLAG+":"+
                              Config.DESCRIBE_VERB+":"+newBlockName+"-->"

      blockContentWithTags= @cleanContent(blockContentWithTags)
      block = {name:@state.block.name,content:blockContentWithTags,verb:viewElement.verb}
      #Saving blocks
      $.ajax Config.WS_URL+'available/',
        type: 'POST',
        data: JSON.stringify(block),
        contentType: 'application/json; charset=utf-8',
        dataType: 'json',
        success  : (block, status, xhr) ->
          console.log('Save completed')
        error    : (xhr, status, err) ->
          console.log('Unable to save')
        complete : (xhr, status) ->
          console.log("comp")

  getUri: -> "atom://t4html"

  getTitle: -> @state.block.name

  getModel: ->

  deactivate: ->
    console.log 'BlockEdit: destroy '+event
    @instance = null;
    @state = null;

  @detect: (pkg,block) ->
    console.log 'BlockEdit: detect '+pkg+' '+block
    # return if @instance?
    @state = {}
    @state.block = block
    @instance = new BlockEdit(@state, pkg)
    @instance



module.exports =
  BlockEdit: BlockEdit
