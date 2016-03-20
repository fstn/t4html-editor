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

  @content: (state, pkg) ->
    @div class: 'edit-panel pane-item', tabindex: -1, =>
      @div class: 'block-details container-fluid', outlet: 'blockDetails', =>
        @div class:'row', =>
          @div class: 'col-xs-12 ', =>
            @span click: 'save', class:"icon icon-mirror float-right"
            @h2 'Before Content'
            @div class: 'field block-before', outlet: 'blockBefore'
            @div class: 'inside-block-tags', =>
              @h2 'Prepend Content'
              @div class: 'field block-prepend', outlet: 'blockPrepend'
              @h2 'Content'
              @pre class:"row", =>
                @code js_beautify(state.block.content)
              @h2 'Append Content'
              @div class: 'field block-append', outlet: 'blockAppend'
            @h2 'After Content'
            @div class: 'field block-after', outlet: 'blockAfter'

  #Call when view is displayed, we can use outlet variable here
  initialize: (@state, @pkg) ->
    @subs = new CompositeDisposable

    @viewElements = [
      {verb:Config.BEFORE_VERB,model: @beforeModel,parent: @blockBefore }
      {verb:Config.PREPEND_VERB,model: @prependModel,parent: @blockPrepend }
      {verb:Config.APPEND_VERB,model: @appendModel,parent: @blockAppend }
      {verb:Config.AFTER_VERB,model: @afterModel,parent: @blockAfter }
    ]
    @createViewElements(viewElement) for viewElement in  @viewElements

  save: (event,element)->
    @saveViewElements(viewElement) for viewElement in  @viewElements

  createViewElements: (viewElement) ->
    viewElement.model = atom.workspace.buildTextEditor()
    line_edit = atom.views.getView(viewElement.model)
    line_edit.className = 'block-content'
    viewElement.parent.append(line_edit)

  saveViewElements: (viewElement) ->
    if viewElement.model.getText() != ""
      newBlockName = "PS_"+viewElement.verb+"_"+@state.block.name
      #Adding block describe subtags
      blockContentWithTags =  Config.START_FLAG+":"+Config.DESCRIBE_VERB+":"+newBlockName+"-->"+
                              viewElement.model.getText()+Config.END_FLAG+":"+
                              Config.DESCRIBE_VERB+":"+newBlockName+"-->"
      block = {name:@state.block.name,content:blockContentWithTags,verb:viewElement.verb}
      #Saving blocks
      $.ajax 'http://localhost:8080/rest/blocks/available/',
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
