View      = require "teacup-view"

layout    = require "../layouts/default"

_         = require "lodash"
_.string  = require "underscore.string"

module.exports = new View (data) ->
  data.subtitle = "Cases provided by our readers"

  {
    query
    stories
    csrf
  } = data

  
  layout data, =>

    @form
      method: "GET"
      class : "form"
      =>
        @div class: "input-group input-group-lg", =>
          @input
            id          : "query"
            type        : "text"
            name        : "query"
            class       : "form-control"
            placeholder : "Type to search for story..."
            value       : query
          @div class: "input-group-btn", =>
            @button
              class : "btn btn-primary"
              type  : "submit"
              =>
                @i class: "fa fa-search"
                @text " Search"
            @dropdown items: [
              title : "new story"
              icon  : "plus-sign"
              data  :
                toggle  : "modal"
                target  : "#story-new-dialog"
                shortcut: "n"
              herf  : "#new-story"
            ]

    do @hr

    if stories.length # then @div class: "list-group", =>
      for story in stories
        @div class: "panel panel-default", =>
          @a href: "/stories/#{story._id}", class: "panel-body list-group-item", =>
            @span class: "badge", story.questions.length
            @markdown _.string.prune story.text, 256
          @div class: "panel-footer", =>
            if story.questions.length 
              @p => @strong "#{story.questions.length} legal questions:"
              @ul class: "list-inline", =>
                for question in story.questions
                  @li => @a href: "/questions/#{question._id}", question.text
            else @strong "No questions abstracted yet."

            
        
    else @div class: "alert alert-info", "Nothing like that found. Sorry :P"
    
    @modal 
      title : "New story"
      id    : "story-new-dialog"
      =>
        @p "Please tell us your story."
        @storyForm
          method  : "POST"
          action  : "/stories/"
          csrf    : csrf

