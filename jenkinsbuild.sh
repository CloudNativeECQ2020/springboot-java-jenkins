#!/bin/bash
# build script for jenkins
# uses make & Makefile
# pmcampbell
# 2020-05-06

# maven compile
make maven
# build container
make build
