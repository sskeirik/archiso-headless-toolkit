ArchISO Headless Installation Toolkit
=====================================

Overview
--------

This repository exists to record the process of building an Arch ISO with:

- SSH server turned on
- your public SSH keys available for login
- auto-booting (no need to press enter, even virtually)

such that it can be used to install Arch Linux VMs in headless environments.
We provide:

- scripts to automate Arch ISO builds with the required parameters set
- scripts to spin up a new VirtualBox VM using this ISO with NAT-based internet
  connectivity to enable SSH login into the installation ISO

Nothing is particularly tricky about this process except that each VM software
has different capabilities when it comes to host <-> guest internet
connectivity.

Installation
------------

This toolkit depends on a working Arch Linux installation with Arch ISO
installed, i.e.,

```
sudo pacman -S archiso
```

Usage
-----

There are potentially three machines involved in the installation process:

- the user machine (the machine which you run these instructions from)
- the build machine (an Arch Linux host where the ISO is created)
- the host machine (the headless environment where the VM will be installed)

First, log-in to the build machine, clone the toolkit repository, and do the
following:

1.  Run the following to build an SSH-enabled Arch ISO.
    Set the `PUBLIC_KEY` variable in the script to point to your custom key
    location (if required).

    ```
    rebuildiso
    ```

    The script will delete and recreate the `./build` directory.
    The newly generated ISO will be stored at `./build/out`.

Then, log-in to the host machine, clone the toolkit repository, and do the
following:

1.  Copy the generated ISO from the build machine to the repository root.
2.  Run the following commands to create a new (VirtualBox) VM and attach the
    installation ISO.

    ```
    createvm
    attachiso
    ```

    The created VM will have port-forwarding rules to enable an SSH log-in from
    the target machine.

3.  Start the VM using the following command:

    ```
    VBoxManage startvm <vm-name>
    ```

4.  Use the following command to log-in to the newly generated VM:

    ```
    ssh -p 2222 root@localhost
    ```

    Note that the port number may vary depending on your installation options.
    Note also the `known_hosts` file will become stale after installation; when
    logging in to the VM after installation, you will first need to clear the
    host entry that the installation login created.

5.  Complete the installation process (see the notes below).

6.  Power-off the VM and run the following to remove the installation ISO from
    VM virtual disk drive.

    ```
    detachiso
    ```

7.  Boot the VM as int step (3).
    If all goes well, you will be able to log-in
    to the VM using the same command as step (4).

### Alternative Use Cases

For alternative ideas about how to customize the process for your needs, see
the following discussion:

https://wiki.archlinux.org/index.php/Install_Arch_Linux_via_SSH

This unmaintained repository attempts to do something similar to the above:

https://github.com/EnigmaCurry/archiso-ssh-remix

Headless Environment Installation Precautions
---------------------------------------------

Note that these configurations above only apply to the installation ISO itself.
Using the generated ISO to install a system that will only be accessed 
headlessly additionally requires that you configure:

- SSH server settings
- your public SSH keys available for login
- auto-booting (this is an Arch Linux default; only needed for custom setups)
- an internet connection

The process of setting up the SSH server is straightforward. Obviously, setting
up an internet connection will vary between deployments.
In the simplest case, e.g. installations beneath a router/DHCP server, it is
enough to install a DHCP client service like `dhcpcd` and activate it on boot:

```
systemctl enable dhcpcd.service
```

Installation Failure Recovery Options
-------------------------------------

### Installation Debugging

If installation fails so that the installed VM does not properly boot with SSH
connectivity, VirtualBox offers a very crude form of debugging:

-   screenshot VM screen on the host machine

    ```
    VBoxManage controlvm <vmname> screenhostpng <filename>
    ```

-   copy images to the user machine for manual inspection
-   type keys on the virtual keyboard attached to the VM using scancodes:

    ```
    VBoxManage controlvm <vmname> keyboardputscancode <hex> [<hex>]*
    ```

    Example: type enter into VM

    ```
    VBoxManage controlvm <vmname> keyboardputscancode 1c 9c
    ```

    or strings:

    ```
    VBoxManage controlvm <vmname> keyboardputstring <string>
    ```

    or entire files:

    ```
    VBoxManage controlvm <vmname> keyboardputfile <filename>
    ```

    Note that in the last case, newlines will be interpreted as pressing the
    Enter key.

This process is very slow---it is much more advisable to script your
installation process so that you avoid these kind of errors.

### VM Introspection using Installation ISO

One can inspect the VM filesystem state by re-attaching the installation ISO,
connecting to the VM, and then mounting and `chroot`ing into the VM filesystem.
