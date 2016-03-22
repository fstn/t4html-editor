{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../../config'
{BlockFacade} = require '../../block-facade'
{Block} = require '../../model/block'

class BlockLine extends View

  instance: null
  editor: null
  disable: false

  @content: (state, pkg) ->
      @div class: 'readOnly-block', =>
        @div class: 'inside-block-tags', outlet: 'blockDetails', =>
          @span click: 'delete', outlet: 'deleteButton', class:"icon icon-x float-right padding-lt-5" if !state.readOnly
          @span click: 'save', outlet: 'saveButton', class:"icon icon-file-zip float-right padding-lt-5" if !state.readOnly
          @span click: 'toggle', outlet: 'toggleButton', class:"icon icon-circle-slash float-right padding-lt-5" if state.readOnly
          @span state.block.name, class:"float-right padding-lt-5" if state.readOnly

  #Call when view is displayed, we can use outlet variable here
  initialize: (@state, @pkg) ->
    self = this
    @subs = new CompositeDisposable
    atom.tooltips.add(@deleteButton, {title: 'Remove block'})  if !state.readOnly
    atom.tooltips.add(@saveButton, {title: 'Save block'}) if !state.readOnly
    atom.tooltips.add(@toggleButton, {title: 'Toggle block'}) if state.readOnly

    @editor = atom.workspace.buildTextEditor()
    @editor.setGrammar(atom.grammars.grammarForScopeName('text.html.basic'))
    @editor.setText(@state.block.content)
    lineModel = atom.views.getView(@editor)
    self.blockDetails.append(lineModel)

  delete: (event,element)->
    BlockFacade.delete(@state.block,null,null)
    @state.block.content = ''
    this.hide()


  save: (event,element) ->
    if @editor.getText() != ""
      newBlockName = "PS_"+@state.block.verb+"_"+@state.block.name
      #Adding block describe subtags
      blockContentWithTags =  Config.START_FLAG+":"+Config.DESCRIBE_VERB+":"+newBlockName+"-->\n"+
                              @editor.getText()+"\n"+Config.END_FLAG+":"+
                              Config.DESCRIBE_VERB+":"+newBlockName+"-->"

      blockContentWithTags= BlockFacade.cleanContent(blockContentWithTags)
      blockContentWithTags= BlockFacade.removeDescribeTag(blockContentWithTags)
      block = new Block(@state.block.name,@state.block.verb,blockContentWithTags)
      BlockFacade.save(block,null,null)

  toggle: () ->
    replaceBlock={'name':@state.block.name,'content':'','verb':Config.REPLACE_VERB}
    if @disable
      BlockFacade.save(replaceBlock,null,null)
      @blockDetails.removeClass('blockDisabled')
      @blockDetails.addClass('blockEnabled')
      @disable = false
    else
      BlockFacade.delete(replaceBlock,null,null)
      @blockDetails.removeClass('blockEnabled')
      @blockDetails.addClass('blockDisabled')
      @disable = true

  openFile: (event,element) ->
    atom.workspace.open editBlockUrl

  package:(event,element) ->



  getUri: -> "atom://t4html"

  getTitle: -> "test"

  getModel: ->

  deactivate: ->
    console.log 'BlockLine: destroy '+event
    @instance = null;
    @state = null;

  @detect: (pkg,origin,block,readOnly) ->
    console.log 'BlockLine: detect '+pkg+' '+block
    # return if @instance?
    @state = {}
    @state.origin = origin
    @state.block = block
    @state.readOnly = readOnly
    @instance = new BlockLine(@state, pkg)
    @instance



module.exports =
  BlockLine: BlockLine
