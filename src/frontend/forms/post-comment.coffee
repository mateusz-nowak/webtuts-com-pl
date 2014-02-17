forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = forms.create(
  content: fields.string(
    label: 'Treść komentarza'
    required: true
    widget: forms.widgets.textarea
      classes: ['span6', 'form-control']
      rows: 5
  ),
)

