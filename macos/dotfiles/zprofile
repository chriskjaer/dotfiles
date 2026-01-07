# Ensure asdf is available in login shells (e.g., Cursor terminal).
# Guard with ASDF_DIR so re-sourcing is skipped if zshenv already handled it.
if [ -z "${ASDF_DIR:-}" ] && [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi
