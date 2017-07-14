# nimsctp
Nim library wrapper for libsctp in Linux.

The available wrapper only possible in Linux and possibly on UNIX based in general. It's not available in Windows because no native support for SCTP protocol in there.  
There are several user-space implementation of SCTP support, however this lib is focusing on wrapping a native/kernel support. The API itself (libsctp) is user-space APIs which handles the syscall.

## SCTP
In short, SCTP is an improvement over widely available protocol of TCP and UDP. [Wikipedia page](https://en.wikipedia.org/wiki/SCTP) explains the detail better.
