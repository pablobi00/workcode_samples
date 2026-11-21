#!/usr/bin/env bash

# DISCLAIMER - This code is for test purposes only - DO NOT use in production.
#
# setup-rustfs.sh - Lab setup for RustFS (S3-compatible) on Ubuntu
#   - Installs Docker
#   - Runs RustFS in a container (S3 API + web console)
#   - Installs AWS CLI v2 (official installer)
#   - Configures an AWS CLI profile with the RustFS keys
#   - Creates a versioned test bucket (needed for replication)
#   - Installs Azure CLI from Microsoft's apt repo
#   - Optional sample data for replication tests (--sample-data)
#   - Tests: --test (round-trip), --verify-samples, --bench
#   - Also: --status, --uninstall [--purge], --show-config, --log
#
# Quick start:
#   sudo ./setup-rustfs.sh -p 'MySecret!' --dry-run
#   sudo ./setup-rustfs.sh -p 'MySecret!'
#   ./setup-rustfs.sh --help

set -euo pipefail

VERSION="1.4.0"

# ---------- Defaults ----------
ACCESS_KEY="rustfs"
SECRET_KEY="${RUSTFS_SECRET:-}"
SECRET_FILE=""
PROFILE="rustfs"
REGION="us-east-1"
BUCKET="demo"
CONTAINER="rustfs"
IMAGE="rustfs/rustfs:latest"
DATA_DIR="/opt/rustfs/data"
S3_PORT="9000"
CONSOLE_PORT="9001"
CONSOLE="yes"
RESET_DATA="no"
INSTALL_DOCKER="yes"
INSTALL_AWS="yes"
INSTALL_AZ="yes"
CREATE_BUCKET="yes"
DRY_RUN="no"
ASSUME_YES="no"
ACTION="install"       # install | status | uninstall
PURGE="no"
VERSIONING="yes"
SAMPLE_COUNT="0"
SAMPLE_SIZE_KB="64"
LOG_FILE=""
QUIET="no"
SHOW_CONFIG="no"
LOG_DIR=""
VERBOSE="no"
COLOR="yes"
LOG_LINES=""
TEST_AFTER="no"
BENCH_FILES="10"
BENCH_SIZE_MB="8"

usage() {
  cat <<EOF
setup-rustfs.sh v${VERSION}
Usage: sudo $(basename "$0") [action] [options]

Actions (default: install):
      --status              Show container, endpoints, buckets and CLI versions
      --uninstall           Remove the RustFS container and AWS profile
      --purge               With --uninstall: also delete the data directory
      --logs [N]            Show the last N lines of RustFS container logs (default 50)

Tests (run against an existing install; sudo not required):
      --test                Round-trip test: put -> list -> get -> checksum -> delete
      --verify-samples      Download s3://<bucket>/sample/ and check manifest.sha256
                            (run on VM2 to prove replicated data is identical)
      --bench               Simple upload/download throughput test
      --bench-files N       Files for --bench (default: ${BENCH_FILES})
      --bench-size MB       Size of each --bench file in MB (default: ${BENCH_SIZE_MB})
      --test-after          With install: run --test when setup finishes

Credentials:
  -p, --password SECRET     RustFS secret key (min 8 chars). Use SINGLE quotes:
                            -p '!P!assword'
      --secret-file PATH    Read the secret from a file (keeps it out of history)
  -k, --access-key KEY      Access key                  (default: ${ACCESS_KEY})
                            If no secret is given: env RUSTFS_SECRET, else prompt.

RustFS / container:
      --image IMAGE         Container image             (default: ${IMAGE})
      --container NAME      Container name              (default: ${CONTAINER})
      --data-dir PATH       Data directory              (default: ${DATA_DIR})
      --s3-port PORT        Host port for S3 API        (default: ${S3_PORT})
      --console-port PORT   Host port for web console   (default: ${CONSOLE_PORT})
      --no-console          Disable the web console
      --reset-data          WIPE the data dir before starting (lab only!)

AWS CLI / bucket:
      --profile NAME        AWS CLI profile             (default: ${PROFILE})
      --region REGION       Profile region              (default: ${REGION})
  -b, --bucket NAME         Test bucket (versioned)     (default: ${BUCKET})
      --no-bucket           Don't create a test bucket
      --no-versioning       Don't enable versioning on the bucket
      --sample-data N       Upload N random test files to the bucket
      --sample-size KB      Size of each sample file in KB (default: ${SAMPLE_SIZE_KB})

Skip installs:
      --skip-docker         Don't install Docker (already present)
      --skip-aws            Don't install AWS CLI
      --no-az               Don't install Azure CLI

General:
  -n, --dry-run             Print actions without changing anything
  -y, --yes                 Don't ask for confirmation (--reset-data, --purge)
      --show-config         Print the resolved settings and exit
Logging:
  -l, --log FILE            Also write all output to FILE (appends)
      --log-dir DIR         Write to DIR/setup-rustfs-<action>-<timestamp>.log
  -q, --quiet               Only show warnings, errors and the summary
  -V, --verbose             Print every command before it runs (secret masked)
      --no-color            Plain output (auto when not a terminal or NO_COLOR set)
  -v, --version             Show script version
  -h, --help                Show this help

Examples:
  sudo $(basename "$0") -p 'S3cret!123' --no-az                 # VM2, S3 only
  sudo $(basename "$0") --secret-file ~/.rustfs_secret -b logs  # secret from file
  sudo $(basename "$0") -p 'S3cret!123' --s3-port 9100 --console-port 9101
  sudo $(basename "$0") -p 'S3cret!123' --log /tmp/rustfs.log -q
  sudo $(basename "$0") -p 'S3cret!123' --sample-data 50 --sample-size 128
  sudo $(basename "$0") --status
  $(basename "$0") --test -b demo
  $(basename "$0") --verify-samples -b demo          # on VM2 after replication
  $(basename "$0") --bench --bench-files 20 --bench-size 16 --log-dir ~/rustfs-logs
  sudo $(basename "$0") --logs 100
  sudo $(basename "$0") --uninstall --purge -y
EOF
}

C_G=$'\e[1;32m'; C_Y=$'\e[1;33m'; C_R=$'\e[1;31m'; C_B=$'\e[1;36m'; C_0=$'\e[0m'
ts()   { date '+%H:%M:%S'; }
log()  { [[ "${QUIET:-no}" == "yes" ]] || echo "${C_G}[+]${C_0} $(ts) $*"; }
warn() { echo "${C_Y}[!]${C_0} $(ts) $*"; }
die()  { echo "${C_R}[x]${C_0} $(ts) $*" >&2; exit 1; }
pass() { echo "${C_G}[PASS]${C_0} $*"; }
fail() { echo "${C_R}[FAIL]${C_0} $*"; FAILS=$((FAILS+1)); }
FAILS=0

# ---------- Parse arguments ----------
looks_like_flag() { [[ "$1" =~ ^-[a-z]$ || "$1" =~ ^--[a-z][a-z0-9-]*$ ]]; }
need_val() { [[ -n "${2:-}" ]] && ! looks_like_flag "$2" || die "Option $1 needs a value (see --help)"; }
while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--password)    need_val "$1" "${2:-}"; SECRET_KEY="$2";   shift 2 ;;
    --secret-file)    need_val "$1" "${2:-}"; SECRET_FILE="$2";  shift 2 ;;
    -k|--access-key)  need_val "$1" "${2:-}"; ACCESS_KEY="$2";   shift 2 ;;
    --image)          need_val "$1" "${2:-}"; IMAGE="$2";        shift 2 ;;
    --container)      need_val "$1" "${2:-}"; CONTAINER="$2";    shift 2 ;;
    --data-dir)       need_val "$1" "${2:-}"; DATA_DIR="$2";     shift 2 ;;
    --s3-port)        need_val "$1" "${2:-}"; S3_PORT="$2";      shift 2 ;;
    --console-port)   need_val "$1" "${2:-}"; CONSOLE_PORT="$2"; shift 2 ;;
    --profile)        need_val "$1" "${2:-}"; PROFILE="$2";      shift 2 ;;
    --region)         need_val "$1" "${2:-}"; REGION="$2";       shift 2 ;;
    -b|--bucket)      need_val "$1" "${2:-}"; BUCKET="$2";       shift 2 ;;
    --sample-data)    need_val "$1" "${2:-}"; SAMPLE_COUNT="$2"; shift 2 ;;
    --sample-size)    need_val "$1" "${2:-}"; SAMPLE_SIZE_KB="$2"; shift 2 ;;
    -l|--log)         need_val "$1" "${2:-}"; LOG_FILE="$2";     shift 2 ;;
    --no-versioning)  VERSIONING="no";     shift ;;
    --show-config)    SHOW_CONFIG="yes";   shift ;;
    -q|--quiet)       QUIET="yes";         shift ;;
    --no-console)     CONSOLE="no";        shift ;;
    --reset-data)     RESET_DATA="yes";    shift ;;
    --no-bucket)      CREATE_BUCKET="no";  shift ;;
    --skip-docker)    INSTALL_DOCKER="no"; shift ;;
    --skip-aws)       INSTALL_AWS="no";    shift ;;
    --no-az)          INSTALL_AZ="no";     shift ;;
    --status)         ACTION="status";     shift ;;
    --test)           ACTION="test";       shift ;;
    --verify-samples) ACTION="verify";     shift ;;
    --bench)          ACTION="bench";      shift ;;
    --logs)           ACTION="logs"
                      if [[ "${2:-}" =~ ^[0-9]+$ ]]; then LOG_LINES="$2"; shift 2; else LOG_LINES="50"; shift; fi ;;
    --bench-files)    need_val "$1" "${2:-}"; BENCH_FILES="$2";   shift 2 ;;
    --bench-size)     need_val "$1" "${2:-}"; BENCH_SIZE_MB="$2"; shift 2 ;;
    --test-after)     TEST_AFTER="yes";    shift ;;
    --log-dir)        need_val "$1" "${2:-}"; LOG_DIR="$2";      shift 2 ;;
    -V|--verbose)     VERBOSE="yes";       shift ;;
    --no-color)       COLOR="no";          shift ;;
    --uninstall)      ACTION="uninstall";  shift ;;
    --purge)          PURGE="yes";         shift ;;
    -n|--dry-run)     DRY_RUN="yes";       shift ;;
    -y|--yes)         ASSUME_YES="yes";    shift ;;
    -v|--version)     echo "setup-rustfs.sh v${VERSION}"; exit 0 ;;
    -h|--help)        usage; exit 0 ;;
    *) usage; die "Unknown option: $1" ;;
  esac
done

# Colors off when asked, when NO_COLOR is set, or when output is not a terminal/log
if [[ "$COLOR" == "no" || -n "${NO_COLOR:-}" || ! -t 1 || -n "$LOG_FILE$LOG_DIR" ]]; then
  C_G=""; C_Y=""; C_R=""; C_B=""; C_0=""
fi

# ---------- Validation ----------
valid_port() { [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 1 && $1 <= 65535 )); }
valid_port "$S3_PORT"      || die "Invalid --s3-port: $S3_PORT"
valid_port "$CONSOLE_PORT" || die "Invalid --console-port: $CONSOLE_PORT"
[[ "$S3_PORT" != "$CONSOLE_PORT" ]] || die "--s3-port and --console-port must differ"
[[ "$BUCKET" =~ ^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$ ]] || die "Invalid bucket name '$BUCKET' (3-63 chars, lowercase, digits, . -)"
[[ "$PURGE" == "no" || "$ACTION" == "uninstall" ]] || die "--purge only works with --uninstall"
[[ "$SAMPLE_COUNT" =~ ^[0-9]+$ ]] || die "Invalid --sample-data: $SAMPLE_COUNT"
[[ "$SAMPLE_SIZE_KB" =~ ^[0-9]+$ && "$SAMPLE_SIZE_KB" -ge 1 ]] || die "Invalid --sample-size: $SAMPLE_SIZE_KB"
[[ "$SAMPLE_COUNT" == "0" || "$CREATE_BUCKET" == "yes" ]] || die "--sample-data needs a bucket (remove --no-bucket)"

[[ "$BENCH_FILES" =~ ^[0-9]+$ && "$BENCH_FILES" -ge 1 ]] || die "Invalid --bench-files: $BENCH_FILES"
[[ "$BENCH_SIZE_MB" =~ ^[0-9]+$ && "$BENCH_SIZE_MB" -ge 1 ]] || die "Invalid --bench-size: $BENCH_SIZE_MB"
[[ "$TEST_AFTER" == "no" || "$ACTION" == "install" ]] || die "--test-after only works with install"
[[ -z "$LOG_FILE" || -z "$LOG_DIR" ]] || die "Use either --log or --log-dir, not both"


# Log file: copy all output there too
if [[ -n "$LOG_DIR" ]]; then
  mkdir -p "$LOG_DIR" 2>/dev/null || die "Cannot create log dir: $LOG_DIR"
  LOG_FILE="${LOG_DIR%/}/setup-rustfs-${ACTION}-$(date +%Y%m%d-%H%M%S).log"
fi
if [[ -n "$LOG_FILE" ]]; then
  touch "$LOG_FILE" 2>/dev/null || die "Cannot write log file: $LOG_FILE"
  chmod 600 "$LOG_FILE" 2>/dev/null || true
  exec > >(tee -a "$LOG_FILE") 2>&1
  echo "=== setup-rustfs.sh v${VERSION} action=${ACTION} host=$(hostname) $(date -Is) ==="
fi

if [[ "$SHOW_CONFIG" == "yes" ]]; then
  cat <<EOF
setup-rustfs.sh v${VERSION} - resolved settings
  action        : ${ACTION}
  access key    : ${ACCESS_KEY}
  secret        : $([[ -n "$SECRET_KEY" || -n "$SECRET_FILE" ]] && echo "******** (provided)" || echo "(will prompt)")
  image / name  : ${IMAGE} / ${CONTAINER}
  data dir      : ${DATA_DIR}  (reset: ${RESET_DATA})
  ports         : ${S3_PORT} (S3), ${CONSOLE_PORT} (console: ${CONSOLE})
  aws profile   : ${PROFILE} / ${REGION}
  bucket        : $([[ $CREATE_BUCKET == yes ]] && echo "${BUCKET} (versioning: ${VERSIONING})" || echo none)
  sample data   : ${SAMPLE_COUNT} files x ${SAMPLE_SIZE_KB} KB
  installs      : docker=${INSTALL_DOCKER} aws=${INSTALL_AWS} az=${INSTALL_AZ}
  log file      : ${LOG_FILE:-none}
  verbose/color : ${VERBOSE} / ${COLOR}
  bench         : ${BENCH_FILES} files x ${BENCH_SIZE_MB} MB   (test after install: ${TEST_AFTER})
EOF
  exit 0
fi

if [[ "$DRY_RUN" != "yes" && "$ACTION" =~ ^(install|uninstall)$ && $EUID -ne 0 ]]; then
  die "Run with sudo: sudo $0 ... (or add --dry-run to preview)"
fi

confirm() {   # confirm "question" -> returns 0 if yes
  [[ "$ASSUME_YES" == "yes" || "$DRY_RUN" == "yes" ]] && return 0
  [[ -t 0 ]] || die "$1 - needs confirmation; re-run with -y"
  read -rp "$1 [y/N] " a; [[ "$a" =~ ^[Yy]$ ]]
}

# ---------- Dry-run helpers ----------
mask() { local s="$*"; [[ -n "$SECRET_KEY" ]] && s="${s//"$SECRET_KEY"/********}"; echo "$s"; }
vlog()   { [[ "$VERBOSE" == "yes" ]] && echo "${C_B}  \$${C_0} $(mask "$*")"; return 0; }
run()    { if [[ "$DRY_RUN" == "yes" ]]; then echo "  [dry-run] $(mask "$*")"; else vlog "$*"; "$@"; fi; }
run_sh() { if [[ "$DRY_RUN" == "yes" ]]; then echo "  [dry-run] $(mask "$1")"; else vlog "$1"; bash -c "$1"; fi; }

TARGET_USER="${SUDO_USER:-$(id -un)}"
TARGET_HOME="$(getent passwd "$TARGET_USER" | cut -d: -f6)"
run_as_user() { run sudo -u "$TARGET_USER" -H "$@"; }
ENDPOINT="http://localhost:${S3_PORT}"
AWSCMD=(aws --profile "$PROFILE" --endpoint-url "$ENDPOINT")
have() { command -v "$1" >/dev/null 2>&1; }
container_exists() { have docker && docker ps -a --format '{{.Names}}' 2>/dev/null | grep -qx "$CONTAINER"; }

# aws as the profile owner (works with or without sudo)
uaws() {
  if [[ $EUID -eq 0 && "$TARGET_USER" != "root" ]]; then sudo -u "$TARGET_USER" -H "${AWSCMD[@]}" "$@"
  else "${AWSCMD[@]}" "$@"; fi
}
need_aws() { have aws || die "AWS CLI not installed - run the install first"; }
now_ms() { date +%s%3N; }

# Round-trip test: put -> list -> get -> checksum -> delete
do_test() {
  need_aws
  log "Round-trip test against ${ENDPOINT} (bucket ${BUCKET}, profile ${PROFILE})"
  local T key sum_in sum_out t0
  T="$(mktemp -d)"; chmod 755 "$T"; key="_selftest/rt-$(date +%s)-$$.bin"
  head -c 1048576 /dev/urandom > "$T/in.bin"; chmod 644 "$T/in.bin"
  sum_in="$(sha256sum "$T/in.bin" | cut -d' ' -f1)"

  t0=$(now_ms)
  if uaws s3 ls >/dev/null 2>&1; then pass "auth / list buckets ($(( $(now_ms)-t0 )) ms)"; else fail "auth / list buckets"; rm -rf "$T"; return; fi
  if uaws s3api head-bucket --bucket "$BUCKET" >/dev/null 2>&1; then pass "bucket '${BUCKET}' exists"; else fail "bucket '${BUCKET}' missing"; rm -rf "$T"; return; fi
  local ver; ver="$(uaws s3api get-bucket-versioning --bucket "$BUCKET" --query Status --output text 2>/dev/null || true)"
  [[ "$ver" == "Enabled" ]] && pass "versioning enabled" || warn "versioning is '${ver:-off}' (needed for replication)"
  t0=$(now_ms)
  if uaws s3 cp "$T/in.bin" "s3://${BUCKET}/${key}" --only-show-errors; then pass "upload 1 MB ($(( $(now_ms)-t0 )) ms)"; else fail "upload"; fi
  if uaws s3 ls "s3://${BUCKET}/${key}" >/dev/null 2>&1; then pass "object listed"; else fail "object not listed"; fi
  t0=$(now_ms)
  if uaws s3 cp "s3://${BUCKET}/${key}" "$T/out.bin" --only-show-errors; then pass "download ($(( $(now_ms)-t0 )) ms)"; else fail "download"; fi
  sum_out="$(sha256sum "$T/out.bin" 2>/dev/null | cut -d' ' -f1)"
  [[ "$sum_in" == "$sum_out" ]] && pass "sha256 match" || fail "sha256 mismatch"
  if uaws s3 rm "s3://${BUCKET}/${key}" --only-show-errors; then pass "delete"; else fail "delete"; fi
  rm -rf "$T"
}

# Verify replicated / uploaded samples against manifest.sha256
do_verify() {
  need_aws
  log "Verifying s3://${BUCKET}/sample/ on ${ENDPOINT}"
  local T; T="$(mktemp -d)"; chmod 777 "$T"
  uaws s3 cp "s3://${BUCKET}/sample/" "$T/" --recursive --only-show-errors || { fail "download of sample/ failed"; rm -rf "$T"; return; }
  [[ -f "$T/manifest.sha256" ]] || { fail "manifest.sha256 not found in s3://${BUCKET}/sample/"; rm -rf "$T"; return; }
  local expected got bad
  expected=$(wc -l < "$T/manifest.sha256"); got=$(ls "$T"/sample-*.bin 2>/dev/null | wc -l)
  [[ "$expected" -eq "$got" ]] && pass "file count ${got}/${expected}" || fail "file count ${got}/${expected}"
  bad=$(cd "$T" && sha256sum -c manifest.sha256 --quiet 2>&1 | grep -c FAILED || true)
  [[ "$bad" -eq 0 ]] && pass "all checksums match" || { fail "${bad} file(s) with checksum mismatch"; (cd "$T" && sha256sum -c manifest.sha256 --quiet 2>&1 | sed 's/^/    /'); }
  rm -rf "$T"
}

# Simple throughput test
do_bench() {
  need_aws
  local total=$((BENCH_FILES * BENCH_SIZE_MB)) T t0 up dn prefix
  log "Benchmark: ${BENCH_FILES} x ${BENCH_SIZE_MB} MB = ${total} MB -> s3://${BUCKET}/_bench/"
  T="$(mktemp -d)"; chmod 777 "$T"; mkdir -p "$T/up" "$T/down"; chmod 777 "$T/up" "$T/down"
  for n in $(seq -w 1 "$BENCH_FILES"); do head -c "$((BENCH_SIZE_MB*1048576))" /dev/urandom > "$T/up/b-$n.bin"; done
  chmod 644 "$T"/up/*; prefix="_bench/$(date +%s)-$$"
  t0=$(now_ms); uaws s3 cp "$T/up/" "s3://${BUCKET}/${prefix}/" --recursive --only-show-errors || { fail "bench upload"; rm -rf "$T"; return; }
  up=$(( $(now_ms)-t0 ))
  t0=$(now_ms); uaws s3 cp "s3://${BUCKET}/${prefix}/" "$T/down/" --recursive --only-show-errors || { fail "bench download"; rm -rf "$T"; return; }
  dn=$(( $(now_ms)-t0 ))
  uaws s3 rm "s3://${BUCKET}/${prefix}/" --recursive --only-show-errors || warn "cleanup of ${prefix} failed"
  awk -v mb="$total" -v u="$up" -v d="$dn" 'BEGIN{
    printf "  Upload  : %6.1f MB/s  (%.2f s)\n", mb/(u/1000), u/1000;
    printf "  Download: %6.1f MB/s  (%.2f s)\n", mb/(d/1000), d/1000 }'
  pass "benchmark complete (test objects removed)"
  rm -rf "$T"
}

test_summary() {
  if [[ $FAILS -eq 0 ]]; then log "All checks passed${LOG_FILE:+ - log: $LOG_FILE}"; exit 0
  else echo "${C_R}[x]${C_0} ${FAILS} check(s) failed${LOG_FILE:+ - log: $LOG_FILE}"; exit 1; fi
}

# ======================= ACTION: test / verify / bench / logs =======================
case "$ACTION" in
  test)   [[ "$DRY_RUN" == "yes" ]] && { echo "  [dry-run] round-trip test on s3://${BUCKET}"; exit 0; }; do_test;   test_summary ;;
  verify) [[ "$DRY_RUN" == "yes" ]] && { echo "  [dry-run] verify s3://${BUCKET}/sample/"; exit 0; };   do_verify; test_summary ;;
  bench)  [[ "$DRY_RUN" == "yes" ]] && { echo "  [dry-run] bench ${BENCH_FILES}x${BENCH_SIZE_MB}MB on s3://${BUCKET}"; exit 0; }; do_bench; test_summary ;;
  logs)
    container_exists || die "Container '${CONTAINER}' not found (need sudo?)"
    log "Last ${LOG_LINES} log lines of '${CONTAINER}':"
    docker logs --tail "$LOG_LINES" --timestamps "$CONTAINER" 2>&1
    exit 0 ;;
esac

# ======================= ACTION: status =======================
if [[ "$ACTION" == "status" ]]; then
  log "RustFS status (container '${CONTAINER}')"
  if container_exists; then
    docker ps -a --filter "name=^${CONTAINER}$" --format '  {{.Names}}  {{.Status}}  {{.Image}}  {{.Ports}}'
  else
    warn "Container '${CONTAINER}' not found"
  fi
  if curl -s -o /dev/null "$ENDPOINT"; then log "S3 endpoint reachable: $ENDPOINT"; else warn "S3 endpoint NOT reachable: $ENDPOINT"; fi
  if have aws; then
    log "AWS CLI: $(aws --version 2>&1)"
    log "Buckets (profile ${PROFILE}):"
    "${AWSCMD[@]}" s3 ls 2>&1 | sed 's/^/  /' || true
  else
    warn "AWS CLI not installed"
  fi
  have az && log "Azure CLI: $(az version --query '"azure-cli"' -o tsv 2>/dev/null)" || warn "Azure CLI not installed"
  exit 0
fi

# ======================= ACTION: uninstall =======================
if [[ "$ACTION" == "uninstall" ]]; then
  [[ "$DRY_RUN" == "yes" ]] && warn "DRY RUN - nothing will be changed"
  if container_exists || [[ "$DRY_RUN" == "yes" ]]; then
    log "Removing container '${CONTAINER}'..."
    run docker rm -f "$CONTAINER"
  else
    warn "Container '${CONTAINER}' not found"
  fi
  if [[ -f "${TARGET_HOME}/.aws/credentials" ]] && grep -q "^\[${PROFILE}\]" "${TARGET_HOME}/.aws/credentials"; then
    log "Removing AWS profile '${PROFILE}'..."
    run sed -i "/^\[${PROFILE}\]/,/^\[/{/^\[${PROFILE}\]/d;/^\[/!d}" "${TARGET_HOME}/.aws/credentials"
    [[ -f "${TARGET_HOME}/.aws/config" ]] && \
      run sed -i "/^\[profile ${PROFILE}\]/,/^\[/{/^\[profile ${PROFILE}\]/d;/^\[/!d}" "${TARGET_HOME}/.aws/config"
  fi
  if [[ "$PURGE" == "yes" ]]; then
    if confirm "Delete ALL data in ${DATA_DIR}?"; then
      log "Purging ${DATA_DIR}..."
      run rm -rf "${DATA_DIR:?}"
    else
      warn "Purge skipped"
    fi
  fi
  log "Uninstall done (Docker, AWS CLI and Azure CLI left installed)."
  exit 0
fi

# ======================= ACTION: install =======================
# Secret: -p > --secret-file > RUSTFS_SECRET env > prompt
if [[ -n "$SECRET_FILE" ]]; then
  [[ -n "$SECRET_KEY" ]] && warn "Both -p and --secret-file given - using --secret-file"
  [[ -r "$SECRET_FILE" ]] || die "Cannot read secret file: $SECRET_FILE"
  SECRET_KEY="$(head -n1 "$SECRET_FILE" | tr -d '\r\n')"
fi
if [[ -z "$SECRET_KEY" ]]; then
  [[ -t 0 ]] || die "No secret given. Use -p 'SECRET', --secret-file or RUSTFS_SECRET"
  read -rsp "RustFS secret key: " SECRET_KEY; echo
  read -rsp "Confirm secret key: " s2; echo
  [[ "$SECRET_KEY" == "$s2" ]] || die "Secrets do not match"
fi
[[ ${#SECRET_KEY} -ge 8 ]] || die "Secret key must be at least 8 characters"
[[ ${#ACCESS_KEY} -ge 3 ]] || die "Access key must be at least 3 characters"

[[ "$DRY_RUN" == "yes" ]] && warn "DRY RUN - nothing will be changed"
log "Settings: key=${ACCESS_KEY} secret=******** bucket=${BUCKET} profile=${PROFILE}/${REGION} user=${TARGET_USER}"
log "          ports s3=${S3_PORT} console=${CONSOLE_PORT}(${CONSOLE}) data=${DATA_DIR} docker=${INSTALL_DOCKER} aws=${INSTALL_AWS} az=${INSTALL_AZ}"

# ---------- 1. Base packages + Docker ----------
export DEBIAN_FRONTEND=noninteractive
log "Installing prerequisites..."
run apt-get update -y
run apt-get install -y ca-certificates curl unzip
if [[ "$INSTALL_DOCKER" == "yes" ]]; then
  log "Installing Docker..."
  run apt-get install -y docker.io
  run systemctl enable --now docker
else
  have docker || [[ "$DRY_RUN" == "yes" ]] || die "--skip-docker given but docker is not installed"
fi

# ---------- 2. RustFS container ----------
log "Preparing data dir ${DATA_DIR}..."
run mkdir -p "$DATA_DIR"
if [[ "$RESET_DATA" == "yes" ]]; then
  if confirm "WIPE all data in ${DATA_DIR}?"; then
    warn "Wiping ${DATA_DIR}"
    run_sh "rm -rf '${DATA_DIR:?}'/*"
  else
    die "Aborted by user"
  fi
fi
run chown -R 10001:10001 "$DATA_DIR"   # RustFS container runs as UID 10001

if container_exists; then
  warn "Container '${CONTAINER}' exists -> recreating it (data is kept)"
  run docker rm -f "$CONTAINER"
fi

DOCKER_ARGS=(-d --name "$CONTAINER" --restart unless-stopped
  -p "${S3_PORT}:9000" -p "${CONSOLE_PORT}:9001"
  -v "${DATA_DIR}:/data"
  -e "RUSTFS_ACCESS_KEY=${ACCESS_KEY}"
  -e "RUSTFS_SECRET_KEY=${SECRET_KEY}"
  -e "RUSTFS_CONSOLE_ENABLE=$([[ $CONSOLE == yes ]] && echo true || echo false)")

log "Starting RustFS (${IMAGE})..."
run docker run "${DOCKER_ARGS[@]}" "$IMAGE"

if [[ "$DRY_RUN" != "yes" ]]; then
  got_ak="$(docker inspect "$CONTAINER" --format '{{range .Config.Env}}{{println .}}{{end}}' | sed -n 's/^RUSTFS_ACCESS_KEY=//p')"
  [[ "$got_ak" == "$ACCESS_KEY" ]] || die "Container access key mismatch (got '${got_ak}')"
  log "Waiting for S3 endpoint on ${ENDPOINT}..."
  for i in {1..30}; do
    curl -s -o /dev/null "$ENDPOINT" && break
    sleep 2
    [[ $i -eq 30 ]] && { docker logs --tail 40 "$CONTAINER"; die "RustFS did not come up"; }
  done
fi

# ---------- 3. AWS CLI v2 ----------
if [[ "$INSTALL_AWS" == "yes" ]]; then
  if have aws; then
    log "AWS CLI already installed: $(aws --version 2>&1)"
  else
    log "Installing AWS CLI v2..."
    case "$(uname -m)" in
      x86_64|aarch64) AWS_ARCH="$(uname -m)" ;;
      *) die "Unsupported arch $(uname -m)" ;;
    esac
    run_sh "set -e; T=\$(mktemp -d); \
curl -sSL https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip -o \$T/awscliv2.zip; \
unzip -q \$T/awscliv2.zip -d \$T; \$T/aws/install --update; rm -rf \$T"
  fi
else
  have aws || [[ "$DRY_RUN" == "yes" ]] || die "--skip-aws given but aws is not installed"
fi

# ---------- 3b. Azure CLI ----------
if [[ "$INSTALL_AZ" == "yes" ]]; then
  if have az; then
    log "Azure CLI already installed"
  else
    log "Installing Azure CLI from Microsoft's apt repo..."
    run_sh "curl -sL https://aka.ms/InstallAzureCLIDeb | bash"
  fi
fi

# ---------- 4. AWS CLI profile (for the sudo user) ----------
log "Configuring AWS profile '${PROFILE}' for user ${TARGET_USER}..."
run_as_user aws configure set aws_access_key_id     "$ACCESS_KEY" --profile "$PROFILE"
run_as_user aws configure set aws_secret_access_key "$SECRET_KEY" --profile "$PROFILE"
run_as_user aws configure set region                "$REGION"     --profile "$PROFILE"
run_as_user aws configure set output                json          --profile "$PROFILE"
run chmod 600 "${TARGET_HOME}/.aws/credentials"

# ---------- 5. Smoke test + versioned bucket ----------
if [[ "$DRY_RUN" == "yes" ]]; then
  run_as_user "${AWSCMD[@]}" s3 ls
  if [[ "$CREATE_BUCKET" == "yes" ]]; then
    run_as_user "${AWSCMD[@]}" s3 mb "s3://${BUCKET}"
    [[ "$VERSIONING" == "yes" ]] && run_as_user "${AWSCMD[@]}" s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
    [[ "$SAMPLE_COUNT" -gt 0 ]] && echo "  [dry-run] generate ${SAMPLE_COUNT} x ${SAMPLE_SIZE_KB}KB files + manifest.sha256 -> s3://${BUCKET}/sample/"
  fi
  [[ "$TEST_AFTER" == "yes" ]] && echo "  [dry-run] round-trip test on s3://${BUCKET}"
  log "Dry run complete - re-run without --dry-run to apply."
  exit 0
fi

log "Testing credentials (list buckets)..."
run_as_user "${AWSCMD[@]}" s3 ls >/dev/null || die "Auth failed - check keys / docker logs ${CONTAINER} (try --reset-data on a fresh lab)"

if [[ "$CREATE_BUCKET" == "yes" ]]; then
  if run_as_user "${AWSCMD[@]}" s3api head-bucket --bucket "$BUCKET" 2>/dev/null; then
    log "Bucket '${BUCKET}' already exists"
  else
    log "Creating bucket '${BUCKET}'..."
    run_as_user "${AWSCMD[@]}" s3 mb "s3://${BUCKET}"
  fi
  if [[ "$VERSIONING" == "yes" ]]; then
    run_as_user "${AWSCMD[@]}" s3api put-bucket-versioning \
      --bucket "$BUCKET" --versioning-configuration Status=Enabled
    log "Versioning: $(run_as_user "${AWSCMD[@]}" s3api get-bucket-versioning --bucket "$BUCKET" --query Status --output text)"
  fi

  # ---------- 6. Sample data ----------
  if [[ "$SAMPLE_COUNT" -gt 0 ]]; then
    log "Generating ${SAMPLE_COUNT} sample files (${SAMPLE_SIZE_KB} KB each)..."
    SDIR="$(mktemp -d)"
    for n in $(seq -w 1 "$SAMPLE_COUNT"); do
      head -c "$((SAMPLE_SIZE_KB * 1024))" /dev/urandom > "${SDIR}/sample-${n}.bin"
    done
    (cd "$SDIR" && sha256sum sample-*.bin > manifest.sha256)
    chown -R "$TARGET_USER" "$SDIR"
    run_as_user "${AWSCMD[@]}" s3 cp "$SDIR/" "s3://${BUCKET}/sample/" --recursive --only-show-errors
    log "Uploaded $(run_as_user "${AWSCMD[@]}" s3 ls "s3://${BUCKET}/sample/" | wc -l) objects to s3://${BUCKET}/sample/ (incl. manifest.sha256)"
    rm -rf "$SDIR"
  fi
fi

# ---------- 7. Optional post-install test ----------
if [[ "$TEST_AFTER" == "yes" ]]; then
  do_test
  [[ $FAILS -eq 0 ]] || warn "${FAILS} post-install check(s) failed - see above"
fi

# ---------- Done ----------
IP="$(hostname -I | awk '{print $1}')"
cat <<EOF

========================================================
 RustFS is up
   S3 API  : http://${IP}:${S3_PORT}
   Console : $([[ $CONSOLE == yes ]] && echo "http://${IP}:${CONSOLE_PORT}" || echo "disabled")
   Profile : ${PROFILE} / ${REGION}  (user: ${TARGET_USER})
   Bucket  : $([[ $CREATE_BUCKET == yes ]] && echo "${BUCKET} (versioning: ${VERSIONING})" || echo "none created")
   Samples : $([[ $SAMPLE_COUNT -gt 0 ]] && echo "${SAMPLE_COUNT} files in s3://${BUCKET}/sample/ (verify with manifest.sha256)" || echo "none")

 Quick test:
   export AWS_PROFILE=${PROFILE} AWS_ENDPOINT_URL=${ENDPOINT}
   echo hello > /tmp/t.txt && aws s3 cp /tmp/t.txt s3://${BUCKET}/
   aws s3 ls s3://${BUCKET}/

 Azure CLI : $(have az && echo "installed -> run 'az login --use-device-code'" || echo "not installed")
 Status    : $(basename "$0") --status
 Test      : $(basename "$0") --test -b ${BUCKET}    |  logs: sudo $(basename "$0") --logs${LOG_FILE:+
 Log file  : ${LOG_FILE}}
========================================================
EOF
