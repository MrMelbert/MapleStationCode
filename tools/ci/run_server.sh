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
>>>>>>> 5d2a9dd843807bcad59d4a98be9fffb8992b8854
cd ..
cat ci_test/data/logs/ci/clean_run.lk
