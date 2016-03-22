class Block
    constructor: (@name,@verb,@content)->
      console.log("Block: constructor "+JSON.stringify(this))

module.exports =
  Block: Block
