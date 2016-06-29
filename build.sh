#!/bin/bash
#Build script for Android ROMs, copyleft Harsh Shandilya a.k.a. MSF Jarvis
#Utilises environment variables for functionality
# export SYNC and JOBS to trigger a repo sync, defaults to 4 jobs when not set
# export CLEAN to trigger a clean build export BRUNCH= to set brunch argument
# export LOG to generate logs
# export LOGDIST to copy logs to output folder
# export OUTDIR= and VARIANT= for where to copy the output zip
# VARIANT is optional since I keep my ROM builds segregated into folders
# script will work without it as well

_repo=repo sync --force-sync -f --no-tags -c --no-clone-bundle
if [ $SYNC ];then
  if [ $JOBS ]; then
    $_repo -j $JOBS
  else
    $_repo
  fi
fi
if [ $CLEAN ]; then
  make clean fi source build/envsetup.sh if [ $BRUNCH ]; then
  if [ $LOG ]; then
    brunch $BRUNCH > >(tee stdout.log) 2> >(tee stderr.log)
  else
    brunch $BRUNCH
  fi
else
  echo "No brunch target env var set!"
  exit 1
fi
if [ $OUTDIR ]; then
   rm $OUT/*ota*
   mv $OUT/*zip* $OUTDIR/$VARIANT
else
  echo "No output dir set! build not copied!"
  exit 2
fi
if [ $LOGDIST ]; then
  mkdir -p $OUTDIR/logs
  mv *.log $OUTDIR/logs
fi
