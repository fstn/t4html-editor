{$} = require 'atom-space-pen-views'
{Config} = require './config.coffee'
{Package} = require './package'
{Block} = require './model/block'

class PackageFacade

  @build: (success,error) ->
    console.log 'BlockFacade: save'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/packages/build/',
      type: 'GET',
      success  : (block, status, xhr) ->
        self.success(res) if self.success
        console.log 'PackageFacade: Package loaded'
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log 'PackageFacade: Unable to package'
      complete : (xhr, status) ->
        console.log 'PackageFacade: Package completed'


module.exports =
  PackageFacade: PackageFacade
