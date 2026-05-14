#!/bin/bash

echo "=== BATTERY STATUS ==="

upower -i $(upower -e | grep BAT) | grep -