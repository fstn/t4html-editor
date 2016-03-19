BlockList = require './t4html-block-list'
VerbList = require './t4html-verb-list'
ResumeView = require './t4html-resume'
{View,$} = require 'space-pen'
{Emitter} = require 'event-kit'

module.exports =
class AddBlockView
    self = this
    constructor: ->
      console.log ('add-block-view: initialize ')
      self.blocksList = new BlockList()
      self.verbsList = new VerbList()
      self.resumeView = new ResumeView()
      self.content = document.createElement('div')
      self.content.className = 'view'
    getContent: ->
      self.content

    toggle: ->
      console.log ('add-block-view:append: '+self.blocksList.getContent())
      $(".view").append(self.blocksList.getContent())
      console.log ('add-block-view:append: '+self.verbsList[0])
      $(".view").append(self.verbsList[0])
      console.log ('add-block-view:append: '+self.resumeView[0])
      $(".view").append(self.resumeView[0])
      console.log ('add-block-view:content: '+self.content)

      self.blocksList.toggle()
      $(".createBlocks").show()
      $(".createBlocks").on( "click", self.toggle)

      self.verbsList.emitter.on 'selected-verb-changed', (verb) ->
        self.resumeView.setSelectedVerb verb

      self.blocksList.getEmitter().on 'selected-block-changed', (block) ->
        self.resumeView.setSelectedBlock  block
