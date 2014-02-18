forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = (categories) ->
  return forms.create(
    title: fields.string(
      label: 'Tytuł'
      required: true
      widget: forms.widgets.text
        classes: ['span6', 'form-control']
    ),
    category: fields.string(
      label: 'Tytuł'
      required: true
      choices: categories
      widget: forms.widgets.select
        classes: ['span6', 'form-control']
    ),
    tags: fields.string(
      label: 'Tagi (oddziel przecinkami)'
      required: true
      widget: forms.widgets.text
        classes: ['span6', 'form-control']
    ),
    intro: fields.string(
      label: 'Zajawka'
      required: true
      widget: forms.widgets.textarea
        classes: ['span6', 'form-control']
        rows: 5
    ),
    content: fields.string(
      label: 'Treść'
      required: true
      widget: forms.widgets.textarea
        classes: ['span6', 'form-control']
        rows: 10
    ),
  )
