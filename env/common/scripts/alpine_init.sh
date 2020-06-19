#!/bin/sh

# Update apk repositories
apk --no-cache update

# Add helper utilities to alpine
apk add --no-cache \
    bash bash-doc bash-completion binutils coreutils findutils grep nano pciutils shadow usbutils util-linux

# Initialise the base profile
rm -f /etc/profile
cat >/etc/profile <<'EOL'
export CHARSET=UTF-8
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
export PAGER=less
export PS1='\h:\w\$ '
umask 022
for script in /etc/profile.d/*.sh ; do
    if [ -r $script ] ; then
        . $script
    fi
done
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi
EOL

# Initialise .bashrc
rm -f /root/.bashrc
cat >/root/.bashrc <<'EOL'
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize
COLOUR_GREEN="\[\e[0;92m\]"
COLOUR_GREY="\[\e[0;37m\]"
COLOUR_RED="\[\e[0;91m\]"
COLOUR_WHITE="\[\e[0m\]"
if test "$UID" -eq 0 ; then
    COLOUR_USER=$COLOUR_RED
else
    COLOUR_USER=$COLOUR_GREEN
fi
export PS1="${COLOUR_GREY}[${COLOUR_USER}\u${COLOUR_GREY}@\h:\w]\\$ ${COLOUR_WHITE}"
export PS2="${COLOUR_GREY}> ${COLOUR_WHITE}"
EOL

# Set root shell to use bash by default
usermod --shell /bin/bash root
