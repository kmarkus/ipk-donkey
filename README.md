ipk-donkey
==========

tiny bitbake ipk server for quick and dirty serving of the results of
the current build.

build & install
---------------

```sh
$ cd ipk-donkey
$ sudo chicken-install
```

configure yocto in `local.conf`
-------------------------------

```sh
# enable package management
EXTRA_IMAGE_FEATURES ?= "debug-tweaks package-management"

# configure server ip (and port)
PACKAGE_FEED_URIS ?= "<ip>:8080"
PACKAGE_FEED_BASE_PATHS = ""
```

Run
---

After sourcing an `oe-init-build-env` file, just run as follows to
serve the current build

```sh
$ ipk-donkey
serving directory /home/klk/yocto-builds/skybase-dev/tmp/deploy/ipk on port 8080
```

Customize
---------

You can customize some properties in the `.ipk-donkey` dot file, which
is automatically created.
