#!/bin/sh
if tmux ls &>/dev/null
then
    tmux attach
else
    tmux
fi
