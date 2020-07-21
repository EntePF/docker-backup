# How to configure my backups

Look at *config.sh* to see an example of how to setup your backup.

By calling *configure_daily_job.sh* linux will run *congig.sh* once a day (at 4 AM or later).

# Project architecture

The functionality is described in *src/lib.sh*.

Tests are described in *test/lib.spec.sh* and need to be executed from the root directory of this repository.

