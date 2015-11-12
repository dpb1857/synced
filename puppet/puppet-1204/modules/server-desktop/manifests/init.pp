
class server-desktop {

    package {'gdm':
        ensure =>installed,
    }

    package {'fast-user-switch-applet':
        ensure =>installed,
    }

    package {'gnome-core':
        ensure =>installed,
    }

    package {'gnome-themes-ubuntu':
        ensure =>installed,
    }

    package {'gnome-utils':
        ensure =>installed,
    }

    package {'human-theme':
        ensure =>installed,
    }

    package {'jockey-gtk':
        ensure =>installed,
    }

    package {'network-manager-gnome':
        ensure =>installed,
    }

    package {'tangerine-icon-theme':
        ensure =>installed,
    }

    package {'ttf-ubuntu-font-family':
        ensure =>installed,
    }

    package {'ubuntu-artwork':
        ensure =>installed,
    }

    package {'xfwm4':
        ensure =>installed,
    }

    package {'x11-xserver-utils':
        ensure =>installed,
    }
}
