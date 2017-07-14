

when not defined(linux):
  {.error: "Only supported in Linux".}

{.passL: "-lsctp".}
{.passC: "-fpack-struct=4".}

import posix

const
  MSG_OOB* = 0x01
  MSG_PEEK* = 0x02
  MSG_DONTROUTE* = 0x04
  MSG_TRYHARD* = MSG_DONTROUTE
  MSG_CTRUNC* = 0x08
  MSG_PROXY* = 0x10
  MSG_TRUNC* = 0x20
  MSG_DONTWAIT* = 0x40
  MSG_EOR* = 0x80
  MSG_WAITALL* = 0x100
  MSG_FIN* = 0x200
  MSG_CONFIRM* = 0x800
  MSG_RST* = 0x1000
  MSG_ERRQUEUE* = 0x2000
  MSG_NOSIGNAL* = 0x4000
  MSG_MORE* = 0x8000
  MSG_CMSG_CLOEXEC* = 0x40000000

const
  SOL_SCTP* = 132
  IPPROTO_SCTP*: cint = 132

type
  TSctpAssocT* = int32
  #TSockaddrStorage* {.importc: "struct sockaddr_storage",
  #  header: sysheader.} = object
  TSockaddrStorage* = Sockaddr_storage
  #TSockaddr* {.importc: "struct sockaddr", header: sysheader.} = object
  TSockaddr* = SockAddr
  #Socklen* {.importc: "socklen_t", header: sysheader.} = object
  TSocklen* = Socklen
  #TSaFamily* {.importc: "sa_family_t", header: sysheader.} = object



const
  HAVE_SCTP* = true
  HAVE_KERNEL_SCTP* = true
  HAVE_SCTP_MULTIBUF* = true
  HAVE_SCTP_NOCONNECT* = true
  HAVE_SCTP_PRSCTP* = true
  HAVE_SCTP_ADDIP* = true
  HAVE_SCTP_CANSET_PRIMARY* = true


const
  SCTP_RTOINFO* = 0
  SCTP_ASSOCINFO* = 1
  SCTP_INITMSG* = 2
  SCTP_NODELAY* = 3
  SCTP_AUTOCLOSE* = 4
  SCTP_SET_PEER_PRIMARY_ADDR* = 5
  SCTP_PRIMARY_ADDR* = 6
  SCTP_ADAPTATION_LAYER* = 7
  SCTP_DISABLE_FRAGMENTS* = 8
  SCTP_PEER_ADDR_PARAMS* = 9
  SCTP_DEFAULT_SEND_PARAM* = 10
  SCTP_EVENTS* = 11
  SCTP_I_WANT_MAPPED_V4_ADDR* = 12
  SCTP_MAXSEG* = 13
  SCTP_STATUS* = 14
  SCTP_GET_PEER_ADDR_INFO* = 15
  SCTP_DELAYED_ACK_TIME* = 16
  SCTP_DELAYED_ACK* = SCTP_DELAYED_ACK_TIME
  SCTP_DELAYED_SACK* = SCTP_DELAYED_ACK_TIME
  SCTP_CONTEXT* = 17
  SCTP_FRAGMENT_INTERLEAVE* = 18
  SCTP_PARTIAL_DELIVERY_POINT* = 19
  SCTP_MAX_BURST* = 20
  SCTP_AUTH_CHUNK* = 21
  SCTP_HMAC_IDENT* = 22
  SCTP_AUTH_KEY* = 23
  SCTP_AUTH_ACTIVE_KEY* = 24
  SCTP_AUTH_DELETE_KEY* = 25
  SCTP_PEER_AUTH_CHUNKS* = 26
  SCTP_LOCAL_AUTH_CHUNKS* = 27
  SCTP_GET_ASSOC_NUMBER* = 28


const
  SCTP_SOCKOPT_BINDX_ADD* = 100
  SCTP_SOCKOPT_BINDX_REM* = 101
  SCTP_SOCKOPT_PEELOFF* = 102


const
  SCTP_SOCKOPT_CONNECTX_OLD* = 107
  SCTP_GET_PEER_ADDRS* = 108
  SCTP_GET_LOCAL_ADDRS* = 109
  SCTP_SOCKOPT_CONNECTX* = 110
  SCTP_SOCKOPT_CONNECTX3* = 111


const
  SCTP_GET_ASSOC_STATS* = 112
  SCTP_SOCKOPT_PEELOFF_FLAGS* = 122


type
  TSctpInitmsg* = object
    sinitNumOstreams*: uint16
    sinitMaxInstreams*: uint16
    sinitMaxAttempts*: uint16
    sinitMaxInitTimeo*: uint16



type
  TSctpSndrcvinfo* = object
    sinfoStream*: uint16
    sinfoSsn*: uint16
    sinfoFlags*: uint16
    sinfoPpid*: uint32
    sinfoContext*: uint32
    sinfoTimetolive*: uint32
    sinfoTsn*: uint32
    sinfoCumtsn*: uint32
    sinfoAssocId*: TSctpAssocT



type
  TSctpSinfoFlags* = enum
    SCTP_UNORDERED = 1, SCTP_ADDR_OVER = 2, SCTP_ABORT = 4,
    SCTP_SACK_IMMEDIATELY = 8,
    SCTP_EOF = MSG_FIN


type
  TSctpCmsgDataT* = object {.union.}
    raw*: uint8
    init*: TSctpInitmsg
    sndrcv*: TSctpSndrcvinfo



type
  TSctpCmsgT* = enum
    SCTP_INIT, SCTP_SNDRCV



type
  TSctpAssocChange* = object
    sacType*: uint16
    sacFlags*: uint16
    sacLength*: uint32
    sacState*: uint16
    sacError*: uint16
    sacOutboundStreams*: uint16
    sacInboundStreams*: uint16
    sacAssocId*: TSctpAssocT
    sacInfo*: array[0, uint8]



type
  TSctpSacState* = enum
    SCTP_COMM_UP, SCTP_COMM_LOST, SCTP_RESTART, SCTP_SHUTDOWN_COMP,
    SCTP_CANT_STR_ASSOC

type
  TSctpPaddrChange* {.packed.} = object
    spcType*: uint16
    spcFlags*: uint16
    scpLength*: uint32
    spcAaddr*: TSockaddrStorage
    spcState*: int
    scpError*: int
    scpAssocId*: TSctpAssocT


type
  TSctpSpcState* = enum
    SCTP_ADDR_AVAILABLE, SCTP_ADDR_UNREACHABLE, SCTP_ADDR_REMOVED, SCTP_ADDR_ADDED,
    SCTP_ADDR_MADE_PRIM, SCTP_ADDR_CONFIRMED



type
  TSctpRemoteError* = object
    sreType*: uint16
    sreFlags*: uint16
    sreLength*: uint32
    sreError*: uint16
    sreAssocId*: TSctpAssocT
    sreData*: array[0, uint8]



type
  TSctpSendFailed* = object
    ssfType*: uint16
    ssfFlags*: uint16
    ssfLength*: uint32
    ssfError*: uint32
    ssfInfo*: TSctpSndrcvinfo
    ssfAssocId*: TSctpAssocT
    ssfData*: array[0, uint8]



type
  TSctpSsfFlags* = enum
    SCTP_DATA_UNSENT, SCTP_DATA_SENT



type
  TSctpShutdownEvent* = object
    sseType*: uint16
    sseFlags*: uint16
    sseLength*: uint32
    sseAssocId*: TSctpAssocT



type
  TSctpAdaptationEvent* = object
    saiType*: uint16
    saiFlags*: uint16
    saiLength*: uint32
    saiAdaptationInd*: uint32
    saiAssocId*: TSctpAssocT



type
  TSctpPdapiEvent* = object
    pdapiType*: uint16
    pdapiFlags*: uint16
    pdapiLength*: uint32
    pdapiIndication*: uint32
    pdapiAssocId*: TSctpAssocT


const
  SCTP_PARTIAL_DELIVERY_ABORTED* = 0


type
  TSctpAuthkeyEvent* = object
    authType*: uint16
    authFlags*: uint16
    authLength*: uint32
    authKeynumber*: uint16
    authAltkeynumber*: uint16
    authIndication*: uint32
    authAssocId*: TSctpAssocT


const
  SCTP_AUTH_NEWKEY* = 0

type
  TSctpSenderDryEvent* = object
    senderDryType*: uint16
    senderDryFlags*: uint16
    senderDryLength*: uint32
    senderDryAssocId*: TSctpAssocT



type
  TSctpEventSubscribe* = object
    sctpDataIoEvent*: uint8
    sctpAssociationEvent*: uint8
    sctpAddressEvent*: uint8
    sctpSendFailureEvent*: uint8
    sctpPeerErrorEvent*: uint8
    TSctpShutdownEvent*: uint8
    sctpPartialDeliveryEvent*: uint8
    sctpAdaptationLayerEvent*: uint8
    sctpAuthenticationEvent*: uint8
    TSctpSenderDryEvent*: uint8



type
  INNER_C_STRUCT_3967566877* = object
    snType*: uint16
    snFlags*: uint16
    snLength*: uint32

  TSctpNotification* = object {.union.}
    snHeader*: INNER_C_STRUCT_3967566877
    snAssocChange*: TSctpAssocChange
    snPaddrChange*: TSctpPaddrChange
    snRemoteError*: TSctpRemoteError
    snSendFailed*: TSctpSendFailed
    snShutdownEvent*: TSctpShutdownEvent
    snAdaptationEvent*: TSctpAdaptationEvent
    snPdapiEvent*: TSctpPdapiEvent
    snAuthkeyEvent*: TSctpAuthkeyEvent
    snSenderDryEvent*: TSctpSenderDryEvent



type
  TSctpSnType* = enum
    SCTP_SN_TYPE_BASE = (1 shl 15), SCTP_ASSOC_CHANGE, SCTP_PEER_ADDR_CHANGE,
    SCTP_SEND_FAILED, SCTP_REMOTE_ERROR, SCTP_SHUTDOWN_EVENT,
    SCTP_PARTIAL_DELIVERY_EVENT, SCTP_ADAPTATION_INDICATION,
    SCTP_AUTHENTICATION_INDICATION, SCTP_SENDER_DRY_EVENT



type
  TSctpSnErrorT* = enum
    SCTP_FAILED_THRESHOLD, SCTP_RECEIVED_SACK, SCTP_HEARTBEAT_SUCCESS,
    SCTP_RESPONSE_TO_USER_REQ, SCTP_INTERNAL_ERROR, SCTP_SHUTDOWN_GUARD_EXPIRES,
    SCTP_PEER_FAULTY



type
  TSctpRtoinfo* = object
    srtoAssocId*: TSctpAssocT
    srtoInitial*: uint32
    srtoMax*: uint32
    srtoMin*: uint32



type
  TSctpAssocparams* = object
    sasocAssocId*: TSctpAssocT
    sasocAsocmaxrxt*: uint16
    sasocNumberPeerDestinations*: uint16
    sasocPeerRwnd*: uint32
    sasocLocalRwnd*: uint32
    sasocCookieLife*: uint32

type
  TSctpSetpeerprim* {.packed.} = object
    ssppAssocId*: TSctpAssocT
    ssppAddr*: TSockaddrStorage

type
  TSctpSetprim* {.packed.} = object
    sspAssocId*: TSctpAssocT
    sspAddr*: TSockaddrStorage



#[
const
  sctpPrim* = sctpSetprim
]#


type
  TSctpSetadaptation* = object
    ssbAdaptationInd*: uint32



type
  TSctpSppFlags* = enum
    SPP_HB_ENABLE = 1 shl 0,
    SPP_HB_DISABLE = 1 shl 1,
    SPP_HB = SPP_HB_ENABLE.int or SPP_HB_DISABLE.int,
    SPP_HB_DEMAND = 1 shl 2,
    SPP_PMTUD_ENABLE = 1 shl 3, SPP_PMTUD_DISABLE = 1 shl 4,
    SPP_PMTUD = SPP_PMTUD_ENABLE.int or SPP_PMTUD_DISABLE.int,
    SPP_SACKDELAY_ENABLE = 1 shl 5, SPP_SACKDELAY_DISABLE = 1 shl 6,
    SPP_SACKDELAY = SPP_SACKDELAY_ENABLE.int or SPP_SACKDELAY_DISABLE.int,
    SPP_HB_TIME_IS_ZERO = 1 shl 7


type
  TSctpPaddrparams* {.packed.} = object
    sppAssocId*: TSctpAssocT
    sppAddress*: TSockaddrStorage
    sppHbinterval*: uint32
    sppPathmaxrxt*: uint16
    sppPathmtu*: uint32
    sppSackdelay*: uint32
    sppFlags*: uint32


type
  TSctpAuthchunk* = object
    sauthChunk*: uint8



const
  SCTP_AUTH_HMAC_ID_SHA1* = 1
  SCTP_AUTH_HMAC_ID_SHA256* = 3

type
  TSctpHmacalgo* = object
    shmacNumberOfIdents*: uint32
    shmacIdents*: ptr uint16



type
  TSctpAuthkey* = object
    scaAssocId*: TSctpAssocT
    scaKeynumber*: uint16
    scaKeylength*: uint16
    scaKey*: ptr uint8



type
  TSctpAuthkeyid* = object
    scactAssocId*: TSctpAssocT
    scactKeynumber*: uint16



type
  TSctpSackInfo* = object
    sackAssocId*: TSctpAssocT
    sackDelay*: uint32
    sackFreq*: uint32

  TSctpAssocValue* = object
    assocId*: TSctpAssocT
    assocValue*: uint32

type
  TSctpPaddrinfo* {.packed.} = object
    spinfoAssocId*: TSctpAssocT
    spinfoAddress*: TSockaddrStorage
    spinfoState*: int32
    spinfoCwnd*: uint32
    spinfoSrtt*: uint32
    spinfoRto*: uint32
    spinfoMtu*: uint32


type
  TSctpSpinfoState* = enum
    SCTP_INACTIVE, SCTP_PF, SCTP_ACTIVE, SCTP_UNCONFIRMED, SCTP_UNKNOWN = 0x0000FFFF



type
  TSctpStatus* = object
    sstatAssocId*: TSctpAssocT
    sstatState*: int32
    sstatRwnd*: uint32
    sstatUnackdata*: uint16
    sstatPenddata*: uint16
    sstatInstrms*: uint16
    sstatOutstrms*: uint16
    sstatFragmentationPoint*: uint32
    sstatPrimary*: TSctpPaddrinfo



type
  TSctpAuthchunks* = object
    gauthAssocId*: TSctpAssocT
    gauthNumberOfChunks*: uint32
    gauthChunks*: ptr uint8



#[
const
  guthNumberOfChunks* = gauthNumberOfChunks
]#


type
  TSctpSstatState* = enum
    SCTP_EMPTY = 0, SCTP_CLOSED = 1, SCTP_COOKIE_WAIT = 2, SCTP_COOKIE_ECHOED = 3,
    SCTP_ESTABLISHED = 4, SCTP_SHUTDOWN_PENDING = 5, SCTP_SHUTDOWN_SENT = 6,
    SCTP_SHUTDOWN_RECEIVED = 7, SCTP_SHUTDOWN_ACK_SENT = 8



type
  TSctpGetaddrsOld* = object
    assocId*: TSctpAssocT
    addrNum*: cint
    addrs*: ptr TSockaddr

  TSctpGetaddrs* = object
    assocId*: TSctpAssocT
    addrNum*: uint32
    addrs*: array[0, uint8]



type
  TSctpAssocStats* = object
    sasAssocId*: TSctpAssocT
    sasObsRtoIpaddr*: TSockaddrStorage
    sasMaxrto*: uint64
    sasIsacks*: uint64
    sasOsacks*: uint64
    sasOpackets*: uint64
    sasIpackets*: uint64
    sasRtxchunks*: uint64
    sasOutofseqtsns*: uint64
    sasIdupchunks*: uint64
    sasGapcnt*: uint64
    sasOuodchunks*: uint64
    sasIuodchunks*: uint64
    sasOodchunks*: uint64
    sasIodchunks*: uint64
    sasOctrlchunks*: uint64
    sasIctrlchunks*: uint64



type
  TSctpMsgFlags* = enum
    MSG_NOTIFICATION = 0x00008000



const
  SCTP_BINDX_ADD_ADDR* = 0x00000001
  SCTP_BINDX_REM_ADDR* = 0x00000002


type
  TSctpPeeloffArgT* = object
    associd*: TSctpAssocT
    sd*: cint

  TSctpPeeloffFlagsArgT* = object
    pArg*: TSctpPeeloffArgT
    flags*: cuint

const sctpheader = "<netinet/sctp.h>"

proc sctpBindx*(sd: cint | SocketHandle; addrs: ptr TSockaddr;
  addrcnt: cint; flags: cint): cint
  {.cdecl, header: sctpheader, importc: "sctp_bindx".}
proc sctpConnectx*(sd: cint | SocketHandle; addrs: ptr TSockaddr;
  addrcnt: cint; id: ptr TSctpAssocT): cint
  {.cdecl, header: sctpheader, importc: "sctp_connectx".}
proc sctpPeeloff*(sd: cint | SocketHandle; assocId: TSctpAssocT): cint
  {.cdecl, header: sctpheader, importc: "sctp_peeloff".}
proc sctpPeeloffFlags*(sd: cint | SocketHandle; assocId: TSctpAssocT;
  flags: cuint): cint
  {.cdecl, header: sctpheader, importc: "sctp_peeloff_flags".}

proc sctpOptInfo*(sd: cint | SocketHandle; id: TSctpAssocT; opt: cint;
  arg: pointer; size: ptr Socklen): cint
  {.cdecl, header: sctpheader, importc: "sctp_opt_info".}

proc sctpGetpaddrs*(sd: cint | SocketHandle; id: TSctpAssocT;
  addrs: ptr ptr TSockaddr): cint
  {.cdecl, header: sctpheader, importc: "sctp_getpaddrs".}

proc sctpFreepaddrs*(addrs: ptr TSockaddr): cint
  {.cdecl, header: sctpheader, importc: "sctp_freepaddrs".}

proc sctpGetladdrs*(sd: cint | SocketHandle; id: TSctpAssocT;
  addrs: ptr ptr TSockaddr): cint
  {.cdecl, header: sctpheader, importc: "sctp_getladdrs".}

proc sctpFreeladdrs*(addrs: ptr TSockaddr): cint
  {.cdecl, header: sctpheader, importc: "sctp_freeladdrs".}

proc sctpSendmsg*(s: cint | SocketHandle; msg: pointer; len: csize;
  to: ptr TSockaddr; tolen: Socklen; ppid: uint32; flags: uint32;
  streamNo: uint16; timetolive: uint32; context: uint32): cint
  {.cdecl, header: sctpheader, importc: "sctp_sendmsg".}

proc sctpSend*(s: cint | SocketHandle; msg: pointer; len: csize;
  sinfo: ptr TSctpSndrcvinfo; flags: cint): cint
  {.cdecl, header: sctpheader, importc: "sctp_send".}

proc sctpRecvmsg*(s: cint | SocketHandle; msg: pointer; len: csize;
  `from`: ptr TSockaddr; fromlen: ptr Socklen; sinfo: ptr TSctpSndrcvinfo;
  msgFlags: ptr cint): cint
  {.cdecl, header: sctpheader, importc: "sctp_recvmsg".}

proc sctpGetaddrlen*(family: TSaFamily): cint
  {.cdecl, header: sctpheader, importc: "sctp_getaddrlen".}
