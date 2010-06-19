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
		//register formcheck forms
		$$('form.jsForm').each(function(element) {
			element.store('formCheck',new FormCheck(element,{
				display: {
					fadeDuration: (Browser.Engine.trident?0:220),
					fixPngForIe: false
				}
			}));
		});
		
		//theme inputs (only in ff2+ ie7+ chrome safari3 etc)
		if ((Browser.Engine.trident && Browser.Engine.version >= 6) || Browser.Engine.webkit || (Browser.Engine.gecko && Browser.Engine.version >= 18)) { 
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
					
					if (Browser.Engine.trident) {
						//internet explorer
						if (Browser.Engine.version <= 4) {
							//ie6
							template.removeAllFormTips();
							element.destroy();
						} else {
							//newer
							element.setStyle('overflow','hidden');
							template.removeAllFormTips();
						    fx.start('height', '0').chain(function() {
						        element.destroy();
						    });
						}
					} else {
						//others (good browsers)
						template.removeAllFormTips();
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
	
	removeAllFormTips: function() {
		$$('.jsForm').each(function(element) {
			element.retrieve('formCheck').reinitialize('forced');
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
}