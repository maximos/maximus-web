template =
    doForms: ->
        $$('form.jsForm').each (form) ->
            # Prepare form inputs to hold error messages for invalid input
            form.getElements('[type=text], [type=password], textarea, select').each (el) ->
                id = el.get('id') + '_error_msg'
                dd_error = new Element 'dd', id: id, class: 'error'
                el.set 'class', el.get('class') + " msgPos:'" + id + "'"
                dd = el.getParent 'dd'
                dd_error.inject dd, 'after'
            new Form.Validator.Inline form, errorPrefix: ''

        # theme inputs (only in ff2+ ie7+ chrome safari3 etc)
        if (Browser.ie and parseFloat(Browser.version) >= 6) or Browser.chrome or Browser.safari or Browser.opera or (Browser.firefox and parseFloat(Browser.version) >= 2)
            $$('input[type=text],input[type=password],textarea,select').each (element) ->
                # contain the input
                container = new Element 'div', style: 'display:inline-block'
                container = container.wraps element

                # theme the input
                template.roundSingleElement 'Input', container

                # add focus events
                element.addEvents(
                    focus: -> container.addClass 'skinInputFocusedBox'
                    blur: -> container.removeClass 'skinInputFocusedBox'
                )

    doRoundedBoxes: (type) ->
        # add rounded theme to boxes
        type = type.capitalize()
        $$('.js'+type+'Box').each (element) ->
            template.roundSingleElement(type, element)

    doCloseableBoxes: ->
        # add close button to boxes
        $$('.jsCloseableBox').each (element) ->
            element.addClass('skinCloseIconOff').addEvents(
                mouseenter: ->
                    element.removeClass('skinCloseIconOff').addClass('skinCloseIconOn')
                mouseleave: ->
                    element.removeClass('skinCloseIconOn').addClass('skinCloseIconOff')
                click: ->
                    fx = new Fx.Tween element

                    if Browser.ie
                        # internet explorer
                        element.setStyle 'overflow', 'hidden'
                        fx.start('height', 0).chain(-> element.destroy())
                    else
                        # others (good browsers)
                        fx.start('opacity', 0).chain(-> this.start 'height', 0)
                                              .chain(-> element.destroy())
            )

    roundSingleElement: (type, element) ->
        element.removeClass 'js'+type+'Box'
        row1 = new Element 'div', class: 'skin'+type+'Row1'
        row1.adopt new Element('div', class: 'skin'+type+'TopLeft')
                  ,new Element('div', class: 'skin'+type+'TopRight')
                  ,new Element('div', class: 'skin'+type+'Top')
        
        row2 = new Element 'div', class: 'skin'+type+'Row2'
        row2.adopt new Element('div', class: 'skin'+type+'Content').adopt(element.childNodes)
        
        row3 = new Element 'div', class: 'skin'+type+'Row3'
        row3.adopt new Element('div', class: 'skin'+type+'BottomLeft')
                  ,new Element('div', class: 'skin'+type+'BottomRight')
                  ,new Element('div', class: 'skin'+type+'Bottom')

        element.empty().addClass('skin'+type+'Box').adopt row1, row2, row3

# setup rounded rectangles
template.doRoundedBoxes('rounded')
template.doRoundedBoxes('error')
template.doRoundedBoxes('success')

# setup closable boxes
template.doCloseableBoxes()

# setup forms
template.doForms()
