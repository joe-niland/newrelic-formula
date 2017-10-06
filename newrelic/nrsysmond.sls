newrelic-sysmond:
  pkg:
    - installed
  service.running:
    - watch:
        - pkg: newrelic-sysmond
        - file: add_licence_key

comment_default_licence_key:
  file.comment:
    - name: /etc/newrelic/nrsysmond.cfg
    - regex: ^license_key=REPLACE_WITH_REAL_KEY
    - require:
        - pkg: newrelic-sysmond
    - onlyif: |
        cat /etc/newrelic/nrsysmond.cfg | grep ^license_key=REPLACE_WITH_REAL_KEY

add_licence_key:
  file.blockreplace:
    - name: /etc/newrelic/nrsysmond.cfg
    - append_if_not_found: True
    - marker_start: '#-- salt managed license key zone --'
    - marker_end: '#-- end salt managed license key --'
    - content: |
        license_key={{ salt['pillar.get']('newrelic:apikey', '') }}
    - require:
        - pkg: newrelic-sysmond
