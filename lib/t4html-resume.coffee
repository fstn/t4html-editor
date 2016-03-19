{View,$} = require 'space-pen'

module.exports =
class ResumeView extends View
  self = this
  self.selectedBlock = {}
  self.selectedVerb = {}
  @content: ->
    @div class: 'resume-view', =>
      @div class: 'selected-block',
      @div class: 'selected-verb',

  setSelectedBlock: (block) ->
    self.selectedBlock = block
    $(".selected-block").text(block.name);
    console.log("#{block.name} was selected in resume view")


  setSelectedVerb: (verb) ->
    self.selectedVerb = verb
    $(".selected-verb").text(verb);
