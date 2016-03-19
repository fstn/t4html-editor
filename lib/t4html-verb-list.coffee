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
    @addClass('col-xs-6')

   setItems: (items) ->
    $(".verbs-list").html("
    <div class='select-list verbs-list-container'>
        <ol class='list-group verbs-group'>
        </ol>
    </div>
    ")
    items.forEach (item, i) ->
        $(".verbs-group").append("
            <li class='selected'>
                <div class='status status-added icon icon-diff-added'></div>
                <div class='icon icon-file-text'>"+item+"</div>
            </li>")
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
