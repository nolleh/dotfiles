#!/usr/bin/env bash

export OS=""

if [[ -f /etc/release ]]; then
	RELEASE=$(cat /etc/release)
	if [[ $RELEASE == *"UBUNTU"* ]]; then
		OS="UBUNTU"
	fi
elif [[ -n "$(which system_profiler)" ]]; then
	OS="MAC"
else
	OS="UNNOWN"
fi
