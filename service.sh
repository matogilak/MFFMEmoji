#!/system/bin/sh

MODPATH=${0%/*}
ACTION_SCRIPT="$MODPATH/action.sh"
INTERVAL_HOURS=1
INTERVAL_SECONDS=$((INTERVAL_HOURS * 3600))
CHECK_INTERVAL_SECONDS=300
BOOT_BURST_RUNS=5
BOOT_BURST_INTERVAL_SECONDS=60

. "$MODPATH/emoji-common.sh"

log() {
  append_log "INFO: $1"
}

run_action() {
  local trigger_reason="$1"

  log "Triggering repair (reason=$trigger_reason)"
  TRIGGER_REASON="$trigger_reason" sh "$ACTION_SCRIPT"
  LAST_ACTION_EPOCH="$(date +%s)"
}

while [ "$(getprop sys.boot_completed)" != "1" ]; do
  sleep 5
done

while [ ! -d /sdcard ]; do
  sleep 5
done

[ -f "$ACTION_SCRIPT" ] || {
  log "Missing action script: $ACTION_SCRIPT"
  exit 1
}

chmod 0755 "$ACTION_SCRIPT" 2>/dev/null
ensure_public_paths
log "Scheduler started (interval=${INTERVAL_HOURS}h, boot_burst=${BOOT_BURST_RUNS}x${BOOT_BURST_INTERVAL_SECONDS}s, package_check=${CHECK_INTERVAL_SECONDS}s)"

LAST_ACTION_EPOCH=0
burst_run=1
while [ "$burst_run" -le "$BOOT_BURST_RUNS" ]; do
  run_action "boot-burst-$burst_run"
  [ "$burst_run" -lt "$BOOT_BURST_RUNS" ] && sleep "$BOOT_BURST_INTERVAL_SECONDS"
  burst_run=$((burst_run + 1))
done

while true; do
  current_epoch=0
  sleep "$CHECK_INTERVAL_SECONDS"
  current_epoch="$(date +%s)"

  if packages_have_changed; then
    log "Touched package update detected; running repair"
    run_action "package-update"
    continue
  fi

  if [ $((current_epoch - LAST_ACTION_EPOCH)) -ge "$INTERVAL_SECONDS" ]; then
    run_action "hourly"
  fi
done
