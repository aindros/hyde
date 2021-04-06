#!/bin/sh

if [ -z `which javac` ]; then
    echo "- JDK 8 missing"
    ERROR=1
else
    if [ -z `javac -version 2>&1 | awk '{print $2}' | grep -o "1.8"` ]; then
        echo "- JDK 8 missing"
        ERROR=1
    fi
fi

if [ -z `which mvn` ]; then
    echo "- Maven missing"
    ERROR=1
fi

if [ -z $ERROR ]; then
    echo "Check completed without errors"
fi
