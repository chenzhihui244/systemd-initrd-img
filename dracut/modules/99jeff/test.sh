#!/bin/bash

echo "This is a test service script"
mkdir /tmp/test-pid-$$
exec /bin/sh -i -l
