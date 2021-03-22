# Load GPG for SSH
# Enable gpg-agent if it is not running
set -gx GPG_AGENT_SOCKET {$XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh
if test ! -S $GPG_AGENT_SOCKET
  gpg-agent --daemon >/dev/null 2>&1
end

set -gx GPG_TTY (tty)

# Set SSH to use gpg-agent if it is configured to do so
if set -q GNUPGHOME; or test -z $GNUPGHOME
  set gnupg_config {$HOME}/.gnupg/gpg-agent.conf
else
  set gnupg_config {$GNUPGHOME}/gpg-agent.conf
end

if test -r $gnupg_config; and grep -q enable-ssh-support $gnupg_config
  set --erase SSH_AGENT_PID
  set -gx SSH_AUTH_SOCK $GPG_AGENT_SOCKET
end
