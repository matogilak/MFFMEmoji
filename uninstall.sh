#!/system/bin/sh

MODPATH=${0%/*}
EXECUTION_CONTEXT=uninstall

. "$MODPATH/emoji-common.sh"

ensure_public_paths
append_log "INFO: Module uninstall restore started"
update_public_status "Restoring original data emoji fonts before uninstall"

restore_data_font_backups

update_public_status "Uninstall restore completed"
append_log "INFO: Module uninstall restore finished"

exit 0
