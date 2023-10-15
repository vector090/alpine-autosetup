# Alpine autosetup

Alpine autosetup is a helper to make auto-install possible on Alpine Linux.

## Basic idea

Alpine autosetup can work in two modes. In ``cidata`` mode it will create a tiny-cloud config to execute itself on first boot.
This can be distributed for example as an extra iso filesystem attached to a virtual machine, or in a usb key formatted in iso mode.

In ``apkovl`` mode it  will create a minimal ``host.apkovl.tar.gz`` containing:

- a setup-alpine [answer file](https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html#_answer_files)
- a ``local.d/25-autosetup.start`` to perform the installation, but [only once](https://www.youtube.com/watch?v=A4I9DMSvJxg)
- enabling the ``local`` service on the default runlevel in the first boot
- the secret ``/etc/.default_boot_services`` so that the minimal apkovl doesn't [break](https://gitlab.alpinelinux.org/alpine/mkinitfs/-/issues/8) the regular firstboot

The ``apkovl`` can be given to the initial iso in various ways, including in an extra volume, for virtual machines.

## Configuration

You can customize:

- ``config``: main configuration file to customize your installation. You can also have multiple copies for different templates.
- ``setup-alpine-answers.in``: note that alpine autosetup was developed mostly with [diskless installations](https://wiki.alpinelinux.org/wiki/Installation#Diskless_Mode) in mind. We use only part of this for ``cidata`` mode as we don't call the full ``setup-alpine`` then.
- ``steps/*``: the actual scripts that are run to set up the system. Feel free to add some, disable some, or help making them smarter or more configurable.

For ``cidata`` mode:

- ``user-data.in``: contains the main configutation for tiny-cloud, installing the rest of ``alpine-autosetup`` and calling into it

And for ``apkovl`` mode:

- ``apk-repositories.in``: it's just your system's /etc/apk/repositories file.
- ``25-autosetup.start.in``: the local service. Not much to see here, it just starts all the scripts below.

## Execution

```bash
<path>/setup-create-apkovl <hostname>
```
Generates just the apkovl archive.

```bash
<path>/setup-create-image <hostname>
```
Generates an ext4 image. In "apkovl" mode this contains the archive, and an empty apk cache.

```bash
<path>/setup-create-cidataiso <hostname>
# or, alternatively
CONF=myconfig <path>/setup-create-cidataiso <hostname>
```
Generates an iso image, labeled ``cidata`` and containing the ``tiny-cloud`` configuration and the autosetup scripts.


```bash
<path>/setup-libvirt <hostname>
# or, alternatively
CONF=myconfig <path>/setup-libvirt <hostname>
```
Generates the virtual machine storage, by default in /var/lib/libvirt/images, an xml libvirt template, and then uses virsh to start the new machine.

None of the scripts require root privileges, but the last one needs access to the destination path, and the permissions to connect to libvirt and administer vms (usually granted by group memberships).


## Testing

```bash
# test create-apkovl script
tests/test-setup-create-apkovl

# test create-image script
tests/test-setup-create-image
```
Tests run the setup scripts with a temp destination directories to check that they succeed and have the expected output.

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate. Yeah, ideally we would also add some. :)

## License

[MIT](https://choosealicense.com/licenses/mit/)

