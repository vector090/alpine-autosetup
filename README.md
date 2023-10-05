# Alpine autosetup

Alpine autosetup is a helper to make auto-install possible on Alpine Linux.

## Basic idea

Alpine autosetup will create a minimal ``host.apkovl.tar.gz`` containing:

- a setup-alpine [answer file](https://docs.alpinelinux.org/user-handbook/0.1a/Installing/setup_alpine.html#_answer_files)
- a ``local.d/25-autosetup.start`` to perform the installation, but [only once](https://www.youtube.com/watch?v=A4I9DMSvJxg)
- enabling the ``local`` service on the default runlevel in the first boot
- the secret ``/etc/.default_boot_services`` so that the minimal apkovl doesn't [break](https://gitlab.alpinelinux.org/alpine/mkinitfs/-/issues/8) the regular firstboot

The ``apkovl`` can be given to the initial iso in various ways, including in an extra volume, for virtual machines.

## Configuration

You can customize:

- ``setup-alpine-answers.in``: note that this script was developed mostly with [diskless installations](https://wiki.alpinelinux.org/wiki/Installation#Diskless_Mode) in mind.
- ``apk-repositories.in``: it's just your system's /etc/apk/repositories file.
- ``25-autosetup.start.in``: the local service. Not much to see here, it just starts all the scripts below.
- ``steps/*``: the actual scripts that are run to set up the system. Feel free to add some, disable some, or help making them smarter or more configurable.

## Execution

```bash
<path>/setup-create-apkovl <hostname>
```
Generates just the apkovl archive.

```bash
<path>/setup-create-image <hostname>
```
Generates instead an ext4 image labeled ``APKOVL`` and containing the archive, and an empty apk cache.

```bash
<path>/setup-libvirt <hostname>
```
Generates the apkovl image and a swap image, by default in /var/lib/libvirt/images, an xml libvirt template, and then uses virsh to start the new machine.


None of the scripts require root privileges, but the last one needs access to the destination path, and the permissions to connect to libvirt and administer vms (usually granted by group memberships).

## Contributing

Pull requests are welcome. For major changes, please open an issue first
to discuss what you would like to change.

Please make sure to update tests as appropriate. Yeah, ideally we would also add some. :)

## License

[MIT](https://choosealicense.com/licenses/mit/)

