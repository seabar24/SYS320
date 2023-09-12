#!/bin/bash

#Script that only outputs a single network interface for ip addr

ip -o -4 addr list ens33 | awk -F ' *|/' '{print $4}'
