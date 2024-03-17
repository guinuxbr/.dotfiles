#!/bin/sh
export SSH_ASKPASS='/usr/libexec/ssh/ksshaskpass'
[ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)"
