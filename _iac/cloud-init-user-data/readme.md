# info on certain steps in cloud init script
We do following (kernel-exclude in update) because otherwise dnf updates kernel from 5.10 to 5.16


```shell
dnf install -y "kernel-devel-uname-r == $(uname -r)"
dnf -y --exclude=kernel* update
```


kernel version 5.16 in Fedora introduces a new variable which breaks kkm install:

```shell
/var/lib/dkms/kkm/0.9/build/kkm/kkm_main.c: In function ‘kkm_check_cpu_support’:
/var/lib/dkms/kkm/0.9/build/kkm/kkm_main.c:898:13: error: ‘fpu_kernel_xstate_size’ undeclared (first use in this function)
  898 |         if (fpu_kernel_xstate_size > KKM_XSTATE_DATA_SIZE) {
      |             ^~~~~~~~~~~~~~~~~~~~~~
/var/lib/dkms/kkm/0.9/build/kkm/kkm_main.c:898:13: note: each undeclared identifier is reported only once for each function it appears in
```


We do following to ensure that after an update that the system is in a consistent state after checking if it needs rebooting while yum not running and also ensure that cloud-init runs again after reboot by removing the instance record created.

```shell
(test ! -f /var/cache/dnf/*pid && needs-restarting -r) || (rm -rf /var/lib/cloud/instances/;reboot)
```
