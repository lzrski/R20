# Story model

mongoose  = require "mongoose"
_         = require "underscore"

Story = new mongoose.Schema
  text        : 
    type        : String
    required    : yes
  questions : [
    type      : mongoose.Schema.ObjectId
    ref       : 'Question'
  ]

Story.pre "validate", (done) ->
  @questions = _.unique @questions.map (oid) -> do oid.toString
  do done

Story.plugin (require "./Journal"),
  omit:
    questions: true
  populate: [
    path  : "meta.author"
    model : "Participant"
  ,
    path  : "data.main_doc"
    model : "Story"
  ,
    path  : "data.referenced_doc"
    model : "Question"
  ]

module.exports = mongoose.model 'Story', Story