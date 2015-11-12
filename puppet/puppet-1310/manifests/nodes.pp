
node dpb-w500 {
    include common-system
    include editors
    include office
    include media
    include python-dev
    include cc-dev
    include java-dev
    include database
    include languages
    include devtools
    include system-utilities
    class {'network-connectivity': node_type=>'server'}
    include crypt-filesystems
    include network-filesystems
#     # XXX dpb - Ubuntu 12.04 temp comment this out;
#     include virtual
    include misc
#     include games
    include system-dpb-w500
}

node dpb-thinkpad-t420s {
  include common-system
  include editors
  include office
  include python-dev
  include cc-dev
  include languages
  include devtools
#  class {'network-connectivity': node_type=>'server'}
  include crypt-filesystems
  include network-filesystems
  include system-utilities
  include media
#  include virtual
  include system-don-t420
}

node dpb-x100e {
  include common-system
  include editors
#  include office
#  include python-dev
#  include cc-dev
#  include languages
#  include devtools
  class {'network-connectivity': node_type=>'server'}
  include crypt-filesystems
  include network-filesystems
  include system-utilities
#  include media
#  include virtual
  include system-dpb-x100e
}

node qdesktop-don {
  include common-system
  include editors
  include office
  include python-dev
  include cc-dev
  include languages
  include devtools
  class {'network-connectivity': node_type=>'server'}
  include crypt-filesystems
  include network-filesystems
  include system-utilities
  include media
  include virtual
  include system-qdesktop-don
}

node fastapi-vdon1 {
  include common-system
  include editors
}

node don-Ubuntu1204 {
  include common-system
  include editors
  include devtools
  include crypt-filesystems
  include network-filesystems
}

node castle {
  include common-system
  include editors
  class {'network-connectivity': node_type=>'server'}
  include crypt-filesystems
  include network-filesystems
  include system-utilities
  include server-desktop
  include system-castle
}

node nas {
  include common-system
  include editors
  class {'network-connectivity': node_type=>'server'}
  include crypt-filesystems
  include network-filesystems
  include system-utilities
  include system-nas
}

node dpb-VirtualUbuntu1110 {
    include editors
    include python-dev
    include media
    include cc-dev
#    include database
#    include java-dev
#    include languages
#    include office
}

node virt-Ubuntu1104 {
    include editors
    include python-dev
    include media
    include cc-dev
    include database
    include java-dev
    include languages
    include office
}

node don {
    include editors
    include crypt-filesystems
    class {'network-connectivity': node_type=>'server'}
}

node ubuntu1110 {
    include editors
    class {'network-connectivity': node_type=>'server'}
    include server-desktop
}


# Need to add module to:
#   - add ubuntu desktop;
#   - remove openoffice stuff;
