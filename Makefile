#!/usr/bin/env make

.PHONY: *

it: release version

release:
	bosh create-release --tarball=release.tgz --force

blobs:
	for i in .blobs/*/*; do bosh add-blob $$i $${i#*/}; done

version:
	mkdir -p .tmp
	tar -xzvf release.tgz -C .tmp release.MF
	@/bin/echo "---" > .tmp/ops-file.yml
	@/bin/echo "- type: replace" >> .tmp/ops-file.yml
	@/bin/echo "  path: /0/value/version" >> .tmp/ops-file.yml
	@/bin/echo -n "  value: " >> .tmp/ops-file.yml
	bosh int .tmp/release.MF --path /version >> .tmp/ops-file.yml
	bosh int ops/replace-grafana-5.yml -o .tmp/ops-file.yml > .tmp/replace-grafana-5.yml
	mv .tmp/replace-grafana-5.yml ops/replace-grafana-5.yml

#
