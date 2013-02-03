# Behavior for SCM Configuration form
scm_tabs = $$('.scm_tab')
software = $('scm_id')

if software
    software.addEvent 'change', (event) =>
        scm_tabs.setStyle 'display', 'none'
        scm = software.getSelected().get('text').toString().split(':', 1)
        scm_tab = $('scm_' + scm)
        scm_tab.reveal() if scm_tab?
    software.fireEvent 'change'
