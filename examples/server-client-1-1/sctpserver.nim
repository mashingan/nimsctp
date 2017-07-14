import sctp
import posix

const
  MAXBUFFER = 1024
  MYPORT = 62324

var
  ret, incode, flags: cint
  servaddr: Sockaddr_in
  initmsg: TSctpInitmsg
  #events: TSctpEventSubscribe
  sndrcvinfo: TSctpSndrcvinfo
  buffer: array[MAXBUFFER+1, char]
  #buffer = newSeq[char](MAXBUFFER+1)
  listenSock, connSock: SocketHandle

listenSock = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP)

servaddr.addr.zeromem Sockaddr_in.sizeof
servaddr.sin_family = AF_INET
servaddr.sin_addr.s_addr = htonl INADDR_ANY
servaddr.sin_port = htons MYPORT

ret = listenSock.bindSocket(cast[ptr SockAddr](addr servaddr),
  (sizeof servaddr).Socklen)
# ret == -1 if the operation failed

initmsg.addr.zeromem TSctpInitmsg.sizeof
initmsg.sinitNumOstreams = 5
initmsg.sinitMaxInstreams = 5
initmsg.sinitMaxAttempts = 4
ret = listenSock.setSockopt(IPPROTO_SCTP, SCTP_INITMSG,
  cast[pointer](addr initmsg), Socklen(sizeof initmsg))
# ret == -1 if the operation failed

ret = listenSock.listen 5

while true:
  #var buffer = newString MAXBUFFER+1
  buffer.addr.zeromem buffer.sizeof
  echo "Awaiting a new connection"

  connSock = listenSock.accept(cast[ptr Sockaddr](nil),
    cast[ptr Socklen](nil))
  if connSock.cint == -1:
    echo "accept() failed"
    #connSock.close
    discard connSock.close
    continue
  else:
    echo "New client connected..."

  incode = sctpRecvmsg(connSock, addr buffer,
    (sizeof buffer).csize, cast[ptr Sockaddr](nil),
    cast[ptr Socklen](0), addr sndrcvinfo, addr flags)

  if incode != -1:
    echo " Length data received: ", incode
    #buffer[incode] = '\0'
    echo " Data: ", $buffer

  discard connSock.close
