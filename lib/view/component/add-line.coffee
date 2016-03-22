{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../../config'
{Package} = require '../../config'
{BlockLine} = require './block-line'

class AddLine extends View
    instance: null
    editor: null
    block: null
    blockLine: null


    @content: (state, pkg) ->
      @div =>
        @div click: 'addBlock', class:"icon icon-gist-new add-line"
        @div class: 'new-block-content', outlet: 'content'

    #Call when view is displayed, we can use outlet variable here
    initialize: (@state, @pkg, originalBlock, customBlock)->
      self = this
      @subs = new CompositeDisposable
      @block  = customBlock
      console.log 'AddLine: initialize originalBlock '+JSON.stringify(originalBlock)+' customBlock '+JSON.stringify(customBlock)
      if @block.content == ""
        @block.content = 'add content here ...'
        @block.new = true

      @blockLine = BlockLine.detect(@pkg,originalBlock.origin,@block,false)
      @content.append(@blockLine)
      if @block.new
        @blockLine.hide();

    deactivate: ->
      console.log 'AddLine: destroy '+event
      @instance = null;
      @state = null;

    addBlock: (event, element) ->
      @blockLine.show();

    @detect: (pkg, origin,  originalBlock, customBlock) ->
      @state = {}
      @state.origin = origin
      console.log 'AddLine: detect pkg '+pkg+' origin '+origin+' originalBlock '+JSON.stringify(originalBlock)+' customBlock '+JSON.stringify(customBlock)
      @instance = new AddLine(@state, pkg, originalBlock, customBlock)
      @instance

  module.exports =
    AddLine: AddLine
