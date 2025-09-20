#!/bin/sh

# Check what is the OS
OSNAME=$(hostnamectl | grep "Operating System" | cut -d" " -f3)

# Set SSH_ASKPASS depending on OS
if [ "${OSNAME}" = "openSUSE" ]
then
  export SSH_ASKPASS='/usr/libexec/ssh/ksshaskpass'
elif [ "${OSNAME}" = "Fedora" ] || [ "${OSNAME}" = "Arch" ] || [ "${OSNAME}" = "CachyOS" ]
then
  export SSH_ASKPASS='/usr/bin/ksshaskpass'
fi

# Check if ssh-agent is running. If not, start it.
[ -n "$SSH_AGENT_PID" ] || eval "$(ssh-agent -s)"
