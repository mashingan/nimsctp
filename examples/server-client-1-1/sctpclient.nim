import sctp
import posix

const
  #MAXBUFFER = 1024
  MYPORT = 62324

var
  ret: cint
  servaddr: Sockaddr_in
  #status: TSctpStatus
  buffer: string
  datalen = 0
  connSock: SocketHandle

stdout.write "Enter data to send: "
buffer = stdin.readLine
datalen = buffer.len
connSock = socket(AF_INET, SOCK_STREAM, IPPROTO_SCTP)

servaddr.addr.zeromem Sockaddr_in.sizeof
servaddr.sin_family = AF_INET
servaddr.sin_addr.s_addr = inet_addr "127.0.0.1"
servaddr.sin_port = htons MYPORT

ret = connSock.connect(cast[ptr SockAddr](addr servaddr),
  Socklen(sizeof servaddr))

echo "The data length is ", datalen
echo "The buffer is ", buffer
ret = connSock.sctpSendmsg(buffer.cstring, datalen.csize,
  cast[ptr Sockaddr](nil), Socklen 0, 0'u32, 0'u32, 0'u16, 0'u32, 0'u32)

if ret != -1:
  echo "Successfully sent ", ret, " bytes data to server"

discard connSock.close
