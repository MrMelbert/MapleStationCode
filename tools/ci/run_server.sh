#!/bin/bash
set -euo pipefail

tools/deploy.sh ci_test
mkdir ci_test/config

#test config
cp tools/ci/ci_config.txt ci_test/config/config.txt

cd ci_test
<<<<<<< HEAD
DreamDaemon jollystation.dmb -close -trusted -verbose -params "log-directory=ci"
=======
DreamDaemon tgstation.dmb -close -trusted -verbose -params "log-directory=ci"
>>>>>>> 5dc6964284984f138b1a3b16af11568d0f42838b
cd ..
cat ci_test/data/logs/ci/clean_run.lk
