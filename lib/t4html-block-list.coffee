{View,$} = require 'space-pen'
{TextEditorView,SelectListView} = require 'atom-space-pen-views'
{Emitter} = require 'event-kit'

module.exports =
class BlockSelectView
    self = this
    constructor: ->
      console.log ('block-list: initialize ')
      self.content = document.createElement('div')
      self.content.className = 'blocks-list'
      self.emitter = new Emitter
    getEmitter: -> self.emitter
    getContent: -> self.content
    toggle: ->
      $.ajax 'http://localhost:8080/rest/blocks/original',
          success  : (data, status, xhr) ->
                $(".blocks-list").html("
                <div class='select-list blocks-list-container'>
                    <ol class='list-group blocks-group'>
                    </ol>
                </div>
                ")
                data.forEach (item, i) ->
                    $(".blocks-group").append("
                        <li class='selected'>
                            <div class='status status-added icon icon-diff-added'></div>
                            <div class='icon icon-file-text'>"+item.name+"</div>
                        </li>")
                  return
          error    : (xhr, status, err) ->
              console.log("nah "+err)
          complete : (xhr, status) ->
              console.log("comp")

   viewForItem: (item) ->
     "<li>#{item}</li>"

   confirmed: (item) ->
     @emitter.emit 'selected-verb-changed', item
     @filterEditorView.setText(item)
     console.log("#{item} was selected")

   cancelled: ->
     @filterEditorView.setText('')
     console.log("This view was cancelled")
