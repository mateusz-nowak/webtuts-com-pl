forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = forms.create(
  title: fields.string(
    label: 'Temat'
    required: true
    widget: forms.widgets.text
      classes: ['form-control']
  )

  content: fields.string(
    label: 'Treść'
    required: true
    widget: forms.widgets.textarea
      classes: ['span6', 'form-control']
      rows: 10
  ),
)

