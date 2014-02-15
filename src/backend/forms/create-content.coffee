forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = forms.create(
  title: fields.string(
    label: 'Tytuł podstrony'
    widget: forms.widgets.text
      classes: ['span6', 'form-control']
    required: true
  ),

  content: fields.string(
    label: 'Treść podstrony (markdown włączony)'
    required: true
    widget: forms.widgets.textarea
      classes: ['span6', 'form-control']
  ),
)
