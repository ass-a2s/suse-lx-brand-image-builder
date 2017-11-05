
ASS - pre-built images
======================

* http://dsapid.root1.ass.de/ui/#!/home

General
=======

Experimental lx branded zone for SuSE SLES 12 SP3

Current status: **it works**

# SmartOS Requirements

* SmartOS: > 20171026T003127Z
* https://us-east.manta.joyent.com/Joyent_Dev/public/SmartOS/smartos.html#20171026T003127Z
* https://smartos.org/bugview/OS-6326

# SuSE (build environment) Requirements

* SuSE SLES 12 (>SP2) host
* BTRFS

# Image and manifest creation

* on SuSE Linux Enterprise Server:

Run the `build-suse-zone-bundle.sh` script on a SuSE host.

Copy the `suse-sles-12-sp3-lx-zone-bundle.tar.gz` file to a SmartOS host.

* on SmartOS:

Checkout [this](https://github.com/ass-a2s/debian-lx-brand-image-builder) repository
and then execute:

```
./create-lx-image -t /zones/ass.de/test/suse-sles-12-sp3-lx-zone-bundle.tar.gz -k 4.4.0 -m 20171026T003127Z -i ass-suse-sles-12sp3 -d "ASS - SuSE SLES 12 SP3 64-bit lx-brand image." -u https://github.com/ass-a2s/suse-lx-brand-image-builder
```

This will produce the `.zfs` image and its manifest.

The can be imported via:

```
imgadm install -m ass-suse-sles-12sp3-20171104.json -f ass-suse-sles-12sp3-20171104.zfs.gz
```

The names of the image and of the manifest are going to change according to your local time.

# Information

* https://www.suse.com/documentation/sles-12/singlehtml/book_sles_docker/book_sles_docker.html
* https://www.suse.com/communities/blog/first-sles-container/

Errata
======

* 05.11.2017 - IPv6 DNS Resolving Issue (concerns: libzypp, libcurl)

```
lx-suse-sles-12:/zones/701e9758-1b05-c084-9246-b50e2b59c4a2/data # curl -v http://github.com
* Rebuilt URL to: http://github.com/
* Hostname was NOT found in DNS cache
* Could not resolve host: github.com
* Closing connection 0
curl: (6) Could not resolve host: github.com
lx-suse-sles-12:/zones/701e9758-1b05-c084-9246-b50e2b59c4a2/data #
```

ASS - pre-built image history
=============================

ass-suse-sles-12sp3:

* build-20171104: http://dsapid.root1.ass.de/ui/#!/configure/c5c815b2-c104-11e7-8670-3f01ad4c4fdc

ass-suse-sles-12sp2:

* build-20171031: http://dsapid.root1.ass.de/ui/#!/configure/353732d8-be90-11e7-aede-cf31a19019e1

