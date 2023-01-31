#!/usr/bin/env bash

tr -cd '_A-Z-a-z-0-9!@#$%^&*()=+[]{}";:/?.>,<' < /dev/urandom | head -c${1:-64};echo;
