#!/bin/bash

keyid='490E35E9D6989BF912BBE3835A77F527AAE2E137'

dpkg-scanpackages --version || sudo apt install dpkg-dev
apt-ftparchive --version    || sudo apt install apt-utils

mkdir ./repo
pushd ./repo

	rm -rf packages-*.db
	rm -rf dists/*/*Release*

	mkdir -p ./dists/main/main/source
	mkdir -p ./dists/main/main/binary-{amd64,i386}

# https://unix.stackexchange.com/questions/403485/how-to-generate-the-release-file-on-a-local-package-repository

	apt-ftparchive generate -c=../aptftp.conf ../aptgenerate.conf
	apt-ftparchive release  -c=../aptftp.conf dists/main > dists/main/Release

	gpg -u "${keyid}" -bao dists/main/Release.gpg dists/main/Release
	gpg -u "${keyid}" --clear-sign --output dists/main/InRelease dists/main/Release
	
popd
