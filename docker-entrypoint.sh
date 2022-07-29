#!/bin/bash
set -e

bundle config --local path vendor/bundle

bundle install -j4

rm -f /wan_family/tmp/pids/server.pid.

exec "$@"
