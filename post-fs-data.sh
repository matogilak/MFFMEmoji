#!/system/bin/sh

MODPATH=${0%/*}
. "$MODPATH/emoji-common.sh"

ensure_public_paths
determine_mount_mode
ensure_font_payload
restore_saved_data_font_overrides
cleanup_runtime_font_dirs

if diagnostics_enabled; then
  append_log "DEBUG: post-fs-data root=$ROOT_SOLUTION mount=$MOUNT_MODE build=$(getprop ro.build.fingerprint)"
fi

update_public_status "post-fs-data completed: root=$ROOT_SOLUTION, mount=$MOUNT_MODE"

exit 0
