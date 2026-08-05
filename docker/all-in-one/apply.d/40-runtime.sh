# Render the engine config + pre-create the shared agent volume.
reload_env   # pick up the values just filled in by 20/30

# Render opensandbox.generated.toml (the sandbox network name comes from SANDBOX_DOCKER_NETWORK, same as compose -- single source)
# Migration from older .env templates: OPENSANDBOX_REGISTRY (a registry prefix) was
# replaced by full references; the platform pins patched builds under ghcr.io/teableio.
# The pinned defaults below take over -- warn so the stale key gets cleaned up.
if [ -n "${OPENSANDBOX_REGISTRY:-}" ]; then
  echo "[!] OPENSANDBOX_REGISTRY is retired and ignored; execution-plane images are pinned via"
  echo "    EXECD_IMAGE / EGRESS_IMAGE (defaults applied -- see .env example). Remove the old key from .env."
fi
# apply.sh persists the effective pins into .env, so a plain re-run would keep an
# older release's execution-plane images forever. Retire the previous defaults --
# matched by tag so an official mirror (e.g. the Shenzhen ACR prefix) migrates too
# and keeps its registry, while a custom image name is left alone.
retire_pin() {  # $1=current value, $2=old tags (space separated), $3=new tag, $4=image name
  cur="$1"; new_tag="$3"; name="$4"
  case "${cur}" in */${name}:*) ;; *) printf '%s' "${cur}"; return ;; esac
  cur_tag="${cur##*:}"
  for t in $2; do
    if [ "${cur_tag}" = "${t}" ]; then
      printf '%s' "${cur%:*}:${new_tag}"
      return
    fi
  done
  printf '%s' "${cur}"
}
if [ -n "${EXECD_IMAGE:-}" ]; then
  migrated="$(retire_pin "${EXECD_IMAGE}" "v1.0.19-fix1 v1.0.19-fix2" "v1.0.19-fix3" "opensandbox-execd")"
  [ "${migrated}" = "${EXECD_IMAGE}" ] || echo "[~] EXECD_IMAGE ${EXECD_IMAGE} is superseded; updating .env to ${migrated}"
  EXECD_IMAGE="${migrated}"
fi
if [ -n "${OPENSANDBOX_SERVER_IMAGE:-}" ]; then
  migrated="$(retire_pin "${OPENSANDBOX_SERVER_IMAGE}" "v0.2.0-fix4 v0.2.0-fix5 v0.2.0-fix6 v0.2.0-fix7 v0.2.0-fix8" "v0.2.0-fix9" "opensandbox-server")"
  if [ "${migrated}" != "${OPENSANDBOX_SERVER_IMAGE}" ]; then
    echo "[~] OPENSANDBOX_SERVER_IMAGE ${OPENSANDBOX_SERVER_IMAGE} is superseded; updating .env to ${migrated}"
    set_kv OPENSANDBOX_SERVER_IMAGE "${migrated}" "$ENV_FILE"
  fi
fi
EXECD_IMAGE="${EXECD_IMAGE:-ghcr.io/teableio/opensandbox-execd:v1.0.19-fix3}"
EGRESS_IMAGE="${EGRESS_IMAGE:-ghcr.io/teableio/opensandbox-egress:v1.0.12}"
# Persist the effective pins into .env so the operator sees exactly what runs.
set_kv EXECD_IMAGE "${EXECD_IMAGE}" "$ENV_FILE"
set_kv EGRESS_IMAGE "${EGRESS_IMAGE}" "$ENV_FILE"
SANDBOX_NET="${SANDBOX_DOCKER_NETWORK:-teable-sandbox-net}"

# Private-CA trust for sandboxes (advanced, .env): SANDBOX_CA_CERT_FILE mounts the
# root CA into every sandbox and points NODE_EXTRA_CA_CERTS at it; SANDBOX_TLS_NO_VERIFY=1
# disables Node TLS verification instead (trials only). Both need server >= v0.2.0-fix6.
CA_MOUNT="/etc/ssl/private-ca/root-ca.crt"
CA_BINDS_LINE=""
CA_ENV=""
if [ -n "${SANDBOX_CA_CERT_FILE:-}" ]; then
  [ -f "${SANDBOX_CA_CERT_FILE}" ] || { echo "[x] SANDBOX_CA_CERT_FILE points at a missing file: ${SANDBOX_CA_CERT_FILE}"; exit 1; }
  case "${SANDBOX_CA_CERT_FILE}" in /*) ;; *) echo "[x] SANDBOX_CA_CERT_FILE must be an absolute path"; exit 1 ;; esac
  CA_BINDS_LINE="sandbox_binds = [\"${SANDBOX_CA_CERT_FILE}:${CA_MOUNT}:ro\"]"
  CA_ENV="NODE_EXTRA_CA_CERTS = \"${CA_MOUNT}\""
fi
if [ "${SANDBOX_TLS_NO_VERIFY:-}" = "1" ]; then
  echo "[!] SANDBOX_TLS_NO_VERIFY=1: Node TLS verification is DISABLED inside sandboxes (trials only)."
  CA_ENV="${CA_ENV:+${CA_ENV}, }NODE_TLS_REJECT_UNAUTHORIZED = \"0\""
fi
CA_ENV_LINE=""
[ -n "${CA_ENV}" ] && CA_ENV_LINE="sandbox_env = { ${CA_ENV} }"
render_toml "${EXECD_IMAGE}" "${EGRESS_IMAGE}" "${SANDBOX_NET}" "${CA_BINDS_LINE}" "${CA_ENV_LINE}"

# Pre-create the shared agent workspace volume (declared external in compose; idempotent)
if command -v docker >/dev/null 2>&1; then
  docker volume create teable-agent-juicefs >/dev/null 2>&1 || true
else
  echo "[!] docker not detected; before up, run docker volume create teable-agent-juicefs by hand."
fi
