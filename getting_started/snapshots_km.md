---
label: Program Snapshot with Kontain Monitor
icon: /images/kon.png
---

## Snapshots with Kontain Monitor

"Cold starts" are the normal start of a program/workload.  For some workloads, this can take quite some time, and hence operators tend to keep a copy or instance of the program/workload running at all times because the delayed user experience for starting a program on demand would not be very ideal.

Kontain "Snapshots" can be used to very significantly speed up the "normal" "cold" start of a program/workload using Kontain monitor.

The process by which this can be done is shown below using a very simple python program.

Please note that the following usage of Kontain snapshotting is not a snapshot of a heavy workload but just an illustration of how to use the Kontain Snapshot feature for any kind of program/workload.


#### Python program snapshot example
Below we show a very simple example of how to use Kontain Monitor to snapshot a simple Python program and then replay the snapshot.

Assuming you have Kontain installed, you can do the following in 1 terminal:

```bash
/opt/kontain/bin/km --mgtpipe=/tmp/mgtpipe /usr/bin/python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

In another terminal, you can use the *km_cli* program to create a snapshot of the above running program:

```bash
/opt/kontain/bin/km_cli -s /tmp/mgtpipe
```

This sends a signal to the running program by using the management pipe, to create a snapshot of the running program.

You will see the additional output in terminal 1 showing the location of the snapshot on disk

```bash
/opt/kontain/bin/km --mgtpipe=/tmp/mgtpipe /usr/bin/python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...

18:50:41.755174 km_dump_core         878  km      Writing snapshot to './kmsnap'
18:50:41.755324 fs_core_write_socket 2711 km      ===> i4 0.0.0.0 8000
```

#### Running the snapshot using Kontain Monitor

The following shows how to the run the above program snapshot that was created using Kontain Monitor.


This enables the program to start instantly even on cold starts.


In terminal 1, run the program snapshot which starts immediately:


```bash
/opt/kontain/bin/km ./kmsnap
```

In terminal 2:

```bash
curl http://localhost:8000
...
...output...
```

## What are Kontain Snapshots?
Kontain Snapshots capture the memory state of the running program.  It serializes the memory image and state of the guest process to disk along with whatever is necessary to restore the program to running state from the snapshot.

By running the snapshot using Kontain Monitor, you can restore the running state of the guest process or workload "instantly".
