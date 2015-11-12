#!/bin/bash

function setup_system_ui() {
    echo
    echo "***"
    echo "*** Function: setup_system_ui"
    echo "***"
    echo
    echo "Now would be a good time to make the CapsLock to Control..."
    echo "System->Preferences->Keyboard, [Layouts]->Options->CtrlKeyPosition->Make CapsLock an addiitonal Control;"
    echo "(UNITY) search for 'keyboard'";
    echo "I'll take care of this..."
    # Works on Ubuntu 10.04, not on Mint 12;
    set -x 
    gconftool-2 --type list --list-type string --set /desktop/gnome/peripherals/keyboard/kbd/options "[ctrl	ctrl:nocaps]"   
    set +x
    echo "Press <return> to continue"
    read var

    echo "Now, adjust the power settings.  Don't sleep when the lid closes..."
    echo "System->Preferences->PowerManagement; On AC Power/On Battery power, don't sleep when the lid is closed."
    echo "(UNITY) search for 'power'";
    echo "Press <return> to continue"
    read var

    echo "Don't lock the screen when screensaver kick in..."
    echo "System->Preferences->Screensaver[uncheck 'lock screen when screensaver active']"
    echo "(UNITY) search for 'screensaver'";
    echo "Press <return> to continue"
    read var

    echo "Setup some keyboard shortcuts..."
    echo "System->Preferences->KeyboardShortcuts - "
    echo "  Launch web browser: c-m-w"
    echo "  Launch shell window: c-m-s"
    echo "(UNITY) search for 'keyboard'";
    echo "Press <return> to continue"
    read var

    echo "Setup keyboard shortcuts"
    echo "Define a custom keyboard short"
    echo '  Command: sh -c "cd $HOME && emacs -geometry =80×50"'
    echo "  bind emacs to c-m-x"
    echo "Press <return> to continue"
    read var

    echo "Add /usr/bin/gconf-editor to the system->preferences menu."
    echo "Press <return> to continue"
    read var
    
    echo "Move window buttons back to the right (if you want them on the right)"
    echo "gconf-editor:apps/metacity/general/button_layout: just move the colon to the far left"
    # echo "also, reorder to put close on the right;"
    # echo "Press <return> to continue"
    # read var
    echo "I'll take care of that now..."
    set -x
    gconftool-2 --type string --set /apps/metacity/general/button_layout ":minimize,maximize,close"
    set +x
    sleep 1

    echo "Add emacs editing to gnome..."
    set -x
    gconftool-2 --type string --set /desktop/gnome/interface/gtk_key_theme Emacs
    set +x
    sleep 1
}

setup_system_ui

