#!/usr/bin/env bash
FILE=$(grep -rl ".only(" $PWD/e2e/ | head -1)
yarn test $FILE --runInBand --verbose