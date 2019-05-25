#!/bin/bash -e

cd tests/bats
run-parts --regex=[0-9].* .
