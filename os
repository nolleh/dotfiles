#!/usr/bin/env bash

export OS=""

if [[ -f /etc/os-release ]]; then
	RELEASE=$(cat /etc/os-release)
	if [[ $RELEASE^^ == *"UBUNTU"* ]]; then
		OS="UBUNTU"
	fi
elif [[ -n "$(which system_profiler)" ]]; then
	OS="MAC"
else
	OS="UNNOWN"
fi
