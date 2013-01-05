# Behavior for SCM Configuration form
scm_tabs = $$('.scm_tab')
software = $('software')

if software
    software.addEvent 'change', (event) =>
        scm_tabs.setStyle 'display', 'none'
        scm = software.getSelected().get 'value'
        scm_tab = $('scm_' + scm)
        scm_tab.reveal() if scm_tab?
    software.fireEvent 'change'
