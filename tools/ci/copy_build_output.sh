#!/bin/bash

mkdir -p \
    $1/icons \
    $1/tgui/public \

cp maplestation.dmb maplestation.rsc $1/ # NON-MODULE CHANGE
cp -r icons/* $1/icons/
cp -r tgui/public/* $1/tgui/public/
