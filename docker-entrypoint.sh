#!/bin/bash
set -e

rm -f /wan_family/tmp/pids/server.pid.

bundle config --local path vendor/bundle

bundle install -j4

exec $@
