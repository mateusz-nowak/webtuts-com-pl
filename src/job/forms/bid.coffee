forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = forms.create(
  price: fields.number(
    label: 'Propozycja cenowa [zł]'
    widget: forms.widgets.text
      classes: ['form-control']
    validators: [ validators.range(1, 500000, 'Kwota musi być z przedziału 1 - 500,000zł') ]
    required: true
  ),

  content: fields.string(
    label: 'Dodatkowy opis'
    required: true
    widget: forms.widgets.textarea
      classes: ['form-control'],
      rows: 10
  )
)
