(function() {
  var scm_tabs, software,
    _this = this;

  scm_tabs = $$('.scm_tab');

  software = $('software');

  if (software) {
    software.addEvent('change', function(event) {
      var scm, scm_tab;
      scm_tabs.setStyle('display', 'none');
      scm = software.getSelected().get('value');
      scm_tab = $('scm_' + scm);
      if (scm_tab != null) return scm_tab.reveal();
    });
    software.fireEvent('change');
  }

}).call(this);
