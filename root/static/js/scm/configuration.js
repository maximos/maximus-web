// Behavior for SCM Configuration form
window.addEvent('domready', function() {
    var scm_tabs = $$('.scm_tab');
    var software = $('software');
    if(software) {
        software.addEvent('change', function() {
            scm_tabs.setStyle('display', 'none');
            var scm     = this.getSelected().get('value');
            var scm_tab = $('scm_' + scm);
            if(scm_tab) {
                scm_tab.reveal();
            }
        });
        software.fireEvent('change');
    }
});

