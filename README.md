ipk-donkey
==========

tiny bitbake ipk server for quick and dirty serving of the results of
the current build.

Build & Install
---------------

install chicken scheme:

```sh
$ sudo apt-get install chicken-bin
```

clone the repo and build it:

```sh
$ cd ipk-donkey
$ sudo chicken-install
```

Configure package URI and path
-------------------------------

In `local.conf`:

```sh
# enable package management
EXTRA_IMAGE_FEATURES ?= "debug-tweaks package-management"

# configure server ip (and port), leave feed path empty
PACKAGE_FEED_URIS ?= "<ip>:8080"
PACKAGE_FEED_BASE_PATHS = ""
```

Running
-------

After sourcing an `oe-init-build-env` file, just run as follows to
serve the current build

```sh
$ ipk-donkey
serving directory /build/bbb-dunfell/build/tmp/deploy/ipk on port 8080
```

(If you can't run `ipk-donkey` with the build environment sourced, you
can also manually set the `BUILDDIR` environment variable)

run `ipk-donkey -h` to see available options.

after (re-) building one or more package, make sure to run `bitbake
package-index` to refresh the package lists.


Installing packages on the target
---------------------------------

With the above, just run the regualar

```sh
$ opkg update
$ opkg install PACKAGE
```

**Note**

If the code has changed but the version hasn't (i.e. during
development using `devtool`) then you may need to force the reinstall

```sh
$ opkg update && opkg install --force-reinstall PACKAGE
```

License
-------

BSD-3-Clause
