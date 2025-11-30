#!/bin/sh -e

cp redbean.com webxdc-standalone.com
zip --recurse-paths -9 webxdc-standalone.com * .init.lua

