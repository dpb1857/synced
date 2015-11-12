
package {'synaptic':
    ensure => installed,
}

package {'mg':
    ensure => installed,
}


# Installing this package will pull in support for MP3 playback and
# decoding, support for various other audio formats (GStreamer plugins),
# Microsoft fonts, Java runtime environment, Flash plugin, LAME (to
# create compressed audio files), and DVD playback. 
# 
# Please note that this does not install libdvdcss2, and will not let
# you play encrypted DVDs. For more information, see
# https://help.ubuntu.com/community/RestrictedFormats/PlayingDVDs

package {'ubuntu-restricted-extras':
    ensure => installed,
}


class emacs {

    package {'texi2html':
        ensure => installed,
    }

    package {'texinfo':
        ensure => installed,
    }
  
    package {'emacs24':
	ensure => installed,
    }
}

class {'emacs':}
