class Config
    @START_FLAG: "<!--start-block";
    @END_FLAG: "<!--end-block";
    @INSERT_FLAG: "<!--insert-content-->";
    @BLOCK_EXTENSION: ".html.blocks";
    @REPLACE_VERB: "replace";
    @REPLACE_VERB: "replace";
    @AROUND_VERB: "around";
    @AFTER_VERB: "after";
    @BEFORE_VERB: "before";
    @APPEND_VERB: "append";
    @PREPEND_VERB: "prepend";
    @DESCRIBE_VERB: "describe";
    constructor: ->
      
module.exports =
  Config: Config
