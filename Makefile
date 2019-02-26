#!/usr/bin/env make

.PHONY: *

release:
	bosh create-release --tarball=release.tgz --force

blobs:
	for i in .blobs/*/*; do bosh add-blob $$i $${i#*/}; done

#
