#!/bin/bash
# keep gnome extensions enabled

active_extensions=$(gsettings get org.gnome.shell enabled-extensions)
# 'Move_Clock@rmy.pobox.com',
unity_extensions="'dash-to-dock@micxgx.gmail.com', 'Hide_Activities@shay.shayel.org', 'bettervolume@tudmotu.com', 'nohotcorner@azuri.free.fr', 'impatience@gfxmonk.net', 'suspend-button@laserb', 'TopIcons@phocean.net', 'sound-output-device-chooser@kgshank.net', 'battery-percentage@nohales.org', 'gTile@vibou', 'hibernate-status@dromi'"
if [[ ${#active_extensions} -lt 3 ]]
then
    modified_extensions=${active_extensions}
else
    if echo $active_extensions | grep dash-to-dock -q
    then
        exit 0
    fi
    modified_extensions=$(echo $active_extensions | sed  -e "s/\['/\[${unity_extensions}, '/g")
fi
echo $modified_extensions
gsettings set org.gnome.shell enabled-extensions "${modified_extensions}"
