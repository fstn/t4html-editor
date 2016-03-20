{CompositeDisposable, Emitter} = require 'atom'

{BlockList} = require './view/block-list'


module.exports = T4htmlEditor =
  addBlockView: null
  verbsList: null
  resumeView: null
#  modalPanel: null
  subscriptions: null
  content: null

  activate: (state) ->

    @subs = new CompositeDisposable
    @emitter = new Emitter

    pkgEmitter =
      onAddBlock: (callback) => @onAddBlocks(callback)
      onOpenBlock: (callback) => @onOpenBlock(callback)

    self = this
    console.log ('main: activate')
    # Register command that toggles this view
    @subs.add atom.commands.add 'atom-workspace', 't4html-editor:toggle': ->
      BlockList.detect(pkgEmitter)

  onAddBlock: (callback) ->
    @emitter.on 'add-block', callback

  onOpenBlock: (callback) ->
    @emitter.on 'open-block', callback


  deactivate: ->
    @subs.dispose()
    @emitter.dispose()
