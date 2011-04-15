window.addEvent('domready', function() {
    //setup rounded rectangles
    template.doRoundedBoxes('rounded');
    template.doRoundedBoxes('error');
    template.doRoundedBoxes('success');
    
    //setup closeable boxes
    template.doCloseableBoxes();
    
    //setup forms
    template.doForms();
});

var template = {
    doForms: function() {
        $$('form.jsForm').each(function(form) {
            // Prepare form inputs to hold error messages for invalid input
            form.getElements('[type=text], [type=password], textarea').each(function(el) {
                var id = el.get('id') + '_error_msg'
                var dd_error = new Element('dd', {
                    id: id,
                    'class': 'error',
                });
                el.set('class', el.get('class') + " msgPos:'" + id + "'");
                dd_error.inject(el.getParent('dd'), 'after');
            });

            new Form.Validator.Inline(form);
        });
        
        //theme inputs (only in ff2+ ie7+ chrome safari3 etc)
        if ((Browser.ie && Browser.version >= 6) || Browser.chrome || Browser.safari || Browser.opera || (Browser.gecko && Browser.version >= 18)) { 
            $$('input[type=text],input[type=password],textarea,select').each(function(element) {
                //contain the input
                var container = new Element('div',{'style':'display:inline-block;'}).wraps(element);
                
                //theme the input
                template.roundSingleElement('Input',container);
                
                //add focus events
                element.addEvents({
                    'focus': function() {
                        container.addClass('skinInputFocusedBox');
                    },
                    'blur': function() {
                        container.removeClass('skinInputFocusedBox');
                    }
                });
            });
        }
    },
        
    doRoundedBoxes: function(type) {
        //add rounded theme to boxes
        type = type.capitalize();
        
        $$('.js'+type+'Box').each(function(element) {
            template.roundSingleElement(type,element);
        })
    },
    
    doCloseableBoxes: function() {
        //add close button to boxes
        $$('.jsCloseableBox').each(function(element) {
            element.addClass('skinCloseIconOff').addEvents({
                'mouseenter':function() {
                    element.removeClass('skinCloseIconOff').addClass('skinCloseIconOn');
                },
                'mouseleave':function() {
                    element.removeClass('skinCloseIconOn').addClass('skinCloseIconOff');
                },
                'click': function() {
                    var fx = new Fx.Tween(element);
                    
                    if (Browser.ie) {
                        //internet explorer
                        if (Browser.version <= 4) {
                            //ie6
                            element.destroy();
                        } else {
                            //newer
                            element.setStyle('overflow','hidden');
                            fx.start('height', '0').chain(function() {
                                element.destroy();
                            });
                        }
                    } else {
                        //others (good browsers)
                        fx.start('opacity', '0').chain(function() {
                            this.start('height', '0')
                        }).chain(function() {
                            element.destroy();
                        });
                    }
                }
            })
        });
    },
    
    roundSingleElement: function(type,element) {
        element.removeClass('js'+type+'Box');
        var row1 = new Element('div', {'class': 'skin'+type+'Row1'}).adopt(
            new Element('div', {'class': 'skin'+type+'TopLeft'}),
            new Element('div', {'class': 'skin'+type+'TopRight'}),
            new Element('div', {'class': 'skin'+type+'Top'})
        );
        var row2 = new Element('div', {'class': 'skin'+type+'Row2'}).adopt(
            new Element('div',{'class':'skin'+type+'Content'}).adopt(element.childNodes)
        );
        var row3 = Element('div', {'class': 'skin'+type+'Row3'}).adopt(
            new Element('div', {'class': 'skin'+type+'BottomLeft'}),
            new Element('div', {'class': 'skin'+type+'BottomRight'}),
            new Element('div', {'class': 'skin'+type+'Bottom'})
        );
        element.empty().addClass('skin'+type+'Box').adopt(row1,row2,row3);
    }
};

