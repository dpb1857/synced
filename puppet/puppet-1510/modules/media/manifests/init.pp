
class media {

    # Two packages we might want to use in other contexts without pulling in all of the extras -
    #   flashplugin-installer
    #   ttf-mscorefonts-installer
    #
    # Mentioned support for dvds -
    #	Please note that this does not install libdvdcss2, and will not let you play
    #   encrypted DVDs. For more information, see
    #	https://help.ubuntu.com/community/RestrictedFormats/PlayingDVDs

    package {'ubuntu-restricted-extras':
        ensure => installed,
    }

    package {'digikam':
        ensure => installed,
    }

    package {'digikam-doc':
        ensure => installed,
    }

    package {'exfat-fuse':
        ensure => installed,
    }

    package {'exfat-utils':
        ensure => installed,
    }

    package {'gimp':
        ensure => installed,
    }

    package {'gimp-help-en':
        ensure => installed,
    }

    package {'gscan2pdf':
        ensure => installed,
    }

    package {'hugin':
        ensure => installed,
    }

    package {'imagemagick':
        ensure => installed,
    }

    package {'kipi-plugins':
        ensure => installed,
    }

    package {'showfoto':
        ensure => installed,
    }

    package {'xsane':
        ensure => installed,
    }

    package {'amarok':
        ensure => installed,
    }

    package {'audacity':
        ensure => installed,
    }

    package {'avidemux':
        ensure => installed,
    }

    package {'easytag':
        ensure => installed,
    }

#    package {'kino':
#        ensure => installed,
#    }

#    package {'libxine1-ffmpeg':
#        ensure => installed,
#    }

#    package {'mjpegtools':
#        ensure => installed,
#    }

# XXX don Ubuntu 12.04 temporary comment this out;
#    package {'libavformat-extra-52':
#        ensure => installed,
#    }

    # OpenShot & H.264:
    # from: http://www.openshotusers.com/forum/viewtopic.php?f=12&t=912
    # Solved. Went to Synaptic and installed libavformat-extra-52 and that did it.

    # Movie editor
    package {'openshot':
        ensure => installed,
    }

    package {'ripperx':
        ensure => installed,
    }

    package {'youtube-dl':
    	ensure => installed,
    }

    # Transcode/rip DVDs
    package {'handbrake':
        ensure => installed,
    }

    # Make sure we installed the package to read DVDs;
    # sudo /usr/share/doc/libdvdread4/install-css.sh
    # This finds or builds the deb package libdvdcss2; can we write a puppet rule for this?
    package {'libdvdread4':
        ensure => installed,
    }
}
