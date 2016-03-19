{View,$} = require 'space-pen'
{TextEditorView,SelectListView} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class BlockSelectView  extends View

  @content: ->
    @div class: 'verbs-list', =>

   initialize: ->
    @emitter = new Emitter
    self = this
    $.ajax 'http://localhost:8080/rest/verbs',
        success  : (data, status, xhr) ->
            self.setItems(data);
        error    : (xhr, status, err) ->
            console.log("nah "+err)
        complete : (xhr, status) ->
            console.log("comp")
    @addClass('col-xs-2')

   setItems: (items) ->
    $(".verbs-list").html("<div class='block'>
          <div>Extra Small</div>
          <div class='btn-group btn-group-xs verbs-group'>
          </div>
      </div>
    ")
    items.forEach (item, i) ->
      if item == "replace"
        $(".verbs-group").append("<button class='btn icon icon-gear inline-block-tight btn-error col-xs-12'>"+item+"</button>")
      else
        $(".verbs-group").append("<button class='btn icon icon-gear inline-block-tight btn-primary col-xs-12'>"+item+"</button>")
      return




   viewForItem: (item) ->
     "<li>#{item}</li>"

   confirmed: (item) ->
     @emitter.emit 'selected-verb-changed', item
     @filterEditorView.setText(item)
     console.log("#{item} was selected")

   cancelled: ->
     @filterEditorView.setText('')
     console.log("This view was cancelled")
