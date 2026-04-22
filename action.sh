#!/system/bin/sh

MODPATH=${0%/*}
EXECUTION_CONTEXT=runtime
REPAIR_TRIGGER="${TRIGGER_REASON:-manual}"
. "$MODPATH/emoji-common.sh"

ensure_public_paths
if ! acquire_run_lock; then
  append_log "INFO: Skipping action run because another repair is already in progress"
  exit 0
fi
trap 'release_run_lock' EXIT

determine_mount_mode
ui_note " __  __ _____ __  __ "
ui_note "|  \\/  |  ___|  \\/  |"
ui_note "| |\\/| | |_  | |\\/| |"
ui_note "|_|  |_|_|   |_|  |_|"
ui_note "   Runtime Repair   "
append_log "INFO: Scheduled repair started (mode=$MODE, root=$ROOT_SOLUTION, mount=$MOUNT_MODE)"
append_log "INFO: Repair trigger: $REPAIR_TRIGGER"
update_public_status "Running repair: trigger=$REPAIR_TRIGGER, root=$ROOT_SOLUTION, mount=$MOUNT_MODE, mode=$MODE"

if snapshot_has_changed; then
  append_log "INFO: Full repair reason: $(repair_reason)"
else
  append_log "INFO: Scheduled repair running without environment change"
fi

run_aggressive_repair
persist_package_snapshot
persist_snapshot

append_log "INFO: Scheduled repair finished"
exit 0
