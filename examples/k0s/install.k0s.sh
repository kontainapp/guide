#!/bin/sh

set -e

K0S_VERSION=${K0S_VERSION:-"v1.22.2+k0s.1"}

if [ ! -z "${DEBUG}" ]; then
  set -x
fi

_detect_arch() {
  case $(uname -m) in
    amd64|x86_64) echo "amd64" ;;
    arm64|aarch64) echo "arm64" ;;
    armv7l|armv8l|arm) echo "arm" ;;
    *) echo "Unsupported processor architecture"; return 1 ;;
  esac
}

_download_url() {
  local arch="$(_detect_arch)"

  echo "https://github.com/k0sproject/k0s/releases/download/$K0S_VERSION/k0s-$K0S_VERSION-$arch"
}


echo "Downloading k0s from URL: $(_download_url)"

curl -sSLf $(_download_url) > /usr/local/bin/k0s
chmod 755 /usr/local/bin/k0s

echo "k0s is now executable in /usr/local/bin"