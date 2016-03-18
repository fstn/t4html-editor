{View,$} = require 'space-pen'
{TextEditorView,SelectListView} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class BlockSelectView extends SelectListView
   initialize: ->
    @emitter = new Emitter
    self = this
    self.selectedVerb = {}
    $.ajax 'http://localhost:8080/rest/verbs',
        success  : (data, status, xhr) ->
            cleanData = []
            self.setItems(data);
            console.log "data"+cleanData
        error    : (xhr, status, err) ->
            console.log("nah "+err)
        complete : (xhr, status) ->
            console.log("comp")
    super
    @addClass('col-xs-2')
    realData = []

    @setItems(realData)
    @focusFilterEditor()

   viewForItem: (item) ->
     "<li>#{item}</li>"

   confirmed: (item) ->
     @emitter.emit 'selected-verb-changed', item
     @emitter.dispose()
     self.selectedVerb = item
     @filterEditorView.setText(item)
     console.log("#{item} was selected")

   cancelled: ->
     @filterEditorView.setText('')
     console.log("This view was cancelled")
