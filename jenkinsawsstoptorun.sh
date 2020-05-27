#!/bin/bash
# relaunch container (trigger after ecr image updated) script for jenkins
# uses make & Makefile
# pmcampbell
# 2020-05-26

make ecsrestart
