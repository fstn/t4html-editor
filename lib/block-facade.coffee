{$} = require 'atom-space-pen-views'
{Config} = require './config.coffee'

class BlockFacade

  @save: (block,success,error) ->
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'available/',
      type: 'POST',
      data: JSON.stringify(block),
      contentType: 'application/json; charset=utf-8',
      dataType: 'json',
      success  : (block, status, xhr) ->
        self.success(res) if self.success
        console.log('Save completed')
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log('Unable to save')
      complete : (xhr, status) ->
        console.log("comp")

  @delete: (block,success,error) ->
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'available/'+block.name+'/'+block.verb,
      type: 'DELETE',
      success  : (res, status, xhr) ->
        self.success(res) if self.success
        console.log('Delete blocks '+customBlocks)
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log('Unable to delete blocks ')
      complete : (xhr, status) ->
        console.log("Delete blocks completed")

  @get:(block,success,error) ->
    self = this
    console.log("success "+success)
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'available/'+block.name,
    type: 'GET',
    success  : (resBlock, status, xhr) ->
      self.success(resBlock)
    error    : (xhr, status, err) ->
      self.error(xhr) if self.error
      console.log('Unable to load custom blocks')
    complete : (xhr, status) ->
      console.log("comp")
module.exports =
  BlockFacade: BlockFacade
