(function() {
  var s, template, _i, _len, _ref;

  template = {
    doForms: function() {
      $$('form.jsForm').each(function(form) {
        form.getElements('[type=text], [type=password], textarea, select').each(function(el) {
          var dd, dd_error, id;
          id = el.get('id') + '_error_msg';
          dd_error = new Element('dd', {
            id: id,
            "class": 'error'
          });
          el.set('class', el.get('class') + " msgPos:'" + id + "'");
          dd = el.getParent('dd');
          return dd_error.inject(dd, 'after');
        });
        return new Form.Validator.Inline(form, {
          errorPrefix: ''
        });
      });
      if ((Browser.ie && parseFloat(Browser.version) >= 6) || Browser.chrome || Browser.safari || Browser.opera || (Browser.firefox && parseFloat(Browser.version) >= 2)) {
        return $$('input[type=text],input[type=password],textarea,select').each(function(element) {
          var container;
          container = new Element('div', {
            style: 'display:inline-block'
          });
          container = container.wraps(element);
          template.roundSingleElement('Input', container);
          return element.addEvents({
            focus: function() {
              return container.addClass('skinInputFocusedBox');
            },
            blur: function() {
              return container.removeClass('skinInputFocusedBox');
            }
          });
        });
      }
    },
    doRoundedBoxes: function(type) {
      type = type.capitalize();
      return $$('.js' + type + 'Box').each(function(element) {
        return template.roundSingleElement(type, element);
      });
    },
    doCloseableBoxes: function() {
      return $$('.jsCloseableBox').each(function(element) {
        return element.addClass('skinCloseIconOff').addEvents({
          mouseenter: function() {
            return element.removeClass('skinCloseIconOff').addClass('skinCloseIconOn');
          },
          mouseleave: function() {
            return element.removeClass('skinCloseIconOn').addClass('skinCloseIconOff');
          },
          click: function() {
            var fx;
            fx = new Fx.Tween(element);
            if (Browser.ie) {
              element.setStyle('overflow', 'hidden');
              return fx.start('height', 0).chain(function() {
                return element.destroy();
              });
            } else {
              return fx.start('opacity', 0).chain(function() {
                return this.start('height', 0);
              }).chain(function() {
                return element.destroy();
              });
            }
          }
        });
      });
    },
    roundSingleElement: function(type, element) {
      var row1, row2, row3;
      element.removeClass('js' + type + 'Box');
      row1 = new Element('div', {
        "class": 'skin' + type + 'Row1'
      });
      row1.adopt(new Element('div', {
        "class": 'skin' + type + 'TopLeft'
      }), new Element('div', {
        "class": 'skin' + type + 'TopRight'
      }), new Element('div', {
        "class": 'skin' + type + 'Top'
      }));
      row2 = new Element('div', {
        "class": 'skin' + type + 'Row2'
      });
      row2.adopt(new Element('div', {
        "class": 'skin' + type + 'Content'
      }).adopt(element.childNodes));
      row3 = new Element('div', {
        "class": 'skin' + type + 'Row3'
      });
      row3.adopt(new Element('div', {
        "class": 'skin' + type + 'BottomLeft'
      }), new Element('div', {
        "class": 'skin' + type + 'BottomRight'
      }), new Element('div', {
        "class": 'skin' + type + 'Bottom'
      }));
      return element.empty().addClass('skin' + type + 'Box').adopt(row1, row2, row3);
    }
  };

  _ref = ['rounded', 'error', 'success'];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    s = _ref[_i];
    template.doRoundedBoxes(s);
  }

  template.doCloseableBoxes();

  template.doForms();

}).call(this);
