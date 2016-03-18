{View,$} = require 'space-pen'
{TextEditorView,SelectListView} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class BlockSelectView extends SelectListView
   initialize: ->
    @emitter = new Emitter
    self = this
    self.selectedBlock = {}
    $.ajax 'http://localhost:8080/rest/blocks/original',
        success  : (data, status, xhr) ->
            self.setItems(data);
            console.log "data"+data
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
     "<li>#{item.name}</li>"

   confirmed: (item) ->
     @emitter.emit 'selected-block-changed', item
     @emitter.dispose()
     self.selectedBlock = item
     @filterEditorView.setText(item.name)
     console.log("#{item.name} was selected")

   cancelled: ->
     @filterEditorView.setText('')
     console.log("This view was cancelled")
