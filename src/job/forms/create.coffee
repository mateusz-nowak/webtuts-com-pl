forms = require 'forms-bootstrap'

fields = forms.fields
validators = forms.validators
widgets = forms.widgets

module.exports = (categories) ->
  return forms.create(
    title: fields.string(
      label: 'Tytuł zlecenia'
      widget: forms.widgets.text
        classes: ['form-control']
      required: true
    ),

    content: fields.string(
      label: 'Opis zlecenia'
      required: true
      widget: forms.widgets.textarea
        classes: ['form-control'],
        rows: 10
    ),

    contactName: fields.string(
      label: 'Imię i nazwisko osoby kontaktowej',
      required: true
      widget: forms.widgets.text
        classes: ['form-control'],
    ),

    contactMail: fields.string(
      label: 'E-mail kontaktowy'
      required: true
      widget: forms.widgets.text
        classes: ['form-control'],
    ),

    contactPhone: fields.string(
      label: 'Telefon kontaktowy'
      widget: forms.widgets.text
        classes: ['form-control'],
    ),

    category: fields.string(
      label: 'Kategorie zlecenia'
      required: true
      choices: categories
      widget: forms.widgets.select
        classes: ['span6', 'form-control']
    ),
  )
