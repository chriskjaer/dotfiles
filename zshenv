# Ensure asdf is available in all zsh shells (including non-login)
if [ -z "${ASDF_DIR:-}" ] && [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi
