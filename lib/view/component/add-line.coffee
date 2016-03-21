{$, View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'atom'
{js_beautify} = require 'js-beautify'
{Config} = require '../../config'
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
    initialize: (@state, @pkg) ->
      self = this
      @subs = new CompositeDisposable
      @block = {'name':'PS_'+@state.verb+'_'+@state.block.name,'verb':@state.verb,'content':'add content here ...'}
      @blockLine = BlockLine.detect(@pkg,@state.origin,@block,false)
      @blockLine.hide();
      @content.append(@blockLine)

    deactivate: ->
      console.log 'AddLine: destroy '+event
      @instance = null;
      @state = null;

    addBlock: (event, element) ->
      @blockLine.show();

    @detect: (pkg, origin, verb, block) ->
      @state = {}
      @state.origin = origin
      @state.verb = verb
      @state.block = block
      console.log 'AddLine: detect '+pkg+' '+block
      @instance = new AddLine(@state, pkg, origin, verb, block)
      @instance

  module.exports =
    AddLine: AddLine
