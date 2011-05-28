// Behavior for SCM Configuration form
(function() {
    var scm_tabs = $$('.scm_tab');
    var software = $('scm_id');
    if(software) {
        software.addEvent('change', function() {
            scm_tabs.setStyle('display', 'none');
            var scm     = this.getSelected().get('text').toString().split(':', 1);
            var scm_tab = $('scm_' + scm);
            if(scm_tab) {
                scm_tab.reveal();
            }
        });
        software.fireEvent('change');
    }
})();

