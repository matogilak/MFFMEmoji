#!/system/bin/sh

MODPATH=${0%/*}
EXECUTION_CONTEXT=uninstall

. "$MODPATH/emoji-common.sh"

ensure_public_paths
append_log "INFO: Module uninstall restore started"
update_public_status "Restoring original data emoji fonts before uninstall"
set_state uninstalling 1

lock_acquired=false
if acquire_run_lock; then
  lock_acquired=true
else
  append_log "WARN: Waiting for active repair to finish before uninstall restore"
  wait_count=0
  while [ "$wait_count" -lt 30 ]; do
    sleep 1
    if acquire_run_lock; then
      lock_acquired=true
      break
    fi
    wait_count=$((wait_count + 1))
  done
fi

if [ "$lock_acquired" = "true" ]; then
  trap 'release_run_lock' EXIT
else
  append_log "WARN: Continuing uninstall restore without repair lock"
fi

restore_data_font_backups

update_public_status "Uninstall restore completed"
append_log "INFO: Module uninstall restore finished"

exit 0
