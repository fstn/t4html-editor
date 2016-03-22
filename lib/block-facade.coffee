{$} = require 'atom-space-pen-views'
{Config} = require './config.coffee'
{Package} = require './package'
{Block} = require './model/block'

class BlockFacade

  @save: (block,success,error) ->
    console.log 'BlockFacade: save'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/blocks/available/',
      type: 'POST',
      data: JSON.stringify(block),
      contentType: 'application/json; charset=utf-8',
      dataType: 'json',
      success  : (block, status, xhr) ->
        self.success(res) if self.success
        console.log 'BlockFacade: Save completed'
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log 'BlockFacade: Unable to save'
      complete : (xhr, status) ->
        console.log 'BlockFacade: save completed'

  @delete: (block,success,error) ->
    console.log 'BlockFacade: delete'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/blocks/available/'+block.name+'/'+block.verb,
      type: 'DELETE',
      success  : (res, status, xhr) ->
        self.success(res) if self.success
        console.log 'BlockFacade: Delete blocks '+customBlocks
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log 'BlockFacade: Unable to delete blocks '
      complete : (xhr, status) ->
        console.log 'BlockFacade: delete completed'

  @getCustomByOriginal:(block,success,error) ->
    console.log 'BlockFacade: getAvailableByOriginal'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/blocks/available/'+block.name,
      type: 'GET',
      success  : (resBlock, status, xhr) ->
        self.success(resBlock)
        console.log 'BlockFacade: getCustomByOriginal: loaded'
      error    : (xhr, status, err) ->
        self.error(xhr) if self.error
        console.log 'BlockFacade: Unable to load custom blocks'
      complete : (xhr, status) ->
        console.log 'BlockFacade: getCustomByOriginal completed'



  @getAllOriginal:(success,error) ->
    console.log 'BlockFacade: getAllOriginal'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/blocks/original',
      success  : (data, status, xhr) ->
          blockSortByOrigin = data.reduce(((map, obj) ->
              if map[obj.origin] == undefined
                map[obj.origin] = []
              map[obj.origin].push  obj
              map
          ), {})
          state = {}
          self.success(blockSortByOrigin)
          console.log 'BlockFacade: getAllOriginal: loaded'
      error    : (xhr, status, err) ->
          console.log("BlockFacade: Unable to get originalBlocks "+err)
          self.error(xhr) if self.error
      complete : (xhr, status) ->
        console.log 'BlockFacade: getAllOriginal completed'

  @getAllCustom:(success,error) ->
    console.log 'BlockFacade: getAllCustom'
    self = this
    self.success = success
    self.error = error
    $.ajax Config.WS_URL+'/blocks/available',
      success  : (data, status, xhr) ->
          blockSortByOriginalName = data.reduce(((map, obj) ->
              if map[obj.name] == undefined
                map[obj.name] = {}
              map[obj.name][obj.verb] = obj
              map
          ), {})
          state = {}
          self.success(blockSortByOriginalName)
          console.log 'BlockFacade: getAllCustom loaded'
      error    : (xhr, status, err) ->
          console.log 'BlockFacade: getAllCustom Unable to get originalBlocks '+err
          self.error(xhr) if self.error
      complete : (xhr, status) ->
        console.log 'BlockFacade: getAllCustom completed'

  @getCustomyOriginalAndVerb: (originalBlock,verb,callBack) ->
    customBlockNotFilter = Package.model.customBlocksSortByName[originalBlock.name]
    customBlock = undefined
    if customBlockNotFilter != undefined
      customBlock = customBlockNotFilter[verb]
    console.log 'BlockFacade Looking for custom block '+Config.BEFORE_VERB+' '+originalBlock.name+' -> '+customBlock
    if customBlock == undefined
      customBlock = new Block(originalBlock.name,Config.BEFORE_VERB,'')
    callBack(customBlock)


  @cleanContent: (blockContent) ->
    blockContent = blockContent.replace(/^\s*$[\n\r]{1,}/gm,'')
    blockContent

  @removeDescribeTag: (blockContent) ->
    blockContent = blockContent.replace(/<!--start-block:describe:.*-->([\s\S]*?)<!--end-block:describe:.*-->/, "$1");
    blockContent

module.exports =
  BlockFacade: BlockFacade
