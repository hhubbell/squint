const __root = @This();
pub const __builtin = @import("std").zig.c_translation.builtins;
pub const __helpers = @import("std").zig.c_translation.helpers;
pub const ptrdiff_t = c_long;
pub const wchar_t = c_int;
pub const max_align_t = extern struct {
    __aro_max_align_ll: c_longlong = 0,
    __aro_max_align_ld: c_longdouble = 0,
};
pub const __u_char = u8;
pub const __u_short = c_ushort;
pub const __u_int = c_uint;
pub const __u_long = c_ulong;
pub const __int8_t = i8;
pub const __uint8_t = u8;
pub const __int16_t = c_short;
pub const __uint16_t = c_ushort;
pub const __int32_t = c_int;
pub const __uint32_t = c_uint;
pub const __int64_t = c_long;
pub const __uint64_t = c_ulong;
pub const __int_least8_t = __int8_t;
pub const __uint_least8_t = __uint8_t;
pub const __int_least16_t = __int16_t;
pub const __uint_least16_t = __uint16_t;
pub const __int_least32_t = __int32_t;
pub const __uint_least32_t = __uint32_t;
pub const __int_least64_t = __int64_t;
pub const __uint_least64_t = __uint64_t;
pub const __quad_t = c_long;
pub const __u_quad_t = c_ulong;
pub const __intmax_t = c_long;
pub const __uintmax_t = c_ulong;
pub const __dev_t = c_ulong;
pub const __uid_t = c_uint;
pub const __gid_t = c_uint;
pub const __ino_t = c_ulong;
pub const __ino64_t = c_ulong;
pub const __mode_t = c_uint;
pub const __nlink_t = c_ulong;
pub const __off_t = c_long;
pub const __off64_t = c_long;
pub const __pid_t = c_int;
pub const __fsid_t = extern struct {
    __val: [2]c_int = @import("std").mem.zeroes([2]c_int),
};
pub const __clock_t = c_long;
pub const __rlim_t = c_ulong;
pub const __rlim64_t = c_ulong;
pub const __id_t = c_uint;
pub const __time_t = c_long;
pub const __useconds_t = c_uint;
pub const __suseconds_t = c_long;
pub const __suseconds64_t = c_long;
pub const __daddr_t = c_int;
pub const __key_t = c_int;
pub const __clockid_t = c_int;
pub const __timer_t = ?*anyopaque;
pub const __blksize_t = c_long;
pub const __blkcnt_t = c_long;
pub const __blkcnt64_t = c_long;
pub const __fsblkcnt_t = c_ulong;
pub const __fsblkcnt64_t = c_ulong;
pub const __fsfilcnt_t = c_ulong;
pub const __fsfilcnt64_t = c_ulong;
pub const __fsword_t = c_long;
pub const __ssize_t = c_long;
pub const __syscall_slong_t = c_long;
pub const __syscall_ulong_t = c_ulong;
pub const __loff_t = __off64_t;
pub const __caddr_t = [*c]u8;
pub const __intptr_t = c_long;
pub const __socklen_t = c_uint;
pub const __sig_atomic_t = c_int;
pub const int_least8_t = __int_least8_t;
pub const int_least16_t = __int_least16_t;
pub const int_least32_t = __int_least32_t;
pub const int_least64_t = __int_least64_t;
pub const uint_least8_t = __uint_least8_t;
pub const uint_least16_t = __uint_least16_t;
pub const uint_least32_t = __uint_least32_t;
pub const uint_least64_t = __uint_least64_t;
pub const int_fast8_t = i8;
pub const int_fast16_t = c_long;
pub const int_fast32_t = c_long;
pub const int_fast64_t = c_long;
pub const uint_fast8_t = u8;
pub const uint_fast16_t = c_ulong;
pub const uint_fast32_t = c_ulong;
pub const uint_fast64_t = c_ulong;
pub const intmax_t = __intmax_t;
pub const uintmax_t = __uintmax_t;
pub const struct_ArrowSchema = extern struct {
    format: [*c]const u8 = null,
    name: [*c]const u8 = null,
    metadata: [*c]const u8 = null,
    flags: i64 = 0,
    n_children: i64 = 0,
    children: [*c][*c]struct_ArrowSchema = null,
    dictionary: [*c]struct_ArrowSchema = null,
    release: ?*const fn ([*c]struct_ArrowSchema) callconv(.c) void = null,
    private_data: ?*anyopaque = null,
    pub const ArrowSchemaMove = __root.ArrowSchemaMove;
    pub const ArrowSchemaRelease = __root.ArrowSchemaRelease;
    pub const ArrowSchemaInit = __root.ArrowSchemaInit;
    pub const ArrowSchemaInitFromType = __root.ArrowSchemaInitFromType;
    pub const ArrowSchemaToString = __root.ArrowSchemaToString;
    pub const ArrowSchemaSetType = __root.ArrowSchemaSetType;
    pub const ArrowSchemaSetTypeStruct = __root.ArrowSchemaSetTypeStruct;
    pub const ArrowSchemaSetTypeFixedSize = __root.ArrowSchemaSetTypeFixedSize;
    pub const ArrowSchemaSetTypeDecimal = __root.ArrowSchemaSetTypeDecimal;
    pub const ArrowSchemaSetTypeRunEndEncoded = __root.ArrowSchemaSetTypeRunEndEncoded;
    pub const ArrowSchemaSetTypeDateTime = __root.ArrowSchemaSetTypeDateTime;
    pub const ArrowSchemaSetTypeUnion = __root.ArrowSchemaSetTypeUnion;
    pub const ArrowSchemaDeepCopy = __root.ArrowSchemaDeepCopy;
    pub const ArrowSchemaSetFormat = __root.ArrowSchemaSetFormat;
    pub const ArrowSchemaSetName = __root.ArrowSchemaSetName;
    pub const ArrowSchemaSetMetadata = __root.ArrowSchemaSetMetadata;
    pub const ArrowSchemaAllocateChildren = __root.ArrowSchemaAllocateChildren;
    pub const ArrowSchemaAllocateDictionary = __root.ArrowSchemaAllocateDictionary;
};
pub const struct_ArrowArray = extern struct {
    length: i64 = 0,
    null_count: i64 = 0,
    offset: i64 = 0,
    n_buffers: i64 = 0,
    n_children: i64 = 0,
    buffers: [*c]?*const anyopaque = null,
    children: [*c][*c]struct_ArrowArray = null,
    dictionary: [*c]struct_ArrowArray = null,
    release: ?*const fn ([*c]struct_ArrowArray) callconv(.c) void = null,
    private_data: ?*anyopaque = null,
    pub const ArrowArrayMove = __root.ArrowArrayMove;
    pub const ArrowArrayRelease = __root.ArrowArrayRelease;
    pub const ArrowArrayInitFromType = __root.ArrowArrayInitFromType;
    pub const ArrowArrayInitFromSchema = __root.ArrowArrayInitFromSchema;
    pub const ArrowArrayInitFromArrayView = __root.ArrowArrayInitFromArrayView;
    pub const ArrowArrayAllocateChildren = __root.ArrowArrayAllocateChildren;
    pub const ArrowArrayAllocateDictionary = __root.ArrowArrayAllocateDictionary;
    pub const ArrowArraySetValidityBitmap = __root.ArrowArraySetValidityBitmap;
    pub const ArrowArraySetBuffer = __root.ArrowArraySetBuffer;
    pub const ArrowArrayAddVariadicBuffers = __root.ArrowArrayAddVariadicBuffers;
    pub const ArrowArrayValidityBitmap = __root.ArrowArrayValidityBitmap;
    pub const ArrowArrayBuffer = __root.ArrowArrayBuffer;
    pub const ArrowArrayStartAppending = __root.ArrowArrayStartAppending;
    pub const ArrowArrayReserve = __root.ArrowArrayReserve;
    pub const ArrowArrayAppendNull = __root.ArrowArrayAppendNull;
    pub const ArrowArrayAppendEmpty = __root.ArrowArrayAppendEmpty;
    pub const ArrowArrayAppendInt = __root.ArrowArrayAppendInt;
    pub const ArrowArrayAppendUInt = __root.ArrowArrayAppendUInt;
    pub const ArrowArrayAppendDouble = __root.ArrowArrayAppendDouble;
    pub const ArrowArrayAppendBytes = __root.ArrowArrayAppendBytes;
    pub const ArrowArrayAppendString = __root.ArrowArrayAppendString;
    pub const ArrowArrayAppendInterval = __root.ArrowArrayAppendInterval;
    pub const ArrowArrayAppendDecimal = __root.ArrowArrayAppendDecimal;
    pub const ArrowArrayFinishElement = __root.ArrowArrayFinishElement;
    pub const ArrowArrayFinishUnionElement = __root.ArrowArrayFinishUnionElement;
    pub const ArrowArrayShrinkToFit = __root.ArrowArrayShrinkToFit;
    pub const ArrowArrayFinishBuildingDefault = __root.ArrowArrayFinishBuildingDefault;
    pub const ArrowArrayFinishBuilding = __root.ArrowArrayFinishBuilding;
    pub const _ArrowArrayUnionChildIndex = __root._ArrowArrayUnionChildIndex;
    pub const _ArrowArrayUnionTypeId = __root._ArrowArrayUnionTypeId;
    pub const _ArrowArrayAppendBits = __root._ArrowArrayAppendBits;
    pub const _ArrowArrayAppendEmptyInternal = __root._ArrowArrayAppendEmptyInternal;
    pub const ArrowArrayVariadicBufferCount = __root.ArrowArrayVariadicBufferCount;
    pub const ArrowArrayUnionChildIndex = __root._ArrowArrayUnionChildIndex;
    pub const ArrowArrayUnionTypeId = __root._ArrowArrayUnionTypeId;
    pub const ArrowArrayAppendBits = __root._ArrowArrayAppendBits;
    pub const ArrowArrayAppendEmptyInternal = __root._ArrowArrayAppendEmptyInternal;
};
pub const struct_ArrowArrayStream = extern struct {
    get_schema: ?*const fn ([*c]struct_ArrowArrayStream, out: [*c]struct_ArrowSchema) callconv(.c) c_int = null,
    get_next: ?*const fn ([*c]struct_ArrowArrayStream, out: [*c]struct_ArrowArray) callconv(.c) c_int = null,
    get_last_error: ?*const fn ([*c]struct_ArrowArrayStream) callconv(.c) [*c]const u8 = null,
    release: ?*const fn ([*c]struct_ArrowArrayStream) callconv(.c) void = null,
    private_data: ?*anyopaque = null,
    pub const AdbcErrorFromArrayStream = __root.AdbcErrorFromArrayStream;
    pub const ArrowArrayStreamMove = __root.ArrowArrayStreamMove;
    pub const ArrowArrayStreamGetLastError = __root.ArrowArrayStreamGetLastError;
    pub const ArrowArrayStreamGetSchema = __root.ArrowArrayStreamGetSchema;
    pub const ArrowArrayStreamGetNext = __root.ArrowArrayStreamGetNext;
    pub const ArrowArrayStreamRelease = __root.ArrowArrayStreamRelease;
    pub const ArrowBasicArrayStreamInit = __root.ArrowBasicArrayStreamInit;
    pub const ArrowBasicArrayStreamSetArray = __root.ArrowBasicArrayStreamSetArray;
    pub const ArrowBasicArrayStreamValidate = __root.ArrowBasicArrayStreamValidate;
};
pub const AdbcStatusCode = u8;
pub const struct_AdbcDatabase = extern struct {
    private_data: ?*anyopaque = null,
    private_driver: [*c]struct_AdbcDriver = null,
    pub const AdbcDatabaseNew = __root.AdbcDatabaseNew;
    pub const AdbcDatabaseGetOption = __root.AdbcDatabaseGetOption;
    pub const AdbcDatabaseGetOptionBytes = __root.AdbcDatabaseGetOptionBytes;
    pub const AdbcDatabaseGetOptionDouble = __root.AdbcDatabaseGetOptionDouble;
    pub const AdbcDatabaseGetOptionInt = __root.AdbcDatabaseGetOptionInt;
    pub const AdbcDatabaseSetOption = __root.AdbcDatabaseSetOption;
    pub const AdbcDatabaseSetOptionBytes = __root.AdbcDatabaseSetOptionBytes;
    pub const AdbcDatabaseSetOptionDouble = __root.AdbcDatabaseSetOptionDouble;
    pub const AdbcDatabaseSetOptionInt = __root.AdbcDatabaseSetOptionInt;
    pub const AdbcDatabaseInit = __root.AdbcDatabaseInit;
    pub const AdbcDatabaseRelease = __root.AdbcDatabaseRelease;
};
pub const struct_AdbcConnection = extern struct {
    private_data: ?*anyopaque = null,
    private_driver: [*c]struct_AdbcDriver = null,
    pub const AdbcConnectionNew = __root.AdbcConnectionNew;
    pub const AdbcConnectionSetOption = __root.AdbcConnectionSetOption;
    pub const AdbcConnectionSetOptionBytes = __root.AdbcConnectionSetOptionBytes;
    pub const AdbcConnectionSetOptionInt = __root.AdbcConnectionSetOptionInt;
    pub const AdbcConnectionSetOptionDouble = __root.AdbcConnectionSetOptionDouble;
    pub const AdbcConnectionInit = __root.AdbcConnectionInit;
    pub const AdbcConnectionRelease = __root.AdbcConnectionRelease;
    pub const AdbcConnectionCancel = __root.AdbcConnectionCancel;
    pub const AdbcConnectionGetInfo = __root.AdbcConnectionGetInfo;
    pub const AdbcConnectionGetObjects = __root.AdbcConnectionGetObjects;
    pub const AdbcConnectionGetOption = __root.AdbcConnectionGetOption;
    pub const AdbcConnectionGetOptionBytes = __root.AdbcConnectionGetOptionBytes;
    pub const AdbcConnectionGetOptionInt = __root.AdbcConnectionGetOptionInt;
    pub const AdbcConnectionGetOptionDouble = __root.AdbcConnectionGetOptionDouble;
    pub const AdbcConnectionGetStatistics = __root.AdbcConnectionGetStatistics;
    pub const AdbcConnectionGetStatisticNames = __root.AdbcConnectionGetStatisticNames;
    pub const AdbcConnectionGetTableSchema = __root.AdbcConnectionGetTableSchema;
    pub const AdbcConnectionGetTableTypes = __root.AdbcConnectionGetTableTypes;
    pub const AdbcConnectionReadPartition = __root.AdbcConnectionReadPartition;
    pub const AdbcConnectionCommit = __root.AdbcConnectionCommit;
    pub const AdbcConnectionRollback = __root.AdbcConnectionRollback;
    pub const AdbcStatementNew = __root.AdbcStatementNew;
};
pub const struct_AdbcStatement = extern struct {
    private_data: ?*anyopaque = null,
    private_driver: [*c]struct_AdbcDriver = null,
    pub const AdbcStatementRelease = __root.AdbcStatementRelease;
    pub const AdbcStatementExecuteQuery = __root.AdbcStatementExecuteQuery;
    pub const AdbcStatementExecuteSchema = __root.AdbcStatementExecuteSchema;
    pub const AdbcStatementPrepare = __root.AdbcStatementPrepare;
    pub const AdbcStatementSetSqlQuery = __root.AdbcStatementSetSqlQuery;
    pub const AdbcStatementSetSubstraitPlan = __root.AdbcStatementSetSubstraitPlan;
    pub const AdbcStatementBind = __root.AdbcStatementBind;
    pub const AdbcStatementBindStream = __root.AdbcStatementBindStream;
    pub const AdbcStatementCancel = __root.AdbcStatementCancel;
    pub const AdbcStatementGetOption = __root.AdbcStatementGetOption;
    pub const AdbcStatementGetOptionBytes = __root.AdbcStatementGetOptionBytes;
    pub const AdbcStatementGetOptionInt = __root.AdbcStatementGetOptionInt;
    pub const AdbcStatementGetOptionDouble = __root.AdbcStatementGetOptionDouble;
    pub const AdbcStatementGetParameterSchema = __root.AdbcStatementGetParameterSchema;
    pub const AdbcStatementSetOption = __root.AdbcStatementSetOption;
    pub const AdbcStatementSetOptionBytes = __root.AdbcStatementSetOptionBytes;
    pub const AdbcStatementSetOptionInt = __root.AdbcStatementSetOptionInt;
    pub const AdbcStatementSetOptionDouble = __root.AdbcStatementSetOptionDouble;
    pub const AdbcStatementExecutePartitions = __root.AdbcStatementExecutePartitions;
};
pub const struct_AdbcPartitions = extern struct {
    num_partitions: usize = 0,
    partitions: [*c][*c]const u8 = null,
    partition_lengths: [*c]const usize = null,
    private_data: ?*anyopaque = null,
    release: ?*const fn (partitions: [*c]struct_AdbcPartitions) callconv(.c) void = null,
};
pub const struct_AdbcErrorDetail = extern struct {
    key: [*c]const u8 = null,
    value: [*c]const u8 = null,
    value_length: usize = 0,
};
pub const struct_AdbcDriver = extern struct {
    private_data: ?*anyopaque = null,
    private_manager: ?*anyopaque = null,
    release: ?*const fn (driver: [*c]struct_AdbcDriver, @"error": [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseInit: ?*const fn ([*c]struct_AdbcDatabase, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseNew: ?*const fn ([*c]struct_AdbcDatabase, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseSetOption: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]const u8, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseRelease: ?*const fn ([*c]struct_AdbcDatabase, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionCommit: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetInfo: ?*const fn ([*c]struct_AdbcConnection, [*c]const u32, usize, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetObjects: ?*const fn ([*c]struct_AdbcConnection, c_int, [*c]const u8, [*c]const u8, [*c]const u8, [*c][*c]const u8, [*c]const u8, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetTableSchema: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]const u8, [*c]const u8, [*c]struct_ArrowSchema, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetTableTypes: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionInit: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcDatabase, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionNew: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionSetOption: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]const u8, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionReadPartition: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, usize, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionRelease: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionRollback: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementBind: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowArray, [*c]struct_ArrowSchema, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementBindStream: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementExecuteQuery: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowArrayStream, [*c]i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementExecutePartitions: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowSchema, [*c]struct_AdbcPartitions, [*c]i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementGetParameterSchema: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowSchema, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementNew: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcStatement, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementPrepare: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementRelease: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetOption: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]const u8, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetSqlQuery: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetSubstraitPlan: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ErrorGetDetailCount: ?*const fn (@"error": [*c]const struct_AdbcError) callconv(.c) c_int = null,
    ErrorGetDetail: ?*const fn (@"error": [*c]const struct_AdbcError, index: c_int) callconv(.c) struct_AdbcErrorDetail = null,
    ErrorFromArrayStream: ?*const fn (stream: [*c]struct_ArrowArrayStream, status: [*c]AdbcStatusCode) callconv(.c) [*c]const struct_AdbcError = null,
    DatabaseGetOption: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseGetOptionBytes: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseGetOptionDouble: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseGetOptionInt: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseSetOptionBytes: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, [*c]const u8, usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseSetOptionDouble: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    DatabaseSetOptionInt: ?*const fn ([*c]struct_AdbcDatabase, [*c]const u8, i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionCancel: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetOption: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetOptionBytes: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetOptionDouble: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetOptionInt: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetStatistics: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]const u8, [*c]const u8, u8, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionGetStatisticNames: ?*const fn ([*c]struct_AdbcConnection, [*c]struct_ArrowArrayStream, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionSetOptionBytes: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, [*c]const u8, usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionSetOptionDouble: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    ConnectionSetOptionInt: ?*const fn ([*c]struct_AdbcConnection, [*c]const u8, i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementCancel: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementExecuteSchema: ?*const fn ([*c]struct_AdbcStatement, [*c]struct_ArrowSchema, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementGetOption: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementGetOptionBytes: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]u8, [*c]usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementGetOptionDouble: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementGetOptionInt: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetOptionBytes: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, [*c]const u8, usize, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetOptionDouble: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, f64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
    StatementSetOptionInt: ?*const fn ([*c]struct_AdbcStatement, [*c]const u8, i64, [*c]struct_AdbcError) callconv(.c) AdbcStatusCode = null,
};
pub const struct_AdbcError = extern struct {
    message: [*c]u8 = null,
    vendor_code: i32 = 0,
    sqlstate: [5]u8 = @import("std").mem.zeroes([5]u8),
    release: ?*const fn (@"error": [*c]struct_AdbcError) callconv(.c) void = null,
    private_data: ?*anyopaque = null,
    private_driver: [*c]struct_AdbcDriver = null,
    pub const AdbcErrorGetDetailCount = __root.AdbcErrorGetDetailCount;
    pub const AdbcErrorGetDetail = __root.AdbcErrorGetDetail;
};
pub extern fn AdbcErrorGetDetailCount(@"error": [*c]const struct_AdbcError) c_int;
pub extern fn AdbcErrorGetDetail(@"error": [*c]const struct_AdbcError, index: c_int) struct_AdbcErrorDetail;
pub extern fn AdbcErrorFromArrayStream(stream: [*c]struct_ArrowArrayStream, status: [*c]AdbcStatusCode) [*c]const struct_AdbcError;
pub extern fn AdbcDatabaseNew(database: [*c]struct_AdbcDatabase, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseGetOption(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseGetOptionBytes(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseGetOptionDouble(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseGetOptionInt(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseSetOption(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]const u8, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseSetOptionBytes(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: [*c]const u8, length: usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseSetOptionDouble(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseSetOptionInt(database: [*c]struct_AdbcDatabase, key: [*c]const u8, value: i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseInit(database: [*c]struct_AdbcDatabase, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcDatabaseRelease(database: [*c]struct_AdbcDatabase, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionNew(connection: [*c]struct_AdbcConnection, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionSetOption(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]const u8, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionSetOptionBytes(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]const u8, length: usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionSetOptionInt(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionSetOptionDouble(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionInit(connection: [*c]struct_AdbcConnection, database: [*c]struct_AdbcDatabase, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionRelease(connection: [*c]struct_AdbcConnection, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionCancel(connection: [*c]struct_AdbcConnection, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetInfo(connection: [*c]struct_AdbcConnection, info_codes: [*c]const u32, info_codes_length: usize, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetObjects(connection: [*c]struct_AdbcConnection, depth: c_int, catalog: [*c]const u8, db_schema: [*c]const u8, table_name: [*c]const u8, table_type: [*c][*c]const u8, column_name: [*c]const u8, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetOption(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetOptionBytes(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetOptionInt(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetOptionDouble(connection: [*c]struct_AdbcConnection, key: [*c]const u8, value: [*c]f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetStatistics(connection: [*c]struct_AdbcConnection, catalog: [*c]const u8, db_schema: [*c]const u8, table_name: [*c]const u8, approximate: u8, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetStatisticNames(connection: [*c]struct_AdbcConnection, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetTableSchema(connection: [*c]struct_AdbcConnection, catalog: [*c]const u8, db_schema: [*c]const u8, table_name: [*c]const u8, schema: [*c]struct_ArrowSchema, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionGetTableTypes(connection: [*c]struct_AdbcConnection, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionReadPartition(connection: [*c]struct_AdbcConnection, serialized_partition: [*c]const u8, serialized_length: usize, out: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionCommit(connection: [*c]struct_AdbcConnection, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcConnectionRollback(connection: [*c]struct_AdbcConnection, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementNew(connection: [*c]struct_AdbcConnection, statement: [*c]struct_AdbcStatement, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementRelease(statement: [*c]struct_AdbcStatement, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementExecuteQuery(statement: [*c]struct_AdbcStatement, out: [*c]struct_ArrowArrayStream, rows_affected: [*c]i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementExecuteSchema(statement: [*c]struct_AdbcStatement, schema: [*c]struct_ArrowSchema, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementPrepare(statement: [*c]struct_AdbcStatement, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetSqlQuery(statement: [*c]struct_AdbcStatement, query: [*c]const u8, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetSubstraitPlan(statement: [*c]struct_AdbcStatement, plan: [*c]const u8, length: usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementBind(statement: [*c]struct_AdbcStatement, values: [*c]struct_ArrowArray, schema: [*c]struct_ArrowSchema, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementBindStream(statement: [*c]struct_AdbcStatement, stream: [*c]struct_ArrowArrayStream, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementCancel(statement: [*c]struct_AdbcStatement, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementGetOption(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementGetOptionBytes(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]u8, length: [*c]usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementGetOptionInt(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementGetOptionDouble(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementGetParameterSchema(statement: [*c]struct_AdbcStatement, schema: [*c]struct_ArrowSchema, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetOption(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]const u8, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetOptionBytes(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: [*c]const u8, length: usize, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetOptionInt(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementSetOptionDouble(statement: [*c]struct_AdbcStatement, key: [*c]const u8, value: f64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub extern fn AdbcStatementExecutePartitions(statement: [*c]struct_AdbcStatement, schema: [*c]struct_ArrowSchema, partitions: [*c]struct_AdbcPartitions, rows_affected: [*c]i64, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub const AdbcDriverInitFunc = ?*const fn (version: c_int, driver: ?*anyopaque, @"error": [*c]struct_AdbcError) callconv(.c) AdbcStatusCode;
pub extern fn AdbcDriverSqliteInit(version: c_int, raw_driver: ?*anyopaque, @"error": [*c]struct_AdbcError) AdbcStatusCode;
pub const div_t = extern struct {
    quot: c_int = 0,
    rem: c_int = 0,
};
pub const ldiv_t = extern struct {
    quot: c_long = 0,
    rem: c_long = 0,
};
pub const lldiv_t = extern struct {
    quot: c_longlong = 0,
    rem: c_longlong = 0,
};
pub extern fn __ctype_get_mb_cur_max() usize;
pub extern fn atof(__nptr: [*c]const u8) f64;
pub extern fn atoi(__nptr: [*c]const u8) c_int;
pub extern fn atol(__nptr: [*c]const u8) c_long;
pub extern fn atoll(__nptr: [*c]const u8) c_longlong;
pub extern fn strtod(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) f64;
pub extern fn strtof(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) f32;
pub extern fn strtold(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8) c_longdouble;
pub extern fn strtol(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_long;
pub extern fn strtoul(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulong;
pub extern fn strtoq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtouq(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn strtoll(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_longlong;
pub extern fn strtoull(noalias __nptr: [*c]const u8, noalias __endptr: [*c][*c]u8, __base: c_int) c_ulonglong;
pub extern fn l64a(__n: c_long) [*c]u8;
pub extern fn a64l(__s: [*c]const u8) c_long;
pub const u_char = __u_char;
pub const u_short = __u_short;
pub const u_int = __u_int;
pub const u_long = __u_long;
pub const quad_t = __quad_t;
pub const u_quad_t = __u_quad_t;
pub const fsid_t = __fsid_t;
pub const loff_t = __loff_t;
pub const ino_t = __ino_t;
pub const dev_t = __dev_t;
pub const gid_t = __gid_t;
pub const mode_t = __mode_t;
pub const nlink_t = __nlink_t;
pub const uid_t = __uid_t;
pub const off_t = __off_t;
pub const pid_t = __pid_t;
pub const id_t = __id_t;
pub const daddr_t = __daddr_t;
pub const caddr_t = __caddr_t;
pub const key_t = __key_t;
pub const clock_t = __clock_t;
pub const clockid_t = __clockid_t;
pub const time_t = __time_t;
pub const timer_t = __timer_t;
pub const ulong = c_ulong;
pub const ushort = c_ushort;
pub const uint = c_uint;
pub const u_int8_t = __uint8_t;
pub const u_int16_t = __uint16_t;
pub const u_int32_t = __uint32_t;
pub const u_int64_t = __uint64_t;
pub const register_t = c_int;
pub fn __bswap_16(arg___bsx: __uint16_t) callconv(.c) __uint16_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @byteSwap(@as(__uint16_t, __bsx));
}
pub fn __bswap_32(arg___bsx: __uint32_t) callconv(.c) __uint32_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @bitCast(@as(c_int, @byteSwap(@as(c_int, @bitCast(@as(c_uint, @truncate(__bsx)))))));
}
pub fn __bswap_64(arg___bsx: __uint64_t) callconv(.c) __uint64_t {
    var __bsx = arg___bsx;
    _ = &__bsx;
    return @bitCast(@as(c_long, @byteSwap(@as(c_long, @bitCast(@as(c_ulong, @truncate(__bsx)))))));
}
pub fn __uint16_identity(arg___x: __uint16_t) callconv(.c) __uint16_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub fn __uint32_identity(arg___x: __uint32_t) callconv(.c) __uint32_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub fn __uint64_identity(arg___x: __uint64_t) callconv(.c) __uint64_t {
    var __x = arg___x;
    _ = &__x;
    return __x;
}
pub const __sigset_t = extern struct {
    __val: [16]c_ulong = @import("std").mem.zeroes([16]c_ulong),
};
pub const sigset_t = __sigset_t;
pub const struct_timeval = extern struct {
    tv_sec: __time_t = 0,
    tv_usec: __suseconds_t = 0,
};
pub const struct_timespec = extern struct {
    tv_sec: __time_t = 0,
    tv_nsec: __syscall_slong_t = 0,
    pub const nanosleep = __root.nanosleep;
    pub const timespec_get = __root.timespec_get;
    pub const get = __root.timespec_get;
};
pub const suseconds_t = __suseconds_t;
pub const __fd_mask = c_long;
pub const fd_set = extern struct {
    __fds_bits: [16]__fd_mask = @import("std").mem.zeroes([16]__fd_mask),
};
pub const fd_mask = __fd_mask;
pub extern fn select(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]struct_timeval) c_int;
pub extern fn pselect(__nfds: c_int, noalias __readfds: [*c]fd_set, noalias __writefds: [*c]fd_set, noalias __exceptfds: [*c]fd_set, noalias __timeout: [*c]const struct_timespec, noalias __sigmask: [*c]const __sigset_t) c_int;
pub const blksize_t = __blksize_t;
pub const blkcnt_t = __blkcnt_t;
pub const fsblkcnt_t = __fsblkcnt_t;
pub const fsfilcnt_t = __fsfilcnt_t;
const struct_unnamed_1 = extern struct {
    __low: c_uint = 0,
    __high: c_uint = 0,
};
pub const __atomic_wide_counter = extern union {
    __value64: c_ulonglong,
    __value32: struct_unnamed_1,
};
pub const struct___pthread_internal_list = extern struct {
    __prev: [*c]struct___pthread_internal_list = null,
    __next: [*c]struct___pthread_internal_list = null,
};
pub const __pthread_list_t = struct___pthread_internal_list;
pub const struct___pthread_internal_slist = extern struct {
    __next: [*c]struct___pthread_internal_slist = null,
};
pub const __pthread_slist_t = struct___pthread_internal_slist;
pub const struct___pthread_mutex_s = extern struct {
    __lock: c_int = 0,
    __count: c_uint = 0,
    __owner: c_int = 0,
    __nusers: c_uint = 0,
    __kind: c_int = 0,
    __spins: c_short = 0,
    __elision: c_short = 0,
    __list: __pthread_list_t = @import("std").mem.zeroes(__pthread_list_t),
};
pub const struct___pthread_rwlock_arch_t = extern struct {
    __readers: c_uint = 0,
    __writers: c_uint = 0,
    __wrphase_futex: c_uint = 0,
    __writers_futex: c_uint = 0,
    __pad3: c_uint = 0,
    __pad4: c_uint = 0,
    __cur_writer: c_int = 0,
    __shared: c_int = 0,
    __rwelision: i8 = 0,
    __pad1: [7]u8 = @import("std").mem.zeroes([7]u8),
    __pad2: c_ulong = 0,
    __flags: c_uint = 0,
};
pub const struct___pthread_cond_s = extern struct {
    __wseq: __atomic_wide_counter = @import("std").mem.zeroes(__atomic_wide_counter),
    __g1_start: __atomic_wide_counter = @import("std").mem.zeroes(__atomic_wide_counter),
    __g_size: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    __g1_orig_size: c_uint = 0,
    __wrefs: c_uint = 0,
    __g_signals: [2]c_uint = @import("std").mem.zeroes([2]c_uint),
    __unused_initialized_1: c_uint = 0,
    __unused_initialized_2: c_uint = 0,
};
pub const __tss_t = c_uint;
pub const __thrd_t = c_ulong;
pub const __once_flag = extern struct {
    __data: c_int = 0,
};
pub const pthread_t = c_ulong;
pub const pthread_mutexattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_condattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub const pthread_key_t = c_uint;
pub const pthread_once_t = c_int;
pub const union_pthread_attr_t = extern union {
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_attr_t = union_pthread_attr_t;
pub const pthread_mutex_t = extern union {
    __data: struct___pthread_mutex_s,
    __size: [40]u8,
    __align: c_long,
};
pub const pthread_cond_t = extern union {
    __data: struct___pthread_cond_s,
    __size: [48]u8,
    __align: c_longlong,
};
pub const pthread_rwlock_t = extern union {
    __data: struct___pthread_rwlock_arch_t,
    __size: [56]u8,
    __align: c_long,
};
pub const pthread_rwlockattr_t = extern union {
    __size: [8]u8,
    __align: c_long,
};
pub const pthread_spinlock_t = c_int;
pub const pthread_barrier_t = extern union {
    __size: [32]u8,
    __align: c_long,
};
pub const pthread_barrierattr_t = extern union {
    __size: [4]u8,
    __align: c_int,
};
pub extern fn random() c_long;
pub extern fn srandom(__seed: c_uint) void;
pub extern fn initstate(__seed: c_uint, __statebuf: [*c]u8, __statelen: usize) [*c]u8;
pub extern fn setstate(__statebuf: [*c]u8) [*c]u8;
pub const struct_random_data = extern struct {
    fptr: [*c]i32 = null,
    rptr: [*c]i32 = null,
    state: [*c]i32 = null,
    rand_type: c_int = 0,
    rand_deg: c_int = 0,
    rand_sep: c_int = 0,
    end_ptr: [*c]i32 = null,
    pub const random_r = __root.random_r;
    pub const r = __root.random_r;
};
pub extern fn random_r(noalias __buf: [*c]struct_random_data, noalias __result: [*c]i32) c_int;
pub extern fn srandom_r(__seed: c_uint, __buf: [*c]struct_random_data) c_int;
pub extern fn initstate_r(__seed: c_uint, noalias __statebuf: [*c]u8, __statelen: usize, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn setstate_r(noalias __statebuf: [*c]u8, noalias __buf: [*c]struct_random_data) c_int;
pub extern fn rand() c_int;
pub extern fn srand(__seed: c_uint) void;
pub extern fn rand_r(__seed: [*c]c_uint) c_int;
pub extern fn drand48() f64;
pub extern fn erand48(__xsubi: [*c]c_ushort) f64;
pub extern fn lrand48() c_long;
pub extern fn nrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn mrand48() c_long;
pub extern fn jrand48(__xsubi: [*c]c_ushort) c_long;
pub extern fn srand48(__seedval: c_long) void;
pub extern fn seed48(__seed16v: [*c]c_ushort) [*c]c_ushort;
pub extern fn lcong48(__param: [*c]c_ushort) void;
pub const struct_drand48_data = extern struct {
    __x: [3]c_ushort = @import("std").mem.zeroes([3]c_ushort),
    __old_x: [3]c_ushort = @import("std").mem.zeroes([3]c_ushort),
    __c: c_ushort = 0,
    __init: c_ushort = 0,
    __a: c_ulonglong = 0,
    pub const drand48_r = __root.drand48_r;
    pub const lrand48_r = __root.lrand48_r;
    pub const mrand48_r = __root.mrand48_r;
    pub const r = __root.drand48_r;
};
pub extern fn drand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn erand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]f64) c_int;
pub extern fn lrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn nrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn mrand48_r(noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn jrand48_r(__xsubi: [*c]c_ushort, noalias __buffer: [*c]struct_drand48_data, noalias __result: [*c]c_long) c_int;
pub extern fn srand48_r(__seedval: c_long, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn seed48_r(__seed16v: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn lcong48_r(__param: [*c]c_ushort, __buffer: [*c]struct_drand48_data) c_int;
pub extern fn arc4random() __uint32_t;
pub extern fn arc4random_buf(__buf: ?*anyopaque, __size: usize) void;
pub extern fn arc4random_uniform(__upper_bound: __uint32_t) __uint32_t;
pub extern fn malloc(__size: usize) ?*anyopaque;
pub extern fn calloc(__nmemb: usize, __size: usize) ?*anyopaque;
pub extern fn realloc(__ptr: ?*anyopaque, __size: usize) ?*anyopaque;
pub extern fn free(__ptr: ?*anyopaque) void;
pub extern fn reallocarray(__ptr: ?*anyopaque, __nmemb: usize, __size: usize) ?*anyopaque;
pub extern fn alloca(__size: usize) ?*anyopaque;
pub extern fn valloc(__size: usize) ?*anyopaque;
pub extern fn posix_memalign(__memptr: [*c]?*anyopaque, __alignment: usize, __size: usize) c_int;
pub extern fn aligned_alloc(__alignment: usize, __size: usize) ?*anyopaque;
pub extern fn abort() noreturn;
pub extern fn atexit(__func: ?*const fn () callconv(.c) void) c_int;
pub extern fn at_quick_exit(__func: ?*const fn () callconv(.c) void) c_int;
pub extern fn on_exit(__func: ?*const fn (__status: c_int, __arg: ?*anyopaque) callconv(.c) void, __arg: ?*anyopaque) c_int;
pub extern fn exit(__status: c_int) noreturn;
pub extern fn quick_exit(__status: c_int) noreturn;
pub extern fn _Exit(__status: c_int) noreturn;
pub extern fn getenv(__name: [*c]const u8) [*c]u8;
pub extern fn putenv(__string: [*c]u8) c_int;
pub extern fn setenv(__name: [*c]const u8, __value: [*c]const u8, __replace: c_int) c_int;
pub extern fn unsetenv(__name: [*c]const u8) c_int;
pub extern fn clearenv() c_int;
pub extern fn mktemp(__template: [*c]u8) [*c]u8;
pub extern fn mkstemp(__template: [*c]u8) c_int;
pub extern fn mkstemps(__template: [*c]u8, __suffixlen: c_int) c_int;
pub extern fn mkdtemp(__template: [*c]u8) [*c]u8;
pub extern fn system(__command: [*c]const u8) c_int;
pub extern fn realpath(noalias __name: [*c]const u8, noalias __resolved: [*c]u8) [*c]u8;
pub const __compar_fn_t = ?*const fn (?*const anyopaque, ?*const anyopaque) callconv(.c) c_int;
pub extern fn bsearch(__key: ?*const anyopaque, __base: ?*const anyopaque, __nmemb: usize, __size: usize, __compar: __compar_fn_t) ?*anyopaque;
pub extern fn qsort(__base: ?*anyopaque, __nmemb: usize, __size: usize, __compar: __compar_fn_t) void;
pub extern fn abs(__x: c_int) c_int;
pub extern fn labs(__x: c_long) c_long;
pub extern fn llabs(__x: c_longlong) c_longlong;
pub extern fn div(__numer: c_int, __denom: c_int) div_t;
pub extern fn ldiv(__numer: c_long, __denom: c_long) ldiv_t;
pub extern fn lldiv(__numer: c_longlong, __denom: c_longlong) lldiv_t;
pub extern fn ecvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn fcvt(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn gcvt(__value: f64, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn qecvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qfcvt(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int) [*c]u8;
pub extern fn qgcvt(__value: c_longdouble, __ndigit: c_int, __buf: [*c]u8) [*c]u8;
pub extern fn ecvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn fcvt_r(__value: f64, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qecvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn qfcvt_r(__value: c_longdouble, __ndigit: c_int, noalias __decpt: [*c]c_int, noalias __sign: [*c]c_int, noalias __buf: [*c]u8, __len: usize) c_int;
pub extern fn mblen(__s: [*c]const u8, __n: usize) c_int;
pub extern fn mbtowc(noalias __pwc: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) c_int;
pub extern fn wctomb(__s: [*c]u8, __wchar: wchar_t) c_int;
pub extern fn mbstowcs(noalias __pwcs: [*c]wchar_t, noalias __s: [*c]const u8, __n: usize) usize;
pub extern fn wcstombs(noalias __s: [*c]u8, noalias __pwcs: [*c]const wchar_t, __n: usize) usize;
pub extern fn rpmatch(__response: [*c]const u8) c_int;
pub extern fn getsubopt(noalias __optionp: [*c][*c]u8, noalias __tokens: [*c]const [*c]u8, noalias __valuep: [*c][*c]u8) c_int;
pub extern fn getloadavg(__loadavg: [*c]f64, __nelem: c_int) c_int;
pub extern fn memcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn memmove(__dest: ?*anyopaque, __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn memccpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn memset(__s: ?*anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn memcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn __memcmpeq(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn memchr(__s: ?*const anyopaque, __c: c_int, __n: usize) ?*anyopaque;
pub extern fn strcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn strncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strcat(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn strncat(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strcmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize) c_int;
pub extern fn strcoll(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strxfrm(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub const struct___locale_data_2 = opaque {};
pub const struct___locale_struct = extern struct {
    __locales: [13]?*struct___locale_data_2 = @import("std").mem.zeroes([13]?*struct___locale_data_2),
    __ctype_b: [*c]const c_ushort = null,
    __ctype_tolower: [*c]const c_int = null,
    __ctype_toupper: [*c]const c_int = null,
    __names: [13][*c]const u8 = @import("std").mem.zeroes([13][*c]const u8),
};
pub const __locale_t = [*c]struct___locale_struct;
pub const locale_t = __locale_t;
pub extern fn strcoll_l(__s1: [*c]const u8, __s2: [*c]const u8, __l: locale_t) c_int;
pub extern fn strxfrm_l(__dest: [*c]u8, __src: [*c]const u8, __n: usize, __l: locale_t) usize;
pub extern fn strdup(__s: [*c]const u8) [*c]u8;
pub extern fn strndup(__string: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strrchr(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strchrnul(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn strcspn(__s: [*c]const u8, __reject: [*c]const u8) usize;
pub extern fn strspn(__s: [*c]const u8, __accept: [*c]const u8) usize;
pub extern fn strpbrk(__s: [*c]const u8, __accept: [*c]const u8) [*c]u8;
pub extern fn strstr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn strtok(noalias __s: [*c]u8, noalias __delim: [*c]const u8) [*c]u8;
pub extern fn __strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strtok_r(noalias __s: [*c]u8, noalias __delim: [*c]const u8, noalias __save_ptr: [*c][*c]u8) [*c]u8;
pub extern fn strcasestr(__haystack: [*c]const u8, __needle: [*c]const u8) [*c]u8;
pub extern fn memmem(__haystack: ?*const anyopaque, __haystacklen: usize, __needle: ?*const anyopaque, __needlelen: usize) ?*anyopaque;
pub extern fn __mempcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn mempcpy(noalias __dest: ?*anyopaque, noalias __src: ?*const anyopaque, __n: usize) ?*anyopaque;
pub extern fn strlen(__s: [*c]const u8) usize;
pub extern fn strnlen(__string: [*c]const u8, __maxlen: usize) usize;
pub extern fn strerror(__errnum: c_int) [*c]u8;
pub extern fn strerror_r(__errnum: c_int, __buf: [*c]u8, __buflen: usize) c_int;
pub extern fn strerror_l(__errnum: c_int, __l: locale_t) [*c]u8;
pub extern fn bcmp(__s1: ?*const anyopaque, __s2: ?*const anyopaque, __n: usize) c_int;
pub extern fn bcopy(__src: ?*const anyopaque, __dest: ?*anyopaque, __n: usize) void;
pub extern fn bzero(__s: ?*anyopaque, __n: usize) void;
pub extern fn index(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn rindex(__s: [*c]const u8, __c: c_int) [*c]u8;
pub extern fn ffs(__i: c_int) c_int;
pub extern fn ffsl(__l: c_long) c_int;
pub extern fn ffsll(__ll: c_longlong) c_int;
pub extern fn strcasecmp(__s1: [*c]const u8, __s2: [*c]const u8) c_int;
pub extern fn strncasecmp(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize) c_int;
pub extern fn strcasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __loc: locale_t) c_int;
pub extern fn strncasecmp_l(__s1: [*c]const u8, __s2: [*c]const u8, __n: usize, __loc: locale_t) c_int;
pub extern fn explicit_bzero(__s: ?*anyopaque, __n: usize) void;
pub extern fn strsep(noalias __stringp: [*c][*c]u8, noalias __delim: [*c]const u8) [*c]u8;
pub extern fn strsignal(__sig: c_int) [*c]u8;
pub extern fn __stpcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn stpcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8) [*c]u8;
pub extern fn __stpncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn stpncpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) [*c]u8;
pub extern fn strlcpy(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub extern fn strlcat(noalias __dest: [*c]u8, noalias __src: [*c]const u8, __n: usize) usize;
pub const ArrowErrorCode = c_int;
pub const struct_ArrowError = extern struct {
    message: [1024]u8 = @import("std").mem.zeroes([1024]u8),
    pub const ArrowErrorInit = __root.ArrowErrorInit;
    pub const ArrowErrorMessage = __root.ArrowErrorMessage;
    pub const ArrowErrorSetString = __root.ArrowErrorSetString;
    pub const ArrowErrorSet = __root.ArrowErrorSet;
};
pub fn ArrowErrorInit(arg_error: [*c]struct_ArrowError) callconv(.c) void {
    var @"error" = arg_error;
    _ = &@"error";
    if (@as(?*anyopaque, @ptrCast(@alignCast(@"error"))) != @as(?*anyopaque, null)) {
        @"error".*.message[@as(c_int, 0)] = '\x00';
    }
}
pub fn ArrowErrorMessage(arg_error: [*c]struct_ArrowError) callconv(.c) [*c]const u8 {
    var @"error" = arg_error;
    _ = &@"error";
    if (@as(?*anyopaque, @ptrCast(@alignCast(@"error"))) == @as(?*anyopaque, null)) {
        return "";
    } else {
        return @ptrCast(@alignCast(&@"error".*.message));
    }
}
pub fn ArrowErrorSetString(arg_error: [*c]struct_ArrowError, arg_src: [*c]const u8) callconv(.c) void {
    var @"error" = arg_error;
    _ = &@"error";
    var src = arg_src;
    _ = &src;
    if (@as(?*anyopaque, @ptrCast(@alignCast(@"error"))) == @as(?*anyopaque, null)) {
        return;
    }
    var src_len: i64 = @bitCast(@as(c_ulong, @truncate(strlen(src))));
    _ = &src_len;
    if (src_len >= @as(i64, @bitCast(@as(c_ulong, @truncate(@sizeOf(@TypeOf(@"error".*.message))))))) {
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u8, @ptrCast(@alignCast(&@"error".*.message))))), @ptrCast(@alignCast(src)), @sizeOf(@TypeOf(@"error".*.message)) -% @as(c_ulong, 1));
        @"error".*.message[@sizeOf(@TypeOf(@"error".*.message)) -% @as(c_ulong, 1)] = '\x00';
    } else {
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u8, @ptrCast(@alignCast(&@"error".*.message))))), @ptrCast(@alignCast(src)), @bitCast(@as(c_long, src_len)));
        @"error".*.message[@bitCast(@as(isize, @intCast(src_len)))] = '\x00';
    }
}
pub fn ArrowSchemaMove(arg_src: [*c]struct_ArrowSchema, arg_dst: [*c]struct_ArrowSchema) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    _ = memcpy(@ptrCast(@alignCast(dst)), @ptrCast(@alignCast(src)), @sizeOf(struct_ArrowSchema));
    src.*.release = null;
}
pub fn ArrowSchemaRelease(arg_schema: [*c]struct_ArrowSchema) callconv(.c) void {
    var schema = arg_schema;
    _ = &schema;
    schema.*.release.?(schema);
}
pub fn ArrowArrayMove(arg_src: [*c]struct_ArrowArray, arg_dst: [*c]struct_ArrowArray) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    _ = memcpy(@ptrCast(@alignCast(dst)), @ptrCast(@alignCast(src)), @sizeOf(struct_ArrowArray));
    src.*.release = null;
}
pub fn ArrowArrayRelease(arg_array: [*c]struct_ArrowArray) callconv(.c) void {
    var array = arg_array;
    _ = &array;
    array.*.release.?(array);
}
pub fn ArrowArrayStreamMove(arg_src: [*c]struct_ArrowArrayStream, arg_dst: [*c]struct_ArrowArrayStream) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    _ = memcpy(@ptrCast(@alignCast(dst)), @ptrCast(@alignCast(src)), @sizeOf(struct_ArrowArrayStream));
    src.*.release = null;
}
pub fn ArrowArrayStreamGetLastError(arg_array_stream: [*c]struct_ArrowArrayStream) callconv(.c) [*c]const u8 {
    var array_stream = arg_array_stream;
    _ = &array_stream;
    var value: [*c]const u8 = array_stream.*.get_last_error.?(array_stream);
    _ = &value;
    if (@as(?*anyopaque, @ptrCast(@alignCast(@constCast(value)))) == @as(?*anyopaque, null)) {
        return "";
    } else {
        return value;
    }
}
pub fn ArrowArrayStreamGetSchema(arg_array_stream: [*c]struct_ArrowArrayStream, arg_out: [*c]struct_ArrowSchema, arg_error: [*c]struct_ArrowError) callconv(.c) ArrowErrorCode {
    var array_stream = arg_array_stream;
    _ = &array_stream;
    var out = arg_out;
    _ = &out;
    var @"error" = arg_error;
    _ = &@"error";
    var result: c_int = array_stream.*.get_schema.?(array_stream, out);
    _ = &result;
    if ((result != NANOARROW_OK) and (@as(?*anyopaque, @ptrCast(@alignCast(@"error"))) != @as(?*anyopaque, null))) {
        ArrowErrorSetString(@"error", ArrowArrayStreamGetLastError(array_stream));
    }
    return result;
}
pub fn ArrowArrayStreamGetNext(arg_array_stream: [*c]struct_ArrowArrayStream, arg_out: [*c]struct_ArrowArray, arg_error: [*c]struct_ArrowError) callconv(.c) ArrowErrorCode {
    var array_stream = arg_array_stream;
    _ = &array_stream;
    var out = arg_out;
    _ = &out;
    var @"error" = arg_error;
    _ = &@"error";
    var result: c_int = array_stream.*.get_next.?(array_stream, out);
    _ = &result;
    if ((result != NANOARROW_OK) and (@as(?*anyopaque, @ptrCast(@alignCast(@"error"))) != @as(?*anyopaque, null))) {
        ArrowErrorSetString(@"error", ArrowArrayStreamGetLastError(array_stream));
    }
    return result;
}
pub fn ArrowArrayStreamRelease(arg_array_stream: [*c]struct_ArrowArrayStream) callconv(.c) void {
    var array_stream = arg_array_stream;
    _ = &array_stream;
    array_stream.*.release.?(array_stream);
}
pub fn _ArrowIsLittleEndian() callconv(.c) u8 {
    var check: u32 = 1;
    _ = &check;
    var first_byte: u8 = undefined;
    _ = &first_byte;
    _ = memcpy(@ptrCast(@alignCast(&first_byte)), @ptrCast(@alignCast(&check)), @sizeOf(u8));
    return first_byte;
}
pub const NANOARROW_TYPE_UNINITIALIZED: c_int = 0;
pub const NANOARROW_TYPE_NA: c_int = 1;
pub const NANOARROW_TYPE_BOOL: c_int = 2;
pub const NANOARROW_TYPE_UINT8: c_int = 3;
pub const NANOARROW_TYPE_INT8: c_int = 4;
pub const NANOARROW_TYPE_UINT16: c_int = 5;
pub const NANOARROW_TYPE_INT16: c_int = 6;
pub const NANOARROW_TYPE_UINT32: c_int = 7;
pub const NANOARROW_TYPE_INT32: c_int = 8;
pub const NANOARROW_TYPE_UINT64: c_int = 9;
pub const NANOARROW_TYPE_INT64: c_int = 10;
pub const NANOARROW_TYPE_HALF_FLOAT: c_int = 11;
pub const NANOARROW_TYPE_FLOAT: c_int = 12;
pub const NANOARROW_TYPE_DOUBLE: c_int = 13;
pub const NANOARROW_TYPE_STRING: c_int = 14;
pub const NANOARROW_TYPE_BINARY: c_int = 15;
pub const NANOARROW_TYPE_FIXED_SIZE_BINARY: c_int = 16;
pub const NANOARROW_TYPE_DATE32: c_int = 17;
pub const NANOARROW_TYPE_DATE64: c_int = 18;
pub const NANOARROW_TYPE_TIMESTAMP: c_int = 19;
pub const NANOARROW_TYPE_TIME32: c_int = 20;
pub const NANOARROW_TYPE_TIME64: c_int = 21;
pub const NANOARROW_TYPE_INTERVAL_MONTHS: c_int = 22;
pub const NANOARROW_TYPE_INTERVAL_DAY_TIME: c_int = 23;
pub const NANOARROW_TYPE_DECIMAL128: c_int = 24;
pub const NANOARROW_TYPE_DECIMAL256: c_int = 25;
pub const NANOARROW_TYPE_LIST: c_int = 26;
pub const NANOARROW_TYPE_STRUCT: c_int = 27;
pub const NANOARROW_TYPE_SPARSE_UNION: c_int = 28;
pub const NANOARROW_TYPE_DENSE_UNION: c_int = 29;
pub const NANOARROW_TYPE_DICTIONARY: c_int = 30;
pub const NANOARROW_TYPE_MAP: c_int = 31;
pub const NANOARROW_TYPE_EXTENSION: c_int = 32;
pub const NANOARROW_TYPE_FIXED_SIZE_LIST: c_int = 33;
pub const NANOARROW_TYPE_DURATION: c_int = 34;
pub const NANOARROW_TYPE_LARGE_STRING: c_int = 35;
pub const NANOARROW_TYPE_LARGE_BINARY: c_int = 36;
pub const NANOARROW_TYPE_LARGE_LIST: c_int = 37;
pub const NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO: c_int = 38;
pub const NANOARROW_TYPE_RUN_END_ENCODED: c_int = 39;
pub const NANOARROW_TYPE_BINARY_VIEW: c_int = 40;
pub const NANOARROW_TYPE_STRING_VIEW: c_int = 41;
pub const NANOARROW_TYPE_DECIMAL32: c_int = 42;
pub const NANOARROW_TYPE_DECIMAL64: c_int = 43;
pub const NANOARROW_TYPE_LIST_VIEW: c_int = 44;
pub const NANOARROW_TYPE_LARGE_LIST_VIEW: c_int = 45;
pub const enum_ArrowType = c_uint;
pub fn ArrowTypeString(arg_type: enum_ArrowType) callconv(.c) [*c]const u8 {
    var @"type" = arg_type;
    _ = &@"type";
    while (true) {
        switch (@"type") {
            @as(enum_ArrowType, NANOARROW_TYPE_NA) => {
                return "na";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                return "bool";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                return "uint8";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                return "int8";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT16) => {
                return "uint16";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT16) => {
                return "int16";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT32) => {
                return "uint32";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT32) => {
                return "int32";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64) => {
                return "uint64";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT64) => {
                return "int64";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                return "half_float";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                return "float";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                return "double";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRING) => {
                return "string";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY) => {
                return "binary";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_BINARY) => {
                return "fixed_size_binary";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DATE32) => {
                return "date32";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DATE64) => {
                return "date64";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_TIMESTAMP) => {
                return "timestamp";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_TIME32) => {
                return "time32";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_TIME64) => {
                return "time64";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS) => {
                return "interval_months";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_DAY_TIME) => {
                return "interval_day_time";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL32) => {
                return "decimal32";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL64) => {
                return "decimal64";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL128) => {
                return "decimal128";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL256) => {
                return "decimal256";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LIST) => {
                return "list";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRUCT) => {
                return "struct";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                return "sparse_union";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION) => {
                return "dense_union";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DICTIONARY) => {
                return "dictionary";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_MAP) => {
                return "map";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_EXTENSION) => {
                return "extension";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_LIST) => {
                return "fixed_size_list";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DURATION) => {
                return "duration";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_STRING) => {
                return "large_string";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_BINARY) => {
                return "large_binary";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST) => {
                return "large_list";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO) => {
                return "interval_month_day_nano";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_RUN_END_ENCODED) => {
                return "run_end_encoded";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW) => {
                return "binary_view";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                return "string_view";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LIST_VIEW) => {
                return "list_view";
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST_VIEW) => {
                return "large_list_view";
            },
            else => {
                return null;
            },
        }
        break;
    }
    return undefined;
}
pub const NANOARROW_TIME_UNIT_SECOND: c_int = 0;
pub const NANOARROW_TIME_UNIT_MILLI: c_int = 1;
pub const NANOARROW_TIME_UNIT_MICRO: c_int = 2;
pub const NANOARROW_TIME_UNIT_NANO: c_int = 3;
pub const enum_ArrowTimeUnit = c_uint;
pub const NANOARROW_VALIDATION_LEVEL_NONE: c_int = 0;
pub const NANOARROW_VALIDATION_LEVEL_MINIMAL: c_int = 1;
pub const NANOARROW_VALIDATION_LEVEL_DEFAULT: c_int = 2;
pub const NANOARROW_VALIDATION_LEVEL_FULL: c_int = 3;
pub const enum_ArrowValidationLevel = c_uint;
pub const NANOARROW_COMPARE_IDENTICAL: c_int = 0;
pub const enum_ArrowCompareLevel = c_uint;
pub fn ArrowTimeUnitString(arg_time_unit: enum_ArrowTimeUnit) callconv(.c) [*c]const u8 {
    var time_unit = arg_time_unit;
    _ = &time_unit;
    while (true) {
        switch (time_unit) {
            @as(enum_ArrowTimeUnit, NANOARROW_TIME_UNIT_SECOND) => {
                return "s";
            },
            @as(enum_ArrowTimeUnit, NANOARROW_TIME_UNIT_MILLI) => {
                return "ms";
            },
            @as(enum_ArrowTimeUnit, NANOARROW_TIME_UNIT_MICRO) => {
                return "us";
            },
            @as(enum_ArrowTimeUnit, NANOARROW_TIME_UNIT_NANO) => {
                return "ns";
            },
            else => {
                return null;
            },
        }
        break;
    }
    return undefined;
}
pub const NANOARROW_BUFFER_TYPE_NONE: c_int = 0;
pub const NANOARROW_BUFFER_TYPE_VALIDITY: c_int = 1;
pub const NANOARROW_BUFFER_TYPE_TYPE_ID: c_int = 2;
pub const NANOARROW_BUFFER_TYPE_UNION_OFFSET: c_int = 3;
pub const NANOARROW_BUFFER_TYPE_DATA_OFFSET: c_int = 4;
pub const NANOARROW_BUFFER_TYPE_DATA: c_int = 5;
pub const NANOARROW_BUFFER_TYPE_VARIADIC_DATA: c_int = 6;
pub const NANOARROW_BUFFER_TYPE_VARIADIC_SIZE: c_int = 7;
pub const NANOARROW_BUFFER_TYPE_VIEW_OFFSET: c_int = 8;
pub const NANOARROW_BUFFER_TYPE_SIZE: c_int = 9;
pub const enum_ArrowBufferType = c_uint;
pub const struct_ArrowStringView = extern struct {
    data: [*c]const u8 = null,
    size_bytes: i64 = 0,
};
pub fn ArrowCharView(arg_value: [*c]const u8) callconv(.c) struct_ArrowStringView {
    var value = arg_value;
    _ = &value;
    var out: struct_ArrowStringView = undefined;
    _ = &out;
    out.data = value;
    if (value != null) {
        out.size_bytes = @bitCast(@as(c_ulong, @truncate(strlen(value))));
    } else {
        out.size_bytes = 0;
    }
    return out;
}
pub const struct_ArrowBinaryViewInlined = extern struct {
    size: i32 = 0,
    data: [12]u8 = @import("std").mem.zeroes([12]u8),
};
pub const struct_ArrowBinaryViewRef = extern struct {
    size: i32 = 0,
    prefix: [4]u8 = @import("std").mem.zeroes([4]u8),
    buffer_index: i32 = 0,
    offset: i32 = 0,
};
pub const union_ArrowBinaryView = extern union {
    inlined: struct_ArrowBinaryViewInlined,
    ref: struct_ArrowBinaryViewRef,
    alignment_dummy: i64,
};
pub const union_ArrowBufferViewData = extern union {
    data: ?*const anyopaque,
    as_int8: [*c]const i8,
    as_uint8: [*c]const u8,
    as_int16: [*c]const i16,
    as_uint16: [*c]const u16,
    as_int32: [*c]const i32,
    as_uint32: [*c]const u32,
    as_int64: [*c]const i64,
    as_uint64: [*c]const u64,
    as_double: [*c]const f64,
    as_float: [*c]const f32,
    as_char: [*c]const u8,
    as_binary_view: [*c]const union_ArrowBinaryView,
};
pub const struct_ArrowBufferView = extern struct {
    data: union_ArrowBufferViewData = @import("std").mem.zeroes(union_ArrowBufferViewData),
    size_bytes: i64 = 0,
};
pub const struct_ArrowBufferAllocator = extern struct {
    reallocate: ?*const fn (allocator: [*c]struct_ArrowBufferAllocator, ptr: [*c]u8, old_size: i64, new_size: i64) callconv(.c) [*c]u8 = null,
    free: ?*const fn (allocator: [*c]struct_ArrowBufferAllocator, ptr: [*c]u8, size: i64) callconv(.c) void = null,
    private_data: ?*anyopaque = null,
};
pub const ArrowBufferDeallocatorCallback = ?*const fn (allocator: [*c]struct_ArrowBufferAllocator, ptr: [*c]u8, size: i64) callconv(.c) void;
pub const struct_ArrowBuffer = extern struct {
    data: [*c]u8 = null,
    size_bytes: i64 = 0,
    capacity_bytes: i64 = 0,
    allocator: struct_ArrowBufferAllocator = @import("std").mem.zeroes(struct_ArrowBufferAllocator),
    pub const ArrowMetadataBuilderInit = __root.ArrowMetadataBuilderInit;
    pub const ArrowMetadataBuilderAppend = __root.ArrowMetadataBuilderAppend;
    pub const ArrowMetadataBuilderSet = __root.ArrowMetadataBuilderSet;
    pub const ArrowMetadataBuilderRemove = __root.ArrowMetadataBuilderRemove;
    pub const ArrowBufferInit = __root.ArrowBufferInit;
    pub const ArrowBufferSetAllocator = __root.ArrowBufferSetAllocator;
    pub const ArrowBufferReset = __root.ArrowBufferReset;
    pub const ArrowBufferMove = __root.ArrowBufferMove;
    pub const ArrowBufferResize = __root.ArrowBufferResize;
    pub const ArrowBufferReserve = __root.ArrowBufferReserve;
    pub const ArrowBufferAppendUnsafe = __root.ArrowBufferAppendUnsafe;
    pub const ArrowBufferAppend = __root.ArrowBufferAppend;
    pub const ArrowBufferAppendFill = __root.ArrowBufferAppendFill;
    pub const ArrowBufferAppendInt8 = __root.ArrowBufferAppendInt8;
    pub const ArrowBufferAppendUInt8 = __root.ArrowBufferAppendUInt8;
    pub const ArrowBufferAppendInt16 = __root.ArrowBufferAppendInt16;
    pub const ArrowBufferAppendUInt16 = __root.ArrowBufferAppendUInt16;
    pub const ArrowBufferAppendInt32 = __root.ArrowBufferAppendInt32;
    pub const ArrowBufferAppendUInt32 = __root.ArrowBufferAppendUInt32;
    pub const ArrowBufferAppendInt64 = __root.ArrowBufferAppendInt64;
    pub const ArrowBufferAppendUInt64 = __root.ArrowBufferAppendUInt64;
    pub const ArrowBufferAppendDouble = __root.ArrowBufferAppendDouble;
    pub const ArrowBufferAppendFloat = __root.ArrowBufferAppendFloat;
    pub const ArrowBufferAppendStringView = __root.ArrowBufferAppendStringView;
    pub const ArrowBufferAppendBufferView = __root.ArrowBufferAppendBufferView;
};
pub const struct_ArrowBitmap = extern struct {
    buffer: struct_ArrowBuffer = @import("std").mem.zeroes(struct_ArrowBuffer),
    size_bits: i64 = 0,
    pub const ArrowBitmapInit = __root.ArrowBitmapInit;
    pub const ArrowBitmapMove = __root.ArrowBitmapMove;
    pub const ArrowBitmapReserve = __root.ArrowBitmapReserve;
    pub const ArrowBitmapResize = __root.ArrowBitmapResize;
    pub const ArrowBitmapAppend = __root.ArrowBitmapAppend;
    pub const ArrowBitmapAppendUnsafe = __root.ArrowBitmapAppendUnsafe;
    pub const ArrowBitmapAppendInt8Unsafe = __root.ArrowBitmapAppendInt8Unsafe;
    pub const ArrowBitmapAppendInt32Unsafe = __root.ArrowBitmapAppendInt32Unsafe;
    pub const ArrowBitmapReset = __root.ArrowBitmapReset;
};
pub const struct_ArrowLayout = extern struct {
    buffer_type: [3]enum_ArrowBufferType = @import("std").mem.zeroes([3]enum_ArrowBufferType),
    buffer_data_type: [3]enum_ArrowType = @import("std").mem.zeroes([3]enum_ArrowType),
    element_size_bits: [3]i64 = @import("std").mem.zeroes([3]i64),
    child_size_elements: i64 = 0,
    pub const ArrowLayoutInit = __root.ArrowLayoutInit;
};
pub const struct_ArrowArrayView = extern struct {
    array: [*c]const struct_ArrowArray = null,
    offset: i64 = 0,
    length: i64 = 0,
    null_count: i64 = 0,
    storage_type: enum_ArrowType = @import("std").mem.zeroes(enum_ArrowType),
    layout: struct_ArrowLayout = @import("std").mem.zeroes(struct_ArrowLayout),
    buffer_views: [3]struct_ArrowBufferView = @import("std").mem.zeroes([3]struct_ArrowBufferView),
    n_children: i64 = 0,
    children: [*c][*c]struct_ArrowArrayView = null,
    dictionary: [*c]struct_ArrowArrayView = null,
    union_type_id_map: [*c]i8 = null,
    n_variadic_buffers: i32 = 0,
    variadic_buffers: [*c]?*const anyopaque = null,
    variadic_buffer_sizes: [*c]i64 = null,
    pub const ArrowArrayViewInitFromType = __root.ArrowArrayViewInitFromType;
    pub const ArrowArrayViewMove = __root.ArrowArrayViewMove;
    pub const ArrowArrayViewInitFromSchema = __root.ArrowArrayViewInitFromSchema;
    pub const ArrowArrayViewAllocateChildren = __root.ArrowArrayViewAllocateChildren;
    pub const ArrowArrayViewAllocateDictionary = __root.ArrowArrayViewAllocateDictionary;
    pub const ArrowArrayViewSetLength = __root.ArrowArrayViewSetLength;
    pub const ArrowArrayViewSetArray = __root.ArrowArrayViewSetArray;
    pub const ArrowArrayViewSetArrayMinimal = __root.ArrowArrayViewSetArrayMinimal;
    pub const ArrowArrayViewGetNumBuffers = __root.ArrowArrayViewGetNumBuffers;
    pub const ArrowArrayViewGetBufferView = __root.ArrowArrayViewGetBufferView;
    pub const ArrowArrayViewGetBufferType = __root.ArrowArrayViewGetBufferType;
    pub const ArrowArrayViewGetBufferDataType = __root.ArrowArrayViewGetBufferDataType;
    pub const ArrowArrayViewGetBufferElementSizeBits = __root.ArrowArrayViewGetBufferElementSizeBits;
    pub const ArrowArrayViewValidate = __root.ArrowArrayViewValidate;
    pub const ArrowArrayViewCompare = __root.ArrowArrayViewCompare;
    pub const ArrowArrayViewReset = __root.ArrowArrayViewReset;
    pub const ArrowArrayViewIsNull = __root.ArrowArrayViewIsNull;
    pub const ArrowArrayViewComputeNullCount = __root.ArrowArrayViewComputeNullCount;
    pub const ArrowArrayViewUnionTypeId = __root.ArrowArrayViewUnionTypeId;
    pub const ArrowArrayViewUnionChildIndex = __root.ArrowArrayViewUnionChildIndex;
    pub const ArrowArrayViewUnionChildOffset = __root.ArrowArrayViewUnionChildOffset;
    pub const ArrowArrayViewGetIntUnsafe = __root.ArrowArrayViewGetIntUnsafe;
    pub const ArrowArrayViewGetUIntUnsafe = __root.ArrowArrayViewGetUIntUnsafe;
    pub const ArrowArrayViewGetDoubleUnsafe = __root.ArrowArrayViewGetDoubleUnsafe;
    pub const ArrowArrayViewGetStringUnsafe = __root.ArrowArrayViewGetStringUnsafe;
    pub const ArrowArrayViewGetBytesUnsafe = __root.ArrowArrayViewGetBytesUnsafe;
    pub const ArrowArrayViewGetDecimalUnsafe = __root.ArrowArrayViewGetDecimalUnsafe;
    pub const ArrowArrayViewListChildOffset = __root.ArrowArrayViewListChildOffset;
    pub const ArrowArrayViewGetBytesFromViewArrayUnsafe = __root.ArrowArrayViewGetBytesFromViewArrayUnsafe;
    pub const ArrowArrayViewGetIntervalUnsafe = __root.ArrowArrayViewGetIntervalUnsafe;
};
pub const struct_ArrowArrayPrivateData = extern struct {
    bitmap: struct_ArrowBitmap = @import("std").mem.zeroes(struct_ArrowBitmap),
    buffers: [2]struct_ArrowBuffer = @import("std").mem.zeroes([2]struct_ArrowBuffer),
    buffer_data: [*c]?*const anyopaque = null,
    storage_type: enum_ArrowType = @import("std").mem.zeroes(enum_ArrowType),
    layout: struct_ArrowLayout = @import("std").mem.zeroes(struct_ArrowLayout),
    union_type_id_is_child_index: i8 = 0,
    n_variadic_buffers: i32 = 0,
    variadic_buffers: [*c]struct_ArrowBuffer = null,
    list_view_offset: i64 = 0,
};
pub const struct_ArrowInterval = extern struct {
    type: enum_ArrowType = @import("std").mem.zeroes(enum_ArrowType),
    months: i32 = 0,
    days: i32 = 0,
    ms: i32 = 0,
    ns: i64 = 0,
    pub const ArrowIntervalInit = __root.ArrowIntervalInit;
};
pub fn ArrowIntervalInit(arg_interval: [*c]struct_ArrowInterval, arg_type: enum_ArrowType) callconv(.c) void {
    var interval = arg_interval;
    _ = &interval;
    var @"type" = arg_type;
    _ = &@"type";
    _ = memset(@ptrCast(@alignCast(interval)), 0, @sizeOf(struct_ArrowInterval));
    interval.*.type = @"type";
}
pub const struct_ArrowDecimal = extern struct {
    words: [4]u64 = @import("std").mem.zeroes([4]u64),
    precision: i32 = 0,
    scale: i32 = 0,
    n_words: c_int = 0,
    high_word_index: c_int = 0,
    low_word_index: c_int = 0,
    pub const ArrowDecimalInit = __root.ArrowDecimalInit;
    pub const ArrowDecimalGetIntUnsafe = __root.ArrowDecimalGetIntUnsafe;
    pub const ArrowDecimalGetBytes = __root.ArrowDecimalGetBytes;
    pub const ArrowDecimalSign = __root.ArrowDecimalSign;
    pub const ArrowDecimalSetInt = __root.ArrowDecimalSetInt;
    pub const ArrowDecimalNegate = __root.ArrowDecimalNegate;
    pub const ArrowDecimalSetBytes = __root.ArrowDecimalSetBytes;
    pub const ArrowDecimalSetDigits = __root.ArrowDecimalSetDigits;
    pub const ArrowDecimalAppendDigitsToBuffer = __root.ArrowDecimalAppendDigitsToBuffer;
    pub const ArrowDecimalAppendStringToBuffer = __root.ArrowDecimalAppendStringToBuffer;
};
pub fn ArrowDecimalInit(arg_decimal: [*c]struct_ArrowDecimal, arg_bitwidth: i32, arg_precision: i32, arg_scale: i32) callconv(.c) void {
    var decimal = arg_decimal;
    _ = &decimal;
    var bitwidth = arg_bitwidth;
    _ = &bitwidth;
    var precision = arg_precision;
    _ = &precision;
    var scale = arg_scale;
    _ = &scale;
    _ = memset(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), 0, @sizeOf(@TypeOf(decimal.*.words)));
    decimal.*.precision = precision;
    decimal.*.scale = scale;
    decimal.*.n_words = @bitCast(@as(c_uint, @truncate(@as(c_ulong, @bitCast(@as(c_long, @divTrunc(bitwidth, @as(c_int, 8))))) / @sizeOf(u64))));
    if (@as(c_int, _ArrowIsLittleEndian()) != 0) {
        decimal.*.low_word_index = 0;
        decimal.*.high_word_index = if (decimal.*.n_words > @as(c_int, 0)) decimal.*.n_words - @as(c_int, 1) else @as(c_int, 0);
    } else {
        decimal.*.low_word_index = if (decimal.*.n_words > @as(c_int, 0)) decimal.*.n_words - @as(c_int, 1) else @as(c_int, 0);
        decimal.*.high_word_index = 0;
    }
}
pub fn ArrowDecimalGetIntUnsafe(arg_decimal: [*c]const struct_ArrowDecimal) callconv(.c) i64 {
    var decimal = arg_decimal;
    _ = &decimal;
    if (decimal.*.n_words == @as(c_int, 0)) {
        var value: i32 = undefined;
        _ = &value;
        _ = memcpy(@ptrCast(@alignCast(&value)), @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @sizeOf(i32));
        return value;
    }
    return @bitCast(@as(c_ulong, @truncate(decimal.*.words[@bitCast(@as(isize, @intCast(decimal.*.low_word_index)))])));
}
pub fn ArrowDecimalGetBytes(arg_decimal: [*c]const struct_ArrowDecimal, arg_out: [*c]u8) callconv(.c) void {
    var decimal = arg_decimal;
    _ = &decimal;
    var out = arg_out;
    _ = &out;
    if (decimal.*.n_words == @as(c_int, 0)) {
        _ = memcpy(@ptrCast(@alignCast(out)), @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @sizeOf(i32));
    } else {
        _ = memcpy(@ptrCast(@alignCast(out)), @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @as(c_ulong, @bitCast(@as(c_long, decimal.*.n_words))) *% @sizeOf(u64));
    }
}
pub fn ArrowDecimalSign(arg_decimal: [*c]const struct_ArrowDecimal) callconv(.c) i64 {
    var decimal = arg_decimal;
    _ = &decimal;
    if (decimal.*.n_words == @as(c_int, 0)) {
        return if (ArrowDecimalGetIntUnsafe(decimal) >= @as(i64, 0)) @as(c_int, 1) else -@as(c_int, 1);
    } else {
        return @as(i64, 1) | (@as(i64, @bitCast(@as(c_ulong, @truncate(decimal.*.words[@bitCast(@as(isize, @intCast(decimal.*.high_word_index)))])))) >> @intCast(@as(i64, 63)));
    }
}
pub fn ArrowDecimalSetInt(arg_decimal: [*c]struct_ArrowDecimal, arg_value: i64) callconv(.c) void {
    var decimal = arg_decimal;
    _ = &decimal;
    var value = arg_value;
    _ = &value;
    if (decimal.*.n_words == @as(c_int, 0)) {
        var value32: i32 = @truncate(value);
        _ = &value32;
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @ptrCast(@alignCast(&value32)), @sizeOf(i32));
        return;
    }
    if (value < @as(i64, 0)) {
        _ = memset(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), 255, @as(c_ulong, @bitCast(@as(c_long, decimal.*.n_words))) *% @sizeOf(u64));
    } else {
        _ = memset(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), 0, @as(c_ulong, @bitCast(@as(c_long, decimal.*.n_words))) *% @sizeOf(u64));
    }
    decimal.*.words[@bitCast(@as(isize, @intCast(decimal.*.low_word_index)))] = @bitCast(@as(c_long, value));
}
pub fn ArrowDecimalNegate(arg_decimal: [*c]struct_ArrowDecimal) callconv(.c) void {
    var decimal = arg_decimal;
    _ = &decimal;
    if (decimal.*.n_words == @as(c_int, 0)) {
        var value: i32 = undefined;
        _ = &value;
        _ = memcpy(@ptrCast(@alignCast(&value)), @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @sizeOf(i32));
        value = -value;
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @ptrCast(@alignCast(&value)), @sizeOf(i32));
        return;
    }
    var carry: u64 = 1;
    _ = &carry;
    if (decimal.*.low_word_index == @as(c_int, 0)) {
        {
            var i: c_int = 0;
            _ = &i;
            while (i < decimal.*.n_words) : (i += 1) {
                var elem: u64 = decimal.*.words[@bitCast(@as(isize, @intCast(i)))];
                _ = &elem;
                elem = ~elem +% carry;
                carry &= @bitCast(@as(c_long, @intFromBool(elem == @as(u64, 0))));
                decimal.*.words[@bitCast(@as(isize, @intCast(i)))] = elem;
            }
        }
    } else {
        {
            var i: c_int = decimal.*.low_word_index;
            _ = &i;
            while (i >= @as(c_int, 0)) : (i -= 1) {
                var elem: u64 = decimal.*.words[@bitCast(@as(isize, @intCast(i)))];
                _ = &elem;
                elem = ~elem +% carry;
                carry &= @bitCast(@as(c_long, @intFromBool(elem == @as(u64, 0))));
                decimal.*.words[@bitCast(@as(isize, @intCast(i)))] = elem;
            }
        }
    }
}
pub fn ArrowDecimalSetBytes(arg_decimal: [*c]struct_ArrowDecimal, arg_value: [*c]const u8) callconv(.c) void {
    var decimal = arg_decimal;
    _ = &decimal;
    var value = arg_value;
    _ = &value;
    if (decimal.*.n_words == @as(c_int, 0)) {
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @ptrCast(@alignCast(value)), @sizeOf(i32));
    } else {
        _ = memcpy(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&decimal.*.words))))), @ptrCast(@alignCast(value)), @as(c_ulong, @bitCast(@as(c_long, decimal.*.n_words))) *% @sizeOf(u64));
    }
}
pub extern fn ArrowMalloc(size: i64) ?*anyopaque;
pub extern fn ArrowRealloc(ptr: ?*anyopaque, size: i64) ?*anyopaque;
pub extern fn ArrowFree(ptr: ?*anyopaque) void;
pub extern fn ArrowBufferAllocatorDefault() struct_ArrowBufferAllocator;
pub extern fn ArrowBufferDeallocator(ArrowBufferDeallocatorCallback, private_data: ?*anyopaque) struct_ArrowBufferAllocator;
pub extern fn ArrowErrorSet(@"error": [*c]struct_ArrowError, fmt: [*c]const u8, ...) c_int;
pub extern fn ArrowNanoarrowVersion() [*c]const u8;
pub extern fn ArrowNanoarrowVersionInt() c_int;
pub extern fn ArrowLayoutInit(layout: [*c]struct_ArrowLayout, storage_type: enum_ArrowType) void;
pub extern fn ArrowDecimalSetDigits(decimal: [*c]struct_ArrowDecimal, value: struct_ArrowStringView) ArrowErrorCode;
pub extern fn ArrowDecimalAppendDigitsToBuffer(decimal: [*c]const struct_ArrowDecimal, buffer: [*c]struct_ArrowBuffer) ArrowErrorCode;
pub extern fn ArrowDecimalAppendStringToBuffer(decimal: [*c]const struct_ArrowDecimal, buffer: [*c]struct_ArrowBuffer) ArrowErrorCode;
pub fn ArrowFloatToHalfFloat(arg_value: f32) callconv(.c) u16 {
    var value = arg_value;
    _ = &value;
    const union_unnamed_3 = extern union {
        f: f32,
        b: u32,
    };
    _ = &union_unnamed_3;
    var u: union_unnamed_3 = undefined;
    _ = &u;
    u.f = value;
    var sn: u16 = @truncate((u.b >> @intCast(@as(u32, 31))) & @as(u32, 1));
    _ = &sn;
    var exp: u16 = @truncate((u.b >> @intCast(@as(u32, 23))) & @as(u32, 255));
    _ = &exp;
    var res: i16 = @truncate((@as(c_int, exp) - @as(c_int, 127)) + @as(c_int, 15));
    _ = &res;
    var fc: u16 = @bitCast(@as(c_short, @truncate(@as(c_int, @as(u16, @truncate(u.b >> @intCast(@as(u32, 13))))) & @as(c_int, 1023))));
    _ = &fc;
    if (@as(c_int, exp) == @as(c_int, 0)) {
        res = 0;
    } else if (@as(c_int, exp) == @as(c_int, 255)) {
        res = 31;
    } else if (@as(c_int, res) > @as(c_int, 30)) {
        res = 31;
        fc = 0;
    } else if (@as(c_int, res) < @as(c_int, 1)) {
        res = 0;
        fc = 0;
    }
    return @bitCast(@as(c_short, @truncate(((@as(c_int, sn) << @intCast(@as(c_int, 15))) | @as(c_int, @as(u16, @bitCast(@as(c_short, @truncate(@as(c_int, res) << @intCast(@as(c_int, 10)))))))) | @as(c_int, fc))));
}
pub fn ArrowHalfFloatToFloat(arg_value: u16) callconv(.c) f32 {
    var value = arg_value;
    _ = &value;
    var sn: u32 = @bitCast(@as(c_int, (@as(c_int, value) >> @intCast(@as(c_int, 15))) & @as(c_int, 1)));
    _ = &sn;
    var exp: u32 = @bitCast(@as(c_int, (@as(c_int, value) >> @intCast(@as(c_int, 10))) & @as(c_int, 31)));
    _ = &exp;
    var res: u32 = (exp +% @as(u32, 127)) -% @as(u32, 15);
    _ = &res;
    var fc: u32 = @bitCast(@as(c_int, @as(c_int, value) & @as(c_int, 1023)));
    _ = &fc;
    if (exp == @as(u32, 0)) {
        res = 0;
    } else if (exp == @as(u32, 31)) {
        res = 255;
    }
    const union_unnamed_4 = extern union {
        f: f32,
        b: u32,
    };
    _ = &union_unnamed_4;
    var u: union_unnamed_4 = undefined;
    _ = &u;
    u.b = ((sn << @intCast(@as(u32, 31))) | (res << @intCast(@as(u32, 23)))) | (fc << @intCast(@as(u32, 13)));
    return u.f;
}
pub fn ArrowResolveChunk64(arg_index_1: i64, arg_offsets: [*c]const i64, arg_lo: i64, arg_hi: i64) callconv(.c) i64 {
    var index_1 = arg_index_1;
    _ = &index_1;
    var offsets = arg_offsets;
    _ = &offsets;
    var lo = arg_lo;
    _ = &lo;
    var hi = arg_hi;
    _ = &hi;
    var n: i64 = hi - lo;
    _ = &n;
    while (true) {
        const m: i64 = n >> @intCast(@as(i64, 1));
        _ = &m;
        const mid: i64 = lo + m;
        _ = &mid;
        if (index_1 >= offsets[@bitCast(@as(isize, @intCast(mid)))]) {
            lo = mid;
            n -= m;
        } else {
            n = m;
        }
        if (!(n > @as(i64, 1))) break;
    }
    return lo;
}
pub extern fn ArrowSchemaInit(schema: [*c]struct_ArrowSchema) void;
pub extern fn ArrowSchemaInitFromType(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType) ArrowErrorCode;
pub extern fn ArrowSchemaToString(schema: [*c]const struct_ArrowSchema, out: [*c]u8, n: i64, recursive: u8) i64;
pub extern fn ArrowSchemaSetType(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeStruct(schema: [*c]struct_ArrowSchema, n_children: i64) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeFixedSize(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType, fixed_size: i32) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeDecimal(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType, decimal_precision: i32, decimal_scale: i32) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeRunEndEncoded(schema: [*c]struct_ArrowSchema, run_end_type: enum_ArrowType) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeDateTime(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType, time_unit: enum_ArrowTimeUnit, timezone: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowSchemaSetTypeUnion(schema: [*c]struct_ArrowSchema, @"type": enum_ArrowType, n_children: i64) ArrowErrorCode;
pub extern fn ArrowSchemaDeepCopy(schema: [*c]const struct_ArrowSchema, schema_out: [*c]struct_ArrowSchema) ArrowErrorCode;
pub extern fn ArrowSchemaSetFormat(schema: [*c]struct_ArrowSchema, format: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowSchemaSetName(schema: [*c]struct_ArrowSchema, name: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowSchemaSetMetadata(schema: [*c]struct_ArrowSchema, metadata: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowSchemaAllocateChildren(schema: [*c]struct_ArrowSchema, n_children: i64) ArrowErrorCode;
pub extern fn ArrowSchemaAllocateDictionary(schema: [*c]struct_ArrowSchema) ArrowErrorCode;
pub const struct_ArrowMetadataReader = extern struct {
    metadata: [*c]const u8 = null,
    offset: i64 = 0,
    remaining_keys: i32 = 0,
    pub const ArrowMetadataReaderInit = __root.ArrowMetadataReaderInit;
    pub const ArrowMetadataReaderRead = __root.ArrowMetadataReaderRead;
};
pub extern fn ArrowMetadataReaderInit(reader: [*c]struct_ArrowMetadataReader, metadata: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowMetadataReaderRead(reader: [*c]struct_ArrowMetadataReader, key_out: [*c]struct_ArrowStringView, value_out: [*c]struct_ArrowStringView) ArrowErrorCode;
pub extern fn ArrowMetadataSizeOf(metadata: [*c]const u8) i64;
pub extern fn ArrowMetadataHasKey(metadata: [*c]const u8, key: struct_ArrowStringView) u8;
pub extern fn ArrowMetadataGetValue(metadata: [*c]const u8, key: struct_ArrowStringView, value_out: [*c]struct_ArrowStringView) ArrowErrorCode;
pub extern fn ArrowMetadataBuilderInit(buffer: [*c]struct_ArrowBuffer, metadata: [*c]const u8) ArrowErrorCode;
pub extern fn ArrowMetadataBuilderAppend(buffer: [*c]struct_ArrowBuffer, key: struct_ArrowStringView, value: struct_ArrowStringView) ArrowErrorCode;
pub extern fn ArrowMetadataBuilderSet(buffer: [*c]struct_ArrowBuffer, key: struct_ArrowStringView, value: struct_ArrowStringView) ArrowErrorCode;
pub extern fn ArrowMetadataBuilderRemove(buffer: [*c]struct_ArrowBuffer, key: struct_ArrowStringView) ArrowErrorCode;
pub const struct_ArrowSchemaView = extern struct {
    schema: [*c]const struct_ArrowSchema = null,
    type: enum_ArrowType = @import("std").mem.zeroes(enum_ArrowType),
    storage_type: enum_ArrowType = @import("std").mem.zeroes(enum_ArrowType),
    layout: struct_ArrowLayout = @import("std").mem.zeroes(struct_ArrowLayout),
    extension_name: struct_ArrowStringView = @import("std").mem.zeroes(struct_ArrowStringView),
    extension_metadata: struct_ArrowStringView = @import("std").mem.zeroes(struct_ArrowStringView),
    fixed_size: i32 = 0,
    decimal_bitwidth: i32 = 0,
    decimal_precision: i32 = 0,
    decimal_scale: i32 = 0,
    time_unit: enum_ArrowTimeUnit = @import("std").mem.zeroes(enum_ArrowTimeUnit),
    timezone: [*c]const u8 = null,
    union_type_ids: [*c]const u8 = null,
    pub const ArrowSchemaViewInit = __root.ArrowSchemaViewInit;
};
pub extern fn ArrowSchemaViewInit(schema_view: [*c]struct_ArrowSchemaView, schema: [*c]const struct_ArrowSchema, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub fn ArrowBufferInit(arg_buffer: [*c]struct_ArrowBuffer) callconv(.c) void {
    var buffer = arg_buffer;
    _ = &buffer;
    buffer.*.data = null;
    buffer.*.size_bytes = 0;
    buffer.*.capacity_bytes = 0;
    buffer.*.allocator = ArrowBufferAllocatorDefault();
}
pub fn ArrowBufferSetAllocator(arg_buffer: [*c]struct_ArrowBuffer, arg_allocator: struct_ArrowBufferAllocator) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var allocator = arg_allocator;
    _ = &allocator;
    if (@as(?*anyopaque, @ptrCast(@alignCast(buffer.*.data))) == @as(?*anyopaque, null)) {
        buffer.*.allocator = allocator;
        return NANOARROW_OK;
    } else {
        return EINVAL;
    }
}
pub fn ArrowBufferReset(arg_buffer: [*c]struct_ArrowBuffer) callconv(.c) void {
    var buffer = arg_buffer;
    _ = &buffer;
    buffer.*.allocator.free.?(&buffer.*.allocator, buffer.*.data, buffer.*.capacity_bytes);
    ArrowBufferInit(buffer);
}
pub fn ArrowBufferMove(arg_src: [*c]struct_ArrowBuffer, arg_dst: [*c]struct_ArrowBuffer) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    _ = memcpy(@ptrCast(@alignCast(dst)), @ptrCast(@alignCast(src)), @sizeOf(struct_ArrowBuffer));
    src.*.data = null;
    ArrowBufferInit(src);
}
pub fn ArrowBufferResize(arg_buffer: [*c]struct_ArrowBuffer, arg_new_size_bytes: i64, arg_shrink_to_fit: u8) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var new_size_bytes = arg_new_size_bytes;
    _ = &new_size_bytes;
    var shrink_to_fit = arg_shrink_to_fit;
    _ = &shrink_to_fit;
    if (new_size_bytes < @as(i64, 0)) {
        return EINVAL;
    }
    var needs_reallocation: c_int = @intFromBool((new_size_bytes > buffer.*.capacity_bytes) or ((@as(c_int, shrink_to_fit) != 0) and (new_size_bytes < buffer.*.capacity_bytes)));
    _ = &needs_reallocation;
    if (needs_reallocation != 0) {
        buffer.*.data = buffer.*.allocator.reallocate.?(&buffer.*.allocator, buffer.*.data, buffer.*.capacity_bytes, new_size_bytes);
        if ((@as(?*anyopaque, @ptrCast(@alignCast(buffer.*.data))) == @as(?*anyopaque, null)) and (new_size_bytes > @as(i64, 0))) {
            buffer.*.capacity_bytes = 0;
            buffer.*.size_bytes = 0;
            return ENOMEM;
        }
        buffer.*.capacity_bytes = new_size_bytes;
    }
    buffer.*.size_bytes = new_size_bytes;
    return NANOARROW_OK;
}
pub fn ArrowBufferReserve(arg_buffer: [*c]struct_ArrowBuffer, arg_additional_size_bytes: i64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var additional_size_bytes = arg_additional_size_bytes;
    _ = &additional_size_bytes;
    var min_capacity_bytes: i64 = buffer.*.size_bytes + additional_size_bytes;
    _ = &min_capacity_bytes;
    if (min_capacity_bytes <= buffer.*.capacity_bytes) {
        return NANOARROW_OK;
    }
    var new_capacity_bytes: i64 = _ArrowGrowByFactor(buffer.*.capacity_bytes, min_capacity_bytes);
    _ = &new_capacity_bytes;
    buffer.*.data = buffer.*.allocator.reallocate.?(&buffer.*.allocator, buffer.*.data, buffer.*.capacity_bytes, new_capacity_bytes);
    if ((@as(?*anyopaque, @ptrCast(@alignCast(buffer.*.data))) == @as(?*anyopaque, null)) and (new_capacity_bytes > @as(i64, 0))) {
        buffer.*.capacity_bytes = 0;
        buffer.*.size_bytes = 0;
        return ENOMEM;
    }
    buffer.*.capacity_bytes = new_capacity_bytes;
    return NANOARROW_OK;
}
pub fn ArrowBufferAppendUnsafe(arg_buffer: [*c]struct_ArrowBuffer, arg_data: ?*const anyopaque, arg_size_bytes: i64) callconv(.c) void {
    var buffer = arg_buffer;
    _ = &buffer;
    var data = arg_data;
    _ = &data;
    var size_bytes = arg_size_bytes;
    _ = &size_bytes;
    if (size_bytes > @as(i64, 0)) {
        _ = memcpy(@ptrCast(@alignCast(buffer.*.data + @as(usize, @bitCast(@as(isize, @intCast(buffer.*.size_bytes)))))), data, @bitCast(@as(c_long, size_bytes)));
        buffer.*.size_bytes += size_bytes;
    }
}
pub fn ArrowBufferAppend(arg_buffer: [*c]struct_ArrowBuffer, arg_data: ?*const anyopaque, arg_size_bytes: i64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var data = arg_data;
    _ = &data;
    var size_bytes = arg_size_bytes;
    _ = &size_bytes;
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferReserve(buffer, size_bytes);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    ArrowBufferAppendUnsafe(buffer, data, size_bytes);
    return NANOARROW_OK;
}
pub fn ArrowBufferAppendFill(arg_buffer: [*c]struct_ArrowBuffer, arg_value: u8, arg_size_bytes: i64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    var size_bytes = arg_size_bytes;
    _ = &size_bytes;
    if (size_bytes == @as(i64, 0)) {
        return NANOARROW_OK;
    }
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferReserve(buffer, size_bytes);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    _ = memset(@ptrCast(@alignCast(buffer.*.data + @as(usize, @bitCast(@as(isize, @intCast(buffer.*.size_bytes)))))), value, @bitCast(@as(c_long, size_bytes)));
    buffer.*.size_bytes += size_bytes;
    return NANOARROW_OK;
}
pub fn ArrowBufferAppendInt8(arg_buffer: [*c]struct_ArrowBuffer, arg_value: i8) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i8)))));
}
pub fn ArrowBufferAppendUInt8(arg_buffer: [*c]struct_ArrowBuffer, arg_value: u8) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(u8)))));
}
pub fn ArrowBufferAppendInt16(arg_buffer: [*c]struct_ArrowBuffer, arg_value: i16) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i16)))));
}
pub fn ArrowBufferAppendUInt16(arg_buffer: [*c]struct_ArrowBuffer, arg_value: u16) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(u16)))));
}
pub fn ArrowBufferAppendInt32(arg_buffer: [*c]struct_ArrowBuffer, arg_value: i32) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i32)))));
}
pub fn ArrowBufferAppendUInt32(arg_buffer: [*c]struct_ArrowBuffer, arg_value: u32) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(u32)))));
}
pub fn ArrowBufferAppendInt64(arg_buffer: [*c]struct_ArrowBuffer, arg_value: i64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i64)))));
}
pub fn ArrowBufferAppendUInt64(arg_buffer: [*c]struct_ArrowBuffer, arg_value: u64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(u64)))));
}
pub fn ArrowBufferAppendDouble(arg_buffer: [*c]struct_ArrowBuffer, arg_value: f64) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(f64)))));
}
pub fn ArrowBufferAppendFloat(arg_buffer: [*c]struct_ArrowBuffer, arg_value: f32) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(f32)))));
}
pub fn ArrowBufferAppendStringView(arg_buffer: [*c]struct_ArrowBuffer, arg_value: struct_ArrowStringView) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, @ptrCast(@alignCast(value.data)), value.size_bytes);
}
pub fn ArrowBufferAppendBufferView(arg_buffer: [*c]struct_ArrowBuffer, arg_value: struct_ArrowBufferView) callconv(.c) ArrowErrorCode {
    var buffer = arg_buffer;
    _ = &buffer;
    var value = arg_value;
    _ = &value;
    return ArrowBufferAppend(buffer, value.data.data, value.size_bytes);
}
pub fn ArrowBitGet(arg_bits: [*c]const u8, arg_i: i64) callconv(.c) i8 {
    var bits = arg_bits;
    _ = &bits;
    var i = arg_i;
    _ = &i;
    return @truncate((@as(i64, @as(c_int, bits[@bitCast(@as(isize, @intCast(i >> @intCast(@as(i64, 3)))))])) >> @intCast(i & @as(i64, 7))) & @as(i64, 1));
}
pub fn ArrowBitSet(arg_bits: [*c]u8, arg_i: i64) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var i = arg_i;
    _ = &i;
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(@divTrunc(i, @as(i64, 8)))))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) | @as(c_int, _ArrowkBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i, @as(i64, 8)))))]))));
    }
}
pub fn ArrowBitClear(arg_bits: [*c]u8, arg_i: i64) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var i = arg_i;
    _ = &i;
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(@divTrunc(i, @as(i64, 8)))))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) & @as(c_int, _ArrowkFlippedBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i, @as(i64, 8)))))]))));
    }
}
pub fn ArrowBitSetTo(arg_bits: [*c]u8, arg_i: i64, arg_bit_is_set: u8) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var i = arg_i;
    _ = &i;
    var bit_is_set = arg_bit_is_set;
    _ = &bit_is_set;
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(@divTrunc(i, @as(i64, 8)))))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) ^ @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, @as(u8, @bitCast(@as(i8, @truncate(-@as(c_int, @as(u8, @bitCast(@as(i8, @intFromBool(@as(c_int, bit_is_set) != @as(c_int, 0)))))) ^ @as(c_int, bits[@bitCast(@as(isize, @intCast(@divTrunc(i, @as(i64, 8)))))])))))) & @as(c_int, _ArrowkBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i, @as(i64, 8)))))])))))))));
    }
}
pub fn ArrowBitsSetTo(arg_bits: [*c]u8, arg_start_offset: i64, arg_length: i64, arg_bits_are_set: u8) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var start_offset = arg_start_offset;
    _ = &start_offset;
    var length = arg_length;
    _ = &length;
    var bits_are_set = arg_bits_are_set;
    _ = &bits_are_set;
    if (length == @as(i64, 0)) {
        return;
    }
    const i_begin: i64 = start_offset;
    _ = &i_begin;
    const i_end: i64 = start_offset + length;
    _ = &i_end;
    const fill_byte: u8 = @bitCast(@as(i8, @truncate(-@as(c_int, bits_are_set))));
    _ = &fill_byte;
    const bytes_begin: i64 = @divTrunc(i_begin, @as(i64, 8));
    _ = &bytes_begin;
    const bytes_end: i64 = @divTrunc(i_end, @as(i64, 8)) + @as(i64, 1);
    _ = &bytes_end;
    const first_byte_mask: u8 = _ArrowkPrecedingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_begin, @as(i64, 8)))))];
    _ = &first_byte_mask;
    const last_byte_mask: u8 = _ArrowkTrailingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_end, @as(i64, 8)))))];
    _ = &last_byte_mask;
    if (bytes_end == (bytes_begin + @as(i64, 1))) {
        const only_byte_mask: u8 = @bitCast(@as(i8, @truncate(if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) @as(c_int, first_byte_mask) else @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, first_byte_mask) | @as(c_int, last_byte_mask)))))))));
        _ = &only_byte_mask;
        {
            const ref = &bits[@bitCast(@as(isize, @intCast(bytes_begin)))];
            ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) & @as(c_int, only_byte_mask))));
        }
        {
            const ref = &bits[@bitCast(@as(isize, @intCast(bytes_begin)))];
            ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) | @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, fill_byte) & ~@as(c_int, only_byte_mask)))))))));
        }
        return;
    }
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(bytes_begin)))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) & @as(c_int, first_byte_mask))));
    }
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(bytes_begin)))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) | @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, fill_byte) & ~@as(c_int, first_byte_mask)))))))));
    }
    if ((bytes_end - bytes_begin) > @as(i64, 2)) {
        _ = memset(@ptrCast(@alignCast((bits + @as(usize, @bitCast(@as(isize, @intCast(bytes_begin))))) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1))))))), fill_byte, @bitCast(@as(c_long, (bytes_end - bytes_begin) - @as(i64, 2))));
    }
    if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) {
        return;
    }
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(bytes_end - @as(i64, 1))))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) & @as(c_int, last_byte_mask))));
    }
    {
        const ref = &bits[@bitCast(@as(isize, @intCast(bytes_end - @as(i64, 1))))];
        ref.* = @bitCast(@as(i8, @truncate(@as(c_int, ref.*) | @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, fill_byte) & ~@as(c_int, last_byte_mask)))))))));
    }
}
pub fn ArrowBitCountSet(arg_bits: [*c]const u8, arg_start_offset: i64, arg_length: i64) callconv(.c) i64 {
    var bits = arg_bits;
    _ = &bits;
    var start_offset = arg_start_offset;
    _ = &start_offset;
    var length = arg_length;
    _ = &length;
    if (length == @as(i64, 0)) {
        return 0;
    }
    const i_begin: i64 = start_offset;
    _ = &i_begin;
    const i_end: i64 = start_offset + length;
    _ = &i_end;
    const i_last_valid: i64 = i_end - @as(i64, 1);
    _ = &i_last_valid;
    const bytes_begin: i64 = @divTrunc(i_begin, @as(i64, 8));
    _ = &bytes_begin;
    const bytes_last_valid: i64 = @divTrunc(i_last_valid, @as(i64, 8));
    _ = &bytes_last_valid;
    if (bytes_begin == bytes_last_valid) {
        const first_byte_mask: u8 = _ArrowkPrecedingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_end, @as(i64, 8)))))];
        _ = &first_byte_mask;
        const last_byte_mask: u8 = _ArrowkTrailingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_begin, @as(i64, 8)))))];
        _ = &last_byte_mask;
        const only_byte_mask: u8 = @bitCast(@as(i8, @truncate(if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) @as(c_int, last_byte_mask) else @as(c_int, @as(u8, @bitCast(@as(i8, @truncate(@as(c_int, first_byte_mask) & @as(c_int, last_byte_mask)))))))));
        _ = &only_byte_mask;
        const byte_masked: u8 = @bitCast(@as(i8, @truncate(@as(c_int, bits[@bitCast(@as(isize, @intCast(bytes_begin)))]) & @as(c_int, only_byte_mask))));
        _ = &byte_masked;
        return _ArrowkBytePopcount[byte_masked];
    }
    const first_byte_mask: u8 = _ArrowkPrecedingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_begin, @as(i64, 8)))))];
    _ = &first_byte_mask;
    const last_byte_mask: u8 = @bitCast(@as(i8, @truncate(if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) @as(c_int, 0) else @as(c_int, _ArrowkTrailingBitmask[@bitCast(@as(isize, @intCast(__helpers.signedRemainder(i_end, @as(i64, 8)))))]))));
    _ = &last_byte_mask;
    var count: i64 = 0;
    _ = &count;
    count += @as(c_int, _ArrowkBytePopcount[@bitCast(@as(isize, @intCast(@as(c_int, bits[@bitCast(@as(isize, @intCast(bytes_begin)))]) & ~@as(c_int, first_byte_mask))))]);
    {
        var i: i64 = bytes_begin + @as(i64, 1);
        _ = &i;
        while (i < bytes_last_valid) : (i += 1) {
            count += @as(c_int, _ArrowkBytePopcount[bits[@bitCast(@as(isize, @intCast(i)))]]);
        }
    }
    count += @as(c_int, _ArrowkBytePopcount[@bitCast(@as(isize, @intCast(@as(c_int, bits[@bitCast(@as(isize, @intCast(bytes_last_valid)))]) & ~@as(c_int, last_byte_mask))))]);
    return count;
}
pub fn ArrowBitsUnpackInt8(arg_bits: [*c]const u8, arg_start_offset: i64, arg_length: i64, arg_out: [*c]i8) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var start_offset = arg_start_offset;
    _ = &start_offset;
    var length = arg_length;
    _ = &length;
    var out = arg_out;
    _ = &out;
    if (length == @as(i64, 0)) {
        return;
    }
    const i_begin: i64 = start_offset;
    _ = &i_begin;
    const i_end: i64 = start_offset + length;
    _ = &i_end;
    const i_last_valid: i64 = i_end - @as(i64, 1);
    _ = &i_last_valid;
    const bytes_begin: i64 = @divTrunc(i_begin, @as(i64, 8));
    _ = &bytes_begin;
    const bytes_last_valid: i64 = @divTrunc(i_last_valid, @as(i64, 8));
    _ = &bytes_last_valid;
    if (bytes_begin == bytes_last_valid) {
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < length) : (i += 1) {
                out[@bitCast(@as(isize, @intCast(i)))] = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_begin)))], @as(i64, i) + __helpers.signedRemainder(i_begin, @as(i64, 8)));
            }
        }
        return;
    }
    {
        var i: c_int = 0;
        _ = &i;
        while (@as(i64, i) < (@as(i64, 8) - __helpers.signedRemainder(i_begin, @as(i64, 8)))) : (i += 1) {
            (blk: {
                const ref = &out;
                const tmp = ref.*;
                ref.* += 1;
                break :blk tmp;
            }).* = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_begin)))], @as(i64, i) + __helpers.signedRemainder(i_begin, @as(i64, 8)));
        }
    }
    {
        var i: i64 = bytes_begin + @as(i64, 1);
        _ = &i;
        while (i < bytes_last_valid) : (i += 1) {
            _ArrowBitsUnpackInt8(bits[@bitCast(@as(isize, @intCast(i)))], out);
            out += @as(usize, @bitCast(@as(isize, @intCast(8))));
        }
    }
    const bits_remaining: c_int = @truncate(if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) @as(i64, 8) else __helpers.signedRemainder(i_end, @as(i64, 8)));
    _ = &bits_remaining;
    {
        var i: c_int = 0;
        _ = &i;
        while (i < bits_remaining) : (i += 1) {
            (blk: {
                const ref = &out;
                const tmp = ref.*;
                ref.* += 1;
                break :blk tmp;
            }).* = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_last_valid)))], i);
        }
    }
}
pub fn ArrowBitsUnpackInt32(arg_bits: [*c]const u8, arg_start_offset: i64, arg_length: i64, arg_out: [*c]i32) callconv(.c) void {
    var bits = arg_bits;
    _ = &bits;
    var start_offset = arg_start_offset;
    _ = &start_offset;
    var length = arg_length;
    _ = &length;
    var out = arg_out;
    _ = &out;
    if (length == @as(i64, 0)) {
        return;
    }
    const i_begin: i64 = start_offset;
    _ = &i_begin;
    const i_end: i64 = start_offset + length;
    _ = &i_end;
    const i_last_valid: i64 = i_end - @as(i64, 1);
    _ = &i_last_valid;
    const bytes_begin: i64 = @divTrunc(i_begin, @as(i64, 8));
    _ = &bytes_begin;
    const bytes_last_valid: i64 = @divTrunc(i_last_valid, @as(i64, 8));
    _ = &bytes_last_valid;
    if (bytes_begin == bytes_last_valid) {
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < length) : (i += 1) {
                out[@bitCast(@as(isize, @intCast(i)))] = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_begin)))], @as(i64, i) + __helpers.signedRemainder(i_begin, @as(i64, 8)));
            }
        }
        return;
    }
    {
        var i: c_int = 0;
        _ = &i;
        while (@as(i64, i) < (@as(i64, 8) - __helpers.signedRemainder(i_begin, @as(i64, 8)))) : (i += 1) {
            (blk: {
                const ref = &out;
                const tmp = ref.*;
                ref.* += 1;
                break :blk tmp;
            }).* = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_begin)))], @as(i64, i) + __helpers.signedRemainder(i_begin, @as(i64, 8)));
        }
    }
    {
        var i: i64 = bytes_begin + @as(i64, 1);
        _ = &i;
        while (i < bytes_last_valid) : (i += 1) {
            _ArrowBitsUnpackInt32(bits[@bitCast(@as(isize, @intCast(i)))], out);
            out += @as(usize, @bitCast(@as(isize, @intCast(8))));
        }
    }
    const bits_remaining: c_int = @truncate(if (__helpers.signedRemainder(i_end, @as(i64, 8)) == @as(i64, 0)) @as(i64, 8) else __helpers.signedRemainder(i_end, @as(i64, 8)));
    _ = &bits_remaining;
    {
        var i: c_int = 0;
        _ = &i;
        while (i < bits_remaining) : (i += 1) {
            (blk: {
                const ref = &out;
                const tmp = ref.*;
                ref.* += 1;
                break :blk tmp;
            }).* = ArrowBitGet(&bits[@bitCast(@as(isize, @intCast(bytes_last_valid)))], i);
        }
    }
}
pub fn ArrowBitmapInit(arg_bitmap: [*c]struct_ArrowBitmap) callconv(.c) void {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    ArrowBufferInit(&bitmap.*.buffer);
    bitmap.*.size_bits = 0;
}
pub fn ArrowBitmapMove(arg_src: [*c]struct_ArrowBitmap, arg_dst: [*c]struct_ArrowBitmap) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    ArrowBufferMove(&src.*.buffer, &dst.*.buffer);
    dst.*.size_bits = src.*.size_bits;
    src.*.size_bits = 0;
}
pub fn ArrowBitmapReserve(arg_bitmap: [*c]struct_ArrowBitmap, arg_additional_size_bits: i64) callconv(.c) ArrowErrorCode {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var additional_size_bits = arg_additional_size_bits;
    _ = &additional_size_bits;
    var min_capacity_bits: i64 = bitmap.*.size_bits + additional_size_bits;
    _ = &min_capacity_bits;
    var min_capacity_bytes: i64 = _ArrowBytesForBits(min_capacity_bits);
    _ = &min_capacity_bytes;
    var current_size_bytes: i64 = bitmap.*.buffer.size_bytes;
    _ = &current_size_bytes;
    var current_capacity_bytes: i64 = bitmap.*.buffer.capacity_bytes;
    _ = &current_capacity_bytes;
    if (min_capacity_bytes <= current_capacity_bytes) {
        return NANOARROW_OK;
    }
    var additional_capacity_bytes: i64 = min_capacity_bytes - current_size_bytes;
    _ = &additional_capacity_bytes;
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferReserve(&bitmap.*.buffer, additional_capacity_bytes);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    bitmap.*.buffer.data[@bitCast(@as(isize, @intCast(bitmap.*.buffer.capacity_bytes - @as(i64, 1))))] = 0;
    return NANOARROW_OK;
}
pub fn ArrowBitmapResize(arg_bitmap: [*c]struct_ArrowBitmap, arg_new_size_bits: i64, arg_shrink_to_fit: u8) callconv(.c) ArrowErrorCode {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var new_size_bits = arg_new_size_bits;
    _ = &new_size_bits;
    var shrink_to_fit = arg_shrink_to_fit;
    _ = &shrink_to_fit;
    if (new_size_bits < @as(i64, 0)) {
        return EINVAL;
    }
    var new_size_bytes: i64 = _ArrowBytesForBits(new_size_bits);
    _ = &new_size_bytes;
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferResize(&bitmap.*.buffer, new_size_bytes, shrink_to_fit);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    bitmap.*.size_bits = new_size_bits;
    return NANOARROW_OK;
}
pub fn ArrowBitmapAppend(arg_bitmap: [*c]struct_ArrowBitmap, arg_bits_are_set: u8, arg_length: i64) callconv(.c) ArrowErrorCode {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var bits_are_set = arg_bits_are_set;
    _ = &bits_are_set;
    var length = arg_length;
    _ = &length;
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapReserve(bitmap, length);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    ArrowBitmapAppendUnsafe(bitmap, bits_are_set, length);
    return NANOARROW_OK;
}
pub fn ArrowBitmapAppendUnsafe(arg_bitmap: [*c]struct_ArrowBitmap, arg_bits_are_set: u8, arg_length: i64) callconv(.c) void {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var bits_are_set = arg_bits_are_set;
    _ = &bits_are_set;
    var length = arg_length;
    _ = &length;
    ArrowBitsSetTo(bitmap.*.buffer.data, bitmap.*.size_bits, length, bits_are_set);
    bitmap.*.size_bits += length;
    bitmap.*.buffer.size_bytes = _ArrowBytesForBits(bitmap.*.size_bits);
}
pub fn ArrowBitmapAppendInt8Unsafe(arg_bitmap: [*c]struct_ArrowBitmap, arg_values: [*c]const i8, arg_n_values: i64) callconv(.c) void {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var values = arg_values;
    _ = &values;
    var n_values = arg_n_values;
    _ = &n_values;
    if (n_values == @as(i64, 0)) {
        return;
    }
    var values_cursor: [*c]const i8 = values;
    _ = &values_cursor;
    var n_remaining: i64 = n_values;
    _ = &n_remaining;
    var out_i_cursor: i64 = bitmap.*.size_bits;
    _ = &out_i_cursor;
    var out_cursor: [*c]u8 = bitmap.*.buffer.data + @as(usize, @bitCast(@as(isize, @intCast(@divTrunc(bitmap.*.size_bits, @as(i64, 8))))));
    _ = &out_cursor;
    if (__helpers.signedRemainder(out_i_cursor, @as(i64, 8)) != @as(i64, 0)) {
        var n_partial_bits: i64 = _ArrowRoundUpToMultipleOf8(out_i_cursor) - out_i_cursor;
        _ = &n_partial_bits;
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < n_partial_bits) : (i += 1) {
                ArrowBitSetTo(bitmap.*.buffer.data, blk: {
                    const ref = &out_i_cursor;
                    const tmp = ref.*;
                    ref.* += 1;
                    break :blk tmp;
                }, @bitCast(@as(i8, values[@bitCast(@as(isize, @intCast(i)))])));
            }
        }
        out_cursor += 1;
        values_cursor += @as(usize, @bitCast(@as(isize, @intCast(n_partial_bits))));
        n_remaining -= n_partial_bits;
    }
    var n_full_bytes: i64 = @divTrunc(n_remaining, @as(i64, 8));
    _ = &n_full_bytes;
    {
        var i: i64 = 0;
        _ = &i;
        while (i < n_full_bytes) : (i += 1) {
            _ArrowBitmapPackInt8(values_cursor, out_cursor);
            values_cursor += @as(usize, @bitCast(@as(isize, @intCast(8))));
            out_cursor += 1;
        }
    }
    out_i_cursor += n_full_bytes * @as(i64, 8);
    n_remaining -= n_full_bytes * @as(i64, 8);
    if (n_remaining > @as(i64, 0)) {
        out_cursor.* = 0;
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < n_remaining) : (i += 1) {
                ArrowBitSetTo(bitmap.*.buffer.data, blk: {
                    const ref = &out_i_cursor;
                    const tmp = ref.*;
                    ref.* += 1;
                    break :blk tmp;
                }, @bitCast(@as(i8, values_cursor[@bitCast(@as(isize, @intCast(i)))])));
            }
        }
        out_cursor += 1;
    }
    bitmap.*.size_bits += n_values;
    bitmap.*.buffer.size_bytes = @divExact(@as(c_long, @bitCast(@intFromPtr(out_cursor) -% @intFromPtr(bitmap.*.buffer.data))), @sizeOf(u8));
}
pub fn ArrowBitmapAppendInt32Unsafe(arg_bitmap: [*c]struct_ArrowBitmap, arg_values: [*c]const i32, arg_n_values: i64) callconv(.c) void {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    var values = arg_values;
    _ = &values;
    var n_values = arg_n_values;
    _ = &n_values;
    if (n_values == @as(i64, 0)) {
        return;
    }
    var values_cursor: [*c]const i32 = values;
    _ = &values_cursor;
    var n_remaining: i64 = n_values;
    _ = &n_remaining;
    var out_i_cursor: i64 = bitmap.*.size_bits;
    _ = &out_i_cursor;
    var out_cursor: [*c]u8 = bitmap.*.buffer.data + @as(usize, @bitCast(@as(isize, @intCast(@divTrunc(bitmap.*.size_bits, @as(i64, 8))))));
    _ = &out_cursor;
    if (__helpers.signedRemainder(out_i_cursor, @as(i64, 8)) != @as(i64, 0)) {
        var n_partial_bits: i64 = _ArrowRoundUpToMultipleOf8(out_i_cursor) - out_i_cursor;
        _ = &n_partial_bits;
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < n_partial_bits) : (i += 1) {
                ArrowBitSetTo(bitmap.*.buffer.data, blk: {
                    const ref = &out_i_cursor;
                    const tmp = ref.*;
                    ref.* += 1;
                    break :blk tmp;
                }, @bitCast(@as(i8, @truncate(values[@bitCast(@as(isize, @intCast(i)))]))));
            }
        }
        out_cursor += 1;
        values_cursor += @as(usize, @bitCast(@as(isize, @intCast(n_partial_bits))));
        n_remaining -= n_partial_bits;
    }
    var n_full_bytes: i64 = @divTrunc(n_remaining, @as(i64, 8));
    _ = &n_full_bytes;
    {
        var i: i64 = 0;
        _ = &i;
        while (i < n_full_bytes) : (i += 1) {
            _ArrowBitmapPackInt32(values_cursor, out_cursor);
            values_cursor += @as(usize, @bitCast(@as(isize, @intCast(8))));
            out_cursor += 1;
        }
    }
    out_i_cursor += n_full_bytes * @as(i64, 8);
    n_remaining -= n_full_bytes * @as(i64, 8);
    if (n_remaining > @as(i64, 0)) {
        out_cursor.* = 0;
        {
            var i: c_int = 0;
            _ = &i;
            while (@as(i64, i) < n_remaining) : (i += 1) {
                ArrowBitSetTo(bitmap.*.buffer.data, blk: {
                    const ref = &out_i_cursor;
                    const tmp = ref.*;
                    ref.* += 1;
                    break :blk tmp;
                }, @bitCast(@as(i8, @truncate(values_cursor[@bitCast(@as(isize, @intCast(i)))]))));
            }
        }
        out_cursor += 1;
    }
    bitmap.*.size_bits += n_values;
    bitmap.*.buffer.size_bytes = @divExact(@as(c_long, @bitCast(@intFromPtr(out_cursor) -% @intFromPtr(bitmap.*.buffer.data))), @sizeOf(u8));
}
pub fn ArrowBitmapReset(arg_bitmap: [*c]struct_ArrowBitmap) callconv(.c) void {
    var bitmap = arg_bitmap;
    _ = &bitmap;
    ArrowBufferReset(&bitmap.*.buffer);
    bitmap.*.size_bits = 0;
}
pub extern fn ArrowArrayInitFromType(array: [*c]struct_ArrowArray, storage_type: enum_ArrowType) ArrowErrorCode;
pub extern fn ArrowArrayInitFromSchema(array: [*c]struct_ArrowArray, schema: [*c]const struct_ArrowSchema, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayInitFromArrayView(array: [*c]struct_ArrowArray, array_view: [*c]const struct_ArrowArrayView, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayAllocateChildren(array: [*c]struct_ArrowArray, n_children: i64) ArrowErrorCode;
pub extern fn ArrowArrayAllocateDictionary(array: [*c]struct_ArrowArray) ArrowErrorCode;
pub extern fn ArrowArraySetValidityBitmap(array: [*c]struct_ArrowArray, bitmap: [*c]struct_ArrowBitmap) void;
pub extern fn ArrowArraySetBuffer(array: [*c]struct_ArrowArray, i: i64, buffer: [*c]struct_ArrowBuffer) ArrowErrorCode;
pub fn ArrowArrayAddVariadicBuffers(arg_array: [*c]struct_ArrowArray, arg_n_buffers: i32) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var n_buffers = arg_n_buffers;
    _ = &n_buffers;
    const n_current_bufs: i32 = ArrowArrayVariadicBufferCount(array);
    _ = &n_current_bufs;
    const nvariadic_bufs_needed: i32 = n_current_bufs + n_buffers;
    _ = &nvariadic_bufs_needed;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    private_data.*.variadic_buffers = @ptrCast(@alignCast(ArrowRealloc(@ptrCast(@alignCast(private_data.*.variadic_buffers)), @bitCast(@as(c_ulong, @truncate(@sizeOf(struct_ArrowBuffer) *% @as(c_ulong, @bitCast(@as(c_long, nvariadic_bufs_needed)))))))));
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.variadic_buffers))) == @as(?*anyopaque, null)) {
        return ENOMEM;
    }
    private_data.*.n_variadic_buffers = nvariadic_bufs_needed;
    array.*.n_buffers = (NANOARROW_BINARY_VIEW_FIXED_BUFFERS + @as(c_int, 1)) + nvariadic_bufs_needed;
    private_data.*.buffer_data = @ptrCast(@alignCast(ArrowRealloc(@ptrCast(@alignCast(private_data.*.buffer_data)), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, @bitCast(@as(c_long, array.*.n_buffers))) *% @sizeOf(?*anyopaque)))))));
    {
        var i: i32 = n_current_bufs;
        _ = &i;
        while (i < nvariadic_bufs_needed) : (i += 1) {
            ArrowBufferInit(&private_data.*.variadic_buffers[@bitCast(@as(isize, @intCast(i)))]);
            private_data.*.buffer_data[@bitCast(@as(isize, @intCast(NANOARROW_BINARY_VIEW_FIXED_BUFFERS + i)))] = null;
        }
    }
    private_data.*.buffer_data[@bitCast(@as(isize, @intCast(NANOARROW_BINARY_VIEW_FIXED_BUFFERS + nvariadic_bufs_needed)))] = null;
    array.*.buffers = private_data.*.buffer_data;
    return NANOARROW_OK;
}
pub fn ArrowArrayValidityBitmap(arg_array: [*c]struct_ArrowArray) callconv(.c) [*c]struct_ArrowBitmap {
    var array = arg_array;
    _ = &array;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    return &private_data.*.bitmap;
}
pub fn ArrowArrayBuffer(arg_array: [*c]struct_ArrowArray, arg_i: i64) callconv(.c) [*c]struct_ArrowBuffer {
    var array = arg_array;
    _ = &array;
    var i = arg_i;
    _ = &i;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    while (true) {
        switch (i) {
            @as(i64, 0) => {
                return &private_data.*.bitmap.buffer;
            },
            @as(i64, 1) => {
                return @ptrCast(@alignCast(&private_data.*.buffers));
            },
            else => {
                if ((array.*.n_buffers > @as(i64, 3)) and (i == (array.*.n_buffers - @as(i64, 1)))) {
                    return @as([*c]struct_ArrowBuffer, @ptrCast(@alignCast(&private_data.*.buffers))) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1)))));
                } else if (array.*.n_buffers > @as(i64, 3)) {
                    return private_data.*.variadic_buffers + @as(usize, @bitCast(@as(isize, @intCast(i - @as(i64, 2)))));
                } else {
                    return (@as([*c]struct_ArrowBuffer, @ptrCast(@alignCast(&private_data.*.buffers))) + @as(usize, @bitCast(@as(isize, @intCast(i))))) - @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 1)))));
                }
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayStartAppending(arg_array: [*c]struct_ArrowArray) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_UNINITIALIZED) => {
                return EINVAL;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION), @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION) => {
                if (@as(c_int, private_data.*.union_type_id_is_child_index) != @as(c_int, 1)) {
                    return EINVAL;
                } else {
                    break;
                }
                break;
            },
            else => {
                break;
            },
        }
        break;
    }
    if (private_data.*.storage_type == @as(enum_ArrowType, NANOARROW_TYPE_UNINITIALIZED)) {
        return EINVAL;
    }
    {
        var i: c_int = 0;
        _ = &i;
        while (i < NANOARROW_MAX_FIXED_BUFFERS) : (i += 1) {
            if ((private_data.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))] == @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_DATA_OFFSET)) and (private_data.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))] == @as(i64, 64))) {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt64(ArrowArrayBuffer(array, i), 0);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
            } else if ((private_data.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))] == @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_DATA_OFFSET)) and (private_data.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))] == @as(i64, 32))) {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, i), 0);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
            }
        }
    }
    {
        var i: i64 = 0;
        _ = &i;
        while (i < array.*.n_children) : (i += 1) {
            while (true) {
                const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayStartAppending(array.*.children[@bitCast(@as(isize, @intCast(i)))]);
                _ = &errno_status__nanoarrow_unique_suffix;
                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                if (!false) break;
            }
        }
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(array.*.dictionary))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayStartAppending(array.*.dictionary);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    return NANOARROW_OK;
}
pub extern fn ArrowArrayReserve(array: [*c]struct_ArrowArray, additional_size_elements: i64) ArrowErrorCode;
pub fn ArrowArrayAppendNull(arg_array: [*c]struct_ArrowArray, arg_n: i64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var n = arg_n;
    _ = &n;
    return _ArrowArrayAppendEmptyInternal(array, n, 0);
}
pub fn ArrowArrayAppendEmpty(arg_array: [*c]struct_ArrowArray, arg_n: i64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var n = arg_n;
    _ = &n;
    return _ArrowArrayAppendEmptyInternal(array, n, 1);
}
pub fn ArrowArrayAppendInt(arg_array: [*c]struct_ArrowArray, arg_value: i64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
    _ = &data_buffer;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INT64) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i64)))));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT32) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if ((value >= @as(i64, -@as(c_int, 2147483647) - @as(c_int, 1))) and (value <= @as(i64, @as(c_int, 2147483647)))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT16) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if ((value >= @as(i64, -@as(c_int, 32767) - @as(c_int, 1))) and (value <= @as(i64, @as(c_int, 32767)))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt16(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if ((value >= @as(i64, -@as(c_int, 128))) and (value <= @as(i64, @as(c_int, 127)))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt8(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64), @as(enum_ArrowType, NANOARROW_TYPE_UINT32), @as(enum_ArrowType, NANOARROW_TYPE_UINT16), @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if ((value >= @as(i64, 0)) and (value <= @as(c_long, 9223372036854775807))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                return ArrowArrayAppendUInt(array, @bitCast(@as(c_long, value)));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendDouble(data_buffer, @floatFromInt(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFloat(data_buffer, @floatFromInt(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(@floatFromInt(value)));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = _ArrowArrayAppendBits(array, 1, @bitCast(@as(i8, @intFromBool(value != @as(i64, 0)))), 1);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayAppendUInt(arg_array: [*c]struct_ArrowArray, arg_value: u64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
    _ = &data_buffer;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(u64)))));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT32) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if (value <= @as(u64, @as(c_uint, 4294967295))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt32(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT16) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if (value <= @as(u64, @bitCast(@as(c_long, @as(c_int, 65535))))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt16(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if (value <= @as(u64, @bitCast(@as(c_long, @as(c_int, 255))))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt8(data_buffer, @truncate(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT64), @as(enum_ArrowType, NANOARROW_TYPE_INT32), @as(enum_ArrowType, NANOARROW_TYPE_INT16), @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if (value <= @as(u64, @bitCast(@as(c_long, @as(c_long, 9223372036854775807))))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                return ArrowArrayAppendInt(array, @bitCast(@as(c_ulong, @truncate(value))));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendDouble(data_buffer, @floatFromInt(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFloat(data_buffer, @floatFromInt(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(@floatFromInt(value)));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = _ArrowArrayAppendBits(array, 1, @bitCast(@as(i8, @intFromBool(value != @as(u64, 0)))), 1);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayAppendDouble(arg_array: [*c]struct_ArrowArray, arg_value: f64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
    _ = &data_buffer;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(&value)), @bitCast(@as(c_ulong, @truncate(@sizeOf(f64)))));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFloat(data_buffer, @floatCast(value));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendUInt16(data_buffer, ArrowFloatToHalfFloat(@floatCast(value)));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayAppendBytes(arg_array: [*c]struct_ArrowArray, arg_value: struct_ArrowBufferView) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    if ((private_data.*.storage_type == @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW)) or (private_data.*.storage_type == @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW))) {
        var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
        _ = &data_buffer;
        var bvt: union_ArrowBinaryView = undefined;
        _ = &bvt;
        bvt.inlined.size = @truncate(value.size_bytes);
        if (value.size_bytes <= @as(i64, NANOARROW_BINARY_VIEW_INLINE_SIZE)) {
            _ = memcpy(@ptrCast(@alignCast(@as([*c]u8, @ptrCast(@alignCast(&bvt.inlined.data))))), @ptrCast(@alignCast(value.data.as_char)), @bitCast(@as(c_long, value.size_bytes)));
            _ = memset(@ptrCast(@alignCast(@as([*c]u8, @ptrCast(@alignCast(&bvt.inlined.data))) + @as(usize, @bitCast(@as(isize, @intCast(bvt.inlined.size)))))), 0, @bitCast(@as(c_long, NANOARROW_BINARY_VIEW_INLINE_SIZE - bvt.inlined.size)));
        } else {
            var current_n_vbufs: i32 = ArrowArrayVariadicBufferCount(array);
            _ = &current_n_vbufs;
            if ((current_n_vbufs == @as(c_int, 0)) or ((private_data.*.variadic_buffers[@bitCast(@as(isize, @intCast(current_n_vbufs - @as(c_int, 1))))].size_bytes + value.size_bytes) > @as(i64, @as(c_int, 32) << @intCast(@as(c_int, 10))))) {
                const additional_bufs_needed: i32 = 1;
                _ = &additional_bufs_needed;
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayAddVariadicBuffers(array, additional_bufs_needed);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                current_n_vbufs += additional_bufs_needed;
            }
            const buf_index: i32 = current_n_vbufs - @as(c_int, 1);
            _ = &buf_index;
            var variadic_buf: [*c]struct_ArrowBuffer = &private_data.*.variadic_buffers[@bitCast(@as(isize, @intCast(buf_index)))];
            _ = &variadic_buf;
            _ = memcpy(@ptrCast(@alignCast(@as([*c]u8, @ptrCast(@alignCast(&bvt.ref.prefix))))), @ptrCast(@alignCast(value.data.as_char)), NANOARROW_BINARY_VIEW_PREFIX_SIZE);
            bvt.ref.buffer_index = buf_index;
            bvt.ref.offset = @truncate(variadic_buf.*.size_bytes);
            while (true) {
                const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(variadic_buf, @ptrCast(@alignCast(value.data.as_char)), value.size_bytes);
                _ = &errno_status__nanoarrow_unique_suffix;
                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                if (!false) break;
            }
        }
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(&bvt)), @bitCast(@as(c_ulong, @truncate(@sizeOf(@TypeOf(bvt))))));
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    } else {
        var offset_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
        _ = &offset_buffer;
        var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, @as(c_int, 1) + @intFromBool(private_data.*.storage_type != @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_BINARY)));
        _ = &data_buffer;
        var offset: i32 = undefined;
        _ = &offset;
        var large_offset: i64 = undefined;
        _ = &large_offset;
        var fixed_size_bytes: i64 = @divTrunc(private_data.*.layout.element_size_bits[@as(c_int, 1)], @as(i64, 8));
        _ = &fixed_size_bytes;
        while (true) {
            switch (private_data.*.storage_type) {
                @as(enum_ArrowType, NANOARROW_TYPE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_BINARY) => {
                    offset = @as([*c]i32, @ptrCast(@alignCast(offset_buffer.*.data)))[@bitCast(@as(isize, @intCast(array.*.length)))];
                    if ((@as(i64, offset) + value.size_bytes) > @as(i64, @as(c_int, 2147483647))) {
                        return EOVERFLOW;
                    }
                    offset += @truncate(value.size_bytes);
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(offset_buffer, @ptrCast(@alignCast(&offset)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i32)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, value.data.data, value.size_bytes);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                },
                @as(enum_ArrowType, NANOARROW_TYPE_LARGE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_BINARY) => {
                    large_offset = @as([*c]i64, @ptrCast(@alignCast(offset_buffer.*.data)))[@bitCast(@as(isize, @intCast(array.*.length)))];
                    large_offset += value.size_bytes;
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(offset_buffer, @ptrCast(@alignCast(&large_offset)), @bitCast(@as(c_ulong, @truncate(@sizeOf(i64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, value.data.data, value.size_bytes);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                },
                @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_BINARY) => {
                    if (value.size_bytes != fixed_size_bytes) {
                        return EINVAL;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, value.data.data, value.size_bytes);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                },
                else => {
                    return EINVAL;
                },
            }
            break;
        }
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayAppendString(arg_array: [*c]struct_ArrowArray, arg_value: struct_ArrowStringView) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var buffer_view: struct_ArrowBufferView = undefined;
    _ = &buffer_view;
    buffer_view.data.data = @ptrCast(@alignCast(value.data));
    buffer_view.size_bytes = value.size_bytes;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_BINARY), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_BINARY), @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW) => {
                return ArrowArrayAppendBytes(array, buffer_view);
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayAppendInterval(arg_array: [*c]struct_ArrowArray, arg_value: [*c]const struct_ArrowInterval) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
    _ = &data_buffer;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS) => {
                {
                    if (value.*.type != @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS)) {
                        return EINVAL;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, value.*.months);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_DAY_TIME) => {
                {
                    if (value.*.type != @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_DAY_TIME)) {
                        return EINVAL;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, value.*.days);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, value.*.ms);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO) => {
                {
                    if (value.*.type != @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO)) {
                        return EINVAL;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, value.*.months);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(data_buffer, value.*.days);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt64(data_buffer, value.*.ns);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayAppendDecimal(arg_array: [*c]struct_ArrowArray, arg_value: [*c]const struct_ArrowDecimal) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var value = arg_value;
    _ = &value;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var data_buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, 1);
    _ = &data_buffer;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL32) => {
                if (value.*.n_words != @as(c_int, 0)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@sizeOf(u32)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 1)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 2)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 2) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 4)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 4) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                return EINVAL;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL64) => {
                if (value.*.n_words != @as(c_int, 1)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 2)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 2) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 4)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 4) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                return EINVAL;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL128) => {
                if (value.*.n_words != @as(c_int, 2)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 2) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                if (value.*.n_words != @as(c_int, 4)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 4) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                return EINVAL;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL256) => {
                if (value.*.n_words != @as(c_int, 4)) {
                    return EINVAL;
                } else {
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppend(data_buffer, @ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&value.*.words))))), @bitCast(@as(c_ulong, @truncate(@as(c_ulong, 4) *% @sizeOf(u64)))));
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    break;
                }
                return EINVAL;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayFinishElement(arg_array: [*c]struct_ArrowArray) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var child_length: i64 = undefined;
    _ = &child_length;
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_LIST), @as(enum_ArrowType, NANOARROW_TYPE_MAP) => {
                child_length = array.*.children[@as(c_int, 0)].*.length;
                if (child_length > @as(i64, @as(c_int, 2147483647))) {
                    return EOVERFLOW;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), @truncate(child_length));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST) => {
                child_length = array.*.children[@as(c_int, 0)].*.length;
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt64(ArrowArrayBuffer(array, 1), child_length);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_LIST) => {
                child_length = array.*.children[@as(c_int, 0)].*.length;
                if (child_length != ((array.*.length + @as(i64, 1)) * private_data.*.layout.child_size_elements)) {
                    return EINVAL;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LIST_VIEW) => {
                {
                    child_length = array.*.children[@as(c_int, 0)].*.length;
                    if (child_length > @as(i64, @as(c_int, 2147483647))) {
                        return EOVERFLOW;
                    }
                    const last_valid_offset: i32 = @truncate(private_data.*.list_view_offset);
                    _ = &last_valid_offset;
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), last_valid_offset);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, 2), @as(i32, @truncate(child_length)) - last_valid_offset);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    private_data.*.list_view_offset = child_length;
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST_VIEW) => {
                {
                    child_length = array.*.children[@as(c_int, 0)].*.length;
                    const last_valid_offset: i64 = private_data.*.list_view_offset;
                    _ = &last_valid_offset;
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt64(ArrowArrayBuffer(array, 1), last_valid_offset);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt64(ArrowArrayBuffer(array, 2), child_length - last_valid_offset);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    private_data.*.list_view_offset = child_length;
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRUCT) => {
                {
                    var i: i64 = 0;
                    _ = &i;
                    while (i < array.*.n_children) : (i += 1) {
                        child_length = array.*.children[@bitCast(@as(isize, @intCast(i)))].*.length;
                        if (child_length != (array.*.length + @as(i64, 1))) {
                            return EINVAL;
                        }
                    }
                }
                break;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapAppend(ArrowArrayValidityBitmap(array), 1, 1);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayFinishUnionElement(arg_array: [*c]struct_ArrowArray, arg_type_id: i8) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var type_id = arg_type_id;
    _ = &type_id;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var child_index: i64 = _ArrowArrayUnionChildIndex(array, type_id);
    _ = &child_index;
    if ((child_index < @as(i64, 0)) or (child_index >= array.*.n_children)) {
        return EINVAL;
    }
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = if ((array.*.children[@bitCast(@as(isize, @intCast(child_index)))].*.length >= @as(i64, 0)) and (array.*.children[@bitCast(@as(isize, @intCast(child_index)))].*.length <= @as(i64, @as(c_int, 2147483647)))) NANOARROW_OK else EINVAL;
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), @as(i32, @truncate(array.*.children[@bitCast(@as(isize, @intCast(child_index)))].*.length)) - @as(c_int, 1));
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                {
                    var i: i64 = 0;
                    _ = &i;
                    while (i < array.*.n_children) : (i += 1) {
                        if ((i == child_index) or (array.*.children[@bitCast(@as(isize, @intCast(i)))].*.length == (array.*.length + @as(i64, 1)))) {
                            continue;
                        }
                        if (array.*.children[@bitCast(@as(isize, @intCast(i)))].*.length != array.*.length) {
                            return EINVAL;
                        }
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayAppendEmpty(array.*.children[@bitCast(@as(isize, @intCast(i)))], 1);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                    }
                }
                break;
            },
            else => {
                return EINVAL;
            },
        }
        break;
    }
    while (true) {
        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt8(ArrowArrayBuffer(array, 0), type_id);
        _ = &errno_status__nanoarrow_unique_suffix;
        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
        if (!false) break;
    }
    array.*.length += 1;
    return NANOARROW_OK;
}
pub fn ArrowArrayShrinkToFit(arg_array: [*c]struct_ArrowArray) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    {
        var i: i64 = 0;
        _ = &i;
        while (i < @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) : (i += 1) {
            var buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, i);
            _ = &buffer;
            while (true) {
                const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferResize(buffer, buffer.*.size_bytes, 1);
                _ = &errno_status__nanoarrow_unique_suffix;
                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                if (!false) break;
            }
        }
    }
    {
        var i: i64 = 0;
        _ = &i;
        while (i < array.*.n_children) : (i += 1) {
            while (true) {
                const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayShrinkToFit(array.*.children[@bitCast(@as(isize, @intCast(i)))]);
                _ = &errno_status__nanoarrow_unique_suffix;
                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                if (!false) break;
            }
        }
    }
    if (@as(?*anyopaque, @ptrCast(@alignCast(array.*.dictionary))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayShrinkToFit(array.*.dictionary);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    return NANOARROW_OK;
}
pub extern fn ArrowArrayFinishBuildingDefault(array: [*c]struct_ArrowArray, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayFinishBuilding(array: [*c]struct_ArrowArray, validation_level: enum_ArrowValidationLevel, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayViewInitFromType(array_view: [*c]struct_ArrowArrayView, storage_type: enum_ArrowType) void;
pub fn ArrowArrayViewMove(arg_src: [*c]struct_ArrowArrayView, arg_dst: [*c]struct_ArrowArrayView) callconv(.c) void {
    var src = arg_src;
    _ = &src;
    var dst = arg_dst;
    _ = &dst;
    _ = memcpy(@ptrCast(@alignCast(dst)), @ptrCast(@alignCast(src)), @sizeOf(struct_ArrowArrayView));
    ArrowArrayViewInitFromType(src, NANOARROW_TYPE_UNINITIALIZED);
}
pub extern fn ArrowArrayViewInitFromSchema(array_view: [*c]struct_ArrowArrayView, schema: [*c]const struct_ArrowSchema, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayViewAllocateChildren(array_view: [*c]struct_ArrowArrayView, n_children: i64) ArrowErrorCode;
pub extern fn ArrowArrayViewAllocateDictionary(array_view: [*c]struct_ArrowArrayView) ArrowErrorCode;
pub extern fn ArrowArrayViewSetLength(array_view: [*c]struct_ArrowArrayView, length: i64) void;
pub extern fn ArrowArrayViewSetArray(array_view: [*c]struct_ArrowArrayView, array: [*c]const struct_ArrowArray, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayViewSetArrayMinimal(array_view: [*c]struct_ArrowArrayView, array: [*c]const struct_ArrowArray, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub fn ArrowArrayViewGetNumBuffers(arg_array_view: [*c]struct_ArrowArrayView) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                return (NANOARROW_BINARY_VIEW_FIXED_BUFFERS + array_view.*.n_variadic_buffers) + @as(c_int, 1);
            },
            else => {
                break;
            },
        }
        break;
    }
    var n_buffers: i64 = 0;
    _ = &n_buffers;
    {
        var i: c_int = 0;
        _ = &i;
        while (i < NANOARROW_MAX_FIXED_BUFFERS) : (i += 1) {
            if (array_view.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))] == @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_NONE)) {
                break;
            }
            n_buffers += 1;
        }
    }
    return n_buffers;
}
pub fn ArrowArrayViewGetBufferView(arg_array_view: [*c]struct_ArrowArrayView, arg_i: i64) callconv(.c) struct_ArrowBufferView {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                if (i < @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return array_view.*.buffer_views[@bitCast(@as(isize, @intCast(i)))];
                } else if (i >= @as(i64, array_view.*.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    var view: struct_ArrowBufferView = undefined;
                    _ = &view;
                    view.data.as_int64 = array_view.*.variadic_buffer_sizes;
                    view.size_bytes = @bitCast(@as(c_ulong, @truncate(@as(c_ulong, @bitCast(@as(c_long, array_view.*.n_variadic_buffers))) *% @sizeOf(f64))));
                    return view;
                } else {
                    var view: struct_ArrowBufferView = undefined;
                    _ = &view;
                    view.data.data = array_view.*.variadic_buffers[@bitCast(@as(isize, @intCast(i - @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS))))];
                    view.size_bytes = array_view.*.variadic_buffer_sizes[@bitCast(@as(isize, @intCast(i - @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS))))];
                    return view;
                }
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    var view: struct_ArrowBufferView = undefined;
                    _ = &view;
                    view.data.data = null;
                    view.size_bytes = 0;
                    return view;
                } else {
                    return array_view.*.buffer_views[@bitCast(@as(isize, @intCast(i)))];
                }
            },
            else => {
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    var view: struct_ArrowBufferView = undefined;
                    _ = &view;
                    view.data.data = null;
                    view.size_bytes = 0;
                    return view;
                } else {
                    return array_view.*.buffer_views[@bitCast(@as(isize, @intCast(i)))];
                }
            },
        }
        break;
    }
    return undefined;
}
pub export fn ArrowArrayViewGetBufferType(arg_array_view: [*c]struct_ArrowArrayView, arg_i: i64) enum_ArrowBufferType {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                if (i < @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return array_view.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))];
                } else if (i == @as(i64, array_view.*.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return NANOARROW_BUFFER_TYPE_VARIADIC_SIZE;
                } else {
                    return NANOARROW_BUFFER_TYPE_VARIADIC_DATA;
                }
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return NANOARROW_BUFFER_TYPE_NONE;
                } else {
                    return array_view.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))];
                }
            },
            else => {
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return NANOARROW_BUFFER_TYPE_NONE;
                } else {
                    return array_view.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))];
                }
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetBufferDataType(arg_array_view: [*c]struct_ArrowArrayView, arg_i: i64) callconv(.c) enum_ArrowType {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                if (i < @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return array_view.*.layout.buffer_data_type[@bitCast(@as(isize, @intCast(i)))];
                } else if (i >= @as(i64, array_view.*.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return NANOARROW_TYPE_INT64;
                } else if (array_view.*.storage_type == @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW)) {
                    return NANOARROW_TYPE_BINARY;
                } else {
                    return NANOARROW_TYPE_STRING;
                }
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return NANOARROW_TYPE_UNINITIALIZED;
                } else {
                    return array_view.*.layout.buffer_data_type[@bitCast(@as(isize, @intCast(i)))];
                }
            },
            else => {
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return NANOARROW_TYPE_UNINITIALIZED;
                } else {
                    return array_view.*.layout.buffer_data_type[@bitCast(@as(isize, @intCast(i)))];
                }
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetBufferElementSizeBits(arg_array_view: [*c]struct_ArrowArrayView, arg_i: i64) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW) => {
                if (i < @as(i64, NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return array_view.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))];
                } else if (i >= @as(i64, array_view.*.n_variadic_buffers + NANOARROW_BINARY_VIEW_FIXED_BUFFERS)) {
                    return @bitCast(@as(c_ulong, @truncate(@sizeOf(i64) *% @as(c_ulong, 8))));
                } else {
                    return 0;
                }
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return 0;
                } else {
                    return array_view.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))];
                }
            },
            else => {
                if (i >= @as(i64, NANOARROW_MAX_FIXED_BUFFERS)) {
                    return 0;
                } else {
                    return array_view.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))];
                }
            },
        }
        break;
    }
    return undefined;
}
pub extern fn ArrowArrayViewValidate(array_view: [*c]struct_ArrowArrayView, validation_level: enum_ArrowValidationLevel, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayViewCompare(actual: [*c]const struct_ArrowArrayView, expected: [*c]const struct_ArrowArrayView, level: enum_ArrowCompareLevel, out: [*c]c_int, reason: [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn ArrowArrayViewReset(array_view: [*c]struct_ArrowArrayView) void;
pub fn ArrowArrayViewIsNull(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i8 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var validity_buffer: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 0)].data.as_uint8;
    _ = &validity_buffer;
    i += array_view.*.offset;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_NA) => {
                return 1;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION), @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                return 0;
            },
            else => {
                return @intFromBool((@as(?*anyopaque, @ptrCast(@alignCast(@constCast(validity_buffer)))) != @as(?*anyopaque, null)) and !(@as(c_int, ArrowBitGet(validity_buffer, i)) != 0));
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewComputeNullCount(arg_array_view: [*c]const struct_ArrowArrayView) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    if (array_view.*.length == @as(i64, 0)) {
        return 0;
    }
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_NA) => {
                return array_view.*.length;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION), @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                return 0;
            },
            else => {
                break;
            },
        }
        break;
    }
    var validity_buffer: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 0)].data.as_uint8;
    _ = &validity_buffer;
    if (@as(?*anyopaque, @ptrCast(@alignCast(@constCast(validity_buffer)))) == @as(?*anyopaque, null)) {
        return 0;
    }
    return array_view.*.length - ArrowBitCountSet(validity_buffer, array_view.*.offset, array_view.*.length);
}
pub fn ArrowArrayViewUnionTypeId(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i8 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION), @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                return array_view.*.buffer_views[@as(c_int, 0)].data.as_int8[@bitCast(@as(isize, @intCast(array_view.*.offset + i)))];
            },
            else => {
                return @truncate(-@as(c_int, 1));
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewUnionChildIndex(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i8 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var type_id: i8 = ArrowArrayViewUnionTypeId(array_view, i);
    _ = &type_id;
    if (@as(?*anyopaque, @ptrCast(@alignCast(array_view.*.union_type_id_map))) == @as(?*anyopaque, null)) {
        return type_id;
    } else {
        return array_view.*.union_type_id_map[@bitCast(@as(isize, @intCast(type_id)))];
    }
}
pub fn ArrowArrayViewUnionChildOffset(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION) => {
                return array_view.*.buffer_views[@as(c_int, 1)].data.as_int32[@bitCast(@as(isize, @intCast(array_view.*.offset + i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                return array_view.*.offset + i;
            },
            else => {
                return -@as(c_int, 1);
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetIntUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var data_view: [*c]const struct_ArrowBufferView = &array_view.*.buffer_views[@as(c_int, 1)];
    _ = &data_view;
    i += array_view.*.offset;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INT64) => {
                return data_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64) => {
                return @bitCast(@as(c_ulong, @truncate(data_view.*.data.as_uint64[@bitCast(@as(isize, @intCast(i)))])));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS), @as(enum_ArrowType, NANOARROW_TYPE_INT32) => {
                return data_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT32) => {
                return data_view.*.data.as_uint32[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT16) => {
                return data_view.*.data.as_int16[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT16) => {
                return data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                return data_view.*.data.as_int8[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                return data_view.*.data.as_uint8[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                return @intFromFloat(data_view.*.data.as_double[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                return @intFromFloat(data_view.*.data.as_float[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                return @intFromFloat(ArrowHalfFloatToFloat(data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                return ArrowBitGet(data_view.*.data.as_uint8, i);
            },
            else => {
                return @as(c_long, 9223372036854775807);
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetUIntUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) u64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    i += array_view.*.offset;
    var data_view: [*c]const struct_ArrowBufferView = &array_view.*.buffer_views[@as(c_int, 1)];
    _ = &data_view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INT64) => {
                return @bitCast(@as(c_long, data_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64) => {
                return data_view.*.data.as_uint64[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS), @as(enum_ArrowType, NANOARROW_TYPE_INT32) => {
                return @bitCast(@as(c_long, data_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT32) => {
                return data_view.*.data.as_uint32[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT16) => {
                return @bitCast(@as(c_long, data_view.*.data.as_int16[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT16) => {
                return data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                return @bitCast(@as(c_long, data_view.*.data.as_int8[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                return data_view.*.data.as_uint8[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                return @intFromFloat(data_view.*.data.as_double[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                return @intFromFloat(data_view.*.data.as_float[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                return @intFromFloat(ArrowHalfFloatToFloat(data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                return @bitCast(@as(c_long, ArrowBitGet(data_view.*.data.as_uint8, i)));
            },
            else => {
                return @as(c_ulong, 18446744073709551615);
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetDoubleUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) f64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    i += array_view.*.offset;
    var data_view: [*c]const struct_ArrowBufferView = &array_view.*.buffer_views[@as(c_int, 1)];
    _ = &data_view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INT64) => {
                return @floatFromInt(data_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT64) => {
                return @floatFromInt(data_view.*.data.as_uint64[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT32) => {
                return @floatFromInt(data_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT32) => {
                return @floatFromInt(data_view.*.data.as_uint32[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT16) => {
                return @floatFromInt(data_view.*.data.as_int16[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT16) => {
                return @floatFromInt(data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INT8) => {
                return @floatFromInt(data_view.*.data.as_int8[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_UINT8) => {
                return @floatFromInt(data_view.*.data.as_uint8[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DOUBLE) => {
                return data_view.*.data.as_double[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FLOAT) => {
                return @floatCast(data_view.*.data.as_float[@bitCast(@as(isize, @intCast(i)))]);
            },
            @as(enum_ArrowType, NANOARROW_TYPE_HALF_FLOAT) => {
                return @floatCast(ArrowHalfFloatToFloat(data_view.*.data.as_uint16[@bitCast(@as(isize, @intCast(i)))]));
            },
            @as(enum_ArrowType, NANOARROW_TYPE_BOOL) => {
                return @floatFromInt(ArrowBitGet(data_view.*.data.as_uint8, i));
            },
            else => {
                return __DBL_MAX__;
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetStringUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) struct_ArrowStringView {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    i += array_view.*.offset;
    var offsets_view: [*c]const struct_ArrowBufferView = &array_view.*.buffer_views[@as(c_int, 1)];
    _ = &offsets_view;
    var data_view: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 2)].data.as_char;
    _ = &data_view;
    var view: struct_ArrowStringView = undefined;
    _ = &view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_BINARY) => {
                view.data = data_view + @as(usize, @bitCast(@as(isize, @intCast(offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]))));
                view.size_bytes = @as(i64, offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i + @as(i64, 1))))]) - @as(i64, offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]);
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_BINARY) => {
                view.data = data_view + @as(usize, @bitCast(@as(isize, @intCast(offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))]))));
                view.size_bytes = offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i + @as(i64, 1))))] - offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))];
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_BINARY) => {
                view.size_bytes = @divTrunc(array_view.*.layout.element_size_bits[@as(c_int, 1)], @as(i64, 8));
                view.data = array_view.*.buffer_views[@as(c_int, 1)].data.as_char + @as(usize, @bitCast(@as(isize, @intCast(i * view.size_bytes))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW) => {
                {
                    var buf_view: struct_ArrowBufferView = ArrowArrayViewGetBytesFromViewArrayUnsafe(array_view, i);
                    _ = &buf_view;
                    view.data = buf_view.data.as_char;
                    view.size_bytes = buf_view.size_bytes;
                    break;
                }
            },
            else => {
                view.data = null;
                view.size_bytes = 0;
                break;
            },
        }
        break;
    }
    return view;
}
pub fn ArrowArrayViewGetBytesUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) struct_ArrowBufferView {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    i += array_view.*.offset;
    var offsets_view: [*c]const struct_ArrowBufferView = &array_view.*.buffer_views[@as(c_int, 1)];
    _ = &offsets_view;
    var data_view: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 2)].data.as_uint8;
    _ = &data_view;
    var view: struct_ArrowBufferView = undefined;
    _ = &view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_BINARY) => {
                view.size_bytes = @as(i64, offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i + @as(i64, 1))))]) - @as(i64, offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]);
                view.data.as_uint8 = data_view + @as(usize, @bitCast(@as(isize, @intCast(offsets_view.*.data.as_int32[@bitCast(@as(isize, @intCast(i)))]))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_STRING), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_BINARY) => {
                view.size_bytes = offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i + @as(i64, 1))))] - offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))];
                view.data.as_uint8 = data_view + @as(usize, @bitCast(@as(isize, @intCast(offsets_view.*.data.as_int64[@bitCast(@as(isize, @intCast(i)))]))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_BINARY) => {
                view.size_bytes = @divTrunc(array_view.*.layout.element_size_bits[@as(c_int, 1)], @as(i64, 8));
                view.data.as_uint8 = array_view.*.buffer_views[@as(c_int, 1)].data.as_uint8 + @as(usize, @bitCast(@as(isize, @intCast(i * view.size_bytes))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRING_VIEW), @as(enum_ArrowType, NANOARROW_TYPE_BINARY_VIEW) => {
                view = ArrowArrayViewGetBytesFromViewArrayUnsafe(array_view, i);
                break;
            },
            else => {
                view.data.data = null;
                view.size_bytes = 0;
                break;
            },
        }
        break;
    }
    return view;
}
pub fn ArrowArrayViewGetDecimalUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64, arg_out: [*c]struct_ArrowDecimal) callconv(.c) void {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var out = arg_out;
    _ = &out;
    i += array_view.*.offset;
    var data_view: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 1)].data.as_uint8;
    _ = &data_view;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL32) => {
                ArrowDecimalSetBytes(out, data_view + @as(usize, @bitCast(@as(isize, @intCast(i * @as(i64, 4))))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL64) => {
                ArrowDecimalSetBytes(out, data_view + @as(usize, @bitCast(@as(isize, @intCast(i * @as(i64, 8))))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL128) => {
                ArrowDecimalSetBytes(out, data_view + @as(usize, @bitCast(@as(isize, @intCast(i * @as(i64, 16))))));
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DECIMAL256) => {
                ArrowDecimalSetBytes(out, data_view + @as(usize, @bitCast(@as(isize, @intCast(i * @as(i64, 32))))));
                break;
            },
            else => {
                _ = memset(@ptrCast(@alignCast(@as([*c]u64, @ptrCast(@alignCast(&out.*.words))))), 0, @sizeOf(@TypeOf(out.*.words)));
                break;
            },
        }
        break;
    }
}
pub extern fn ArrowBasicArrayStreamInit(array_stream: [*c]struct_ArrowArrayStream, schema: [*c]struct_ArrowSchema, n_arrays: i64) ArrowErrorCode;
pub extern fn ArrowBasicArrayStreamSetArray(array_stream: [*c]struct_ArrowArrayStream, i: i64, array: [*c]struct_ArrowArray) void;
pub extern fn ArrowBasicArrayStreamValidate(array_stream: [*c]const struct_ArrowArrayStream, @"error": [*c]struct_ArrowError) ArrowErrorCode;
pub extern fn __errno_location() [*c]c_int;
pub fn ArrowResolveChunk32(arg_index_1: i32, arg_offsets: [*c]const i32, arg_lo: i32, arg_hi: i32) callconv(.c) i64 {
    var index_1 = arg_index_1;
    _ = &index_1;
    var offsets = arg_offsets;
    _ = &offsets;
    var lo = arg_lo;
    _ = &lo;
    var hi = arg_hi;
    _ = &hi;
    var n: i32 = hi - lo;
    _ = &n;
    while (true) {
        const m: i32 = n >> @intCast(@as(c_int, 1));
        _ = &m;
        const mid: i32 = lo + m;
        _ = &mid;
        if (index_1 >= offsets[@bitCast(@as(isize, @intCast(mid)))]) {
            lo = mid;
            n -= m;
        } else {
            n = m;
        }
        if (!(n > @as(c_int, 1))) break;
    }
    return lo;
}
pub fn _ArrowGrowByFactor(arg_current_capacity: i64, arg_new_capacity: i64) callconv(.c) i64 {
    var current_capacity = arg_current_capacity;
    _ = &current_capacity;
    var new_capacity = arg_new_capacity;
    _ = &new_capacity;
    var doubled_capacity: i64 = current_capacity * @as(i64, 2);
    _ = &doubled_capacity;
    if (doubled_capacity > new_capacity) {
        return doubled_capacity;
    } else {
        return new_capacity;
    }
}
pub const _ArrowkBitmask: [8]u8 = [8]u8{
    1,
    2,
    4,
    8,
    16,
    32,
    64,
    128,
};
pub const _ArrowkFlippedBitmask: [8]u8 = [8]u8{
    254,
    253,
    251,
    247,
    239,
    223,
    191,
    127,
};
pub const _ArrowkPrecedingBitmask: [8]u8 = [8]u8{
    0,
    1,
    3,
    7,
    15,
    31,
    63,
    127,
};
pub const _ArrowkTrailingBitmask: [8]u8 = [8]u8{
    255,
    254,
    252,
    248,
    240,
    224,
    192,
    128,
};
pub const _ArrowkBytePopcount: [256]u8 = [256]u8{
    0,
    1,
    1,
    2,
    1,
    2,
    2,
    3,
    1,
    2,
    2,
    3,
    2,
    3,
    3,
    4,
    1,
    2,
    2,
    3,
    2,
    3,
    3,
    4,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    1,
    2,
    2,
    3,
    2,
    3,
    3,
    4,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    1,
    2,
    2,
    3,
    2,
    3,
    3,
    4,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    4,
    5,
    5,
    6,
    5,
    6,
    6,
    7,
    1,
    2,
    2,
    3,
    2,
    3,
    3,
    4,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    4,
    5,
    5,
    6,
    5,
    6,
    6,
    7,
    2,
    3,
    3,
    4,
    3,
    4,
    4,
    5,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    4,
    5,
    5,
    6,
    5,
    6,
    6,
    7,
    3,
    4,
    4,
    5,
    4,
    5,
    5,
    6,
    4,
    5,
    5,
    6,
    5,
    6,
    6,
    7,
    4,
    5,
    5,
    6,
    5,
    6,
    6,
    7,
    5,
    6,
    6,
    7,
    6,
    7,
    7,
    8,
};
pub fn _ArrowRoundUpToMultipleOf8(arg_value: i64) callconv(.c) i64 {
    var value = arg_value;
    _ = &value;
    return (value + @as(i64, 7)) & ~@as(i64, @as(c_int, 7));
}
pub fn _ArrowRoundDownToMultipleOf8(arg_value: i64) callconv(.c) i64 {
    var value = arg_value;
    _ = &value;
    return @divTrunc(value, @as(i64, 8)) * @as(i64, 8);
}
pub fn _ArrowBytesForBits(arg_bits: i64) callconv(.c) i64 {
    var bits = arg_bits;
    _ = &bits;
    return (bits >> @intCast(@as(i64, 3))) + @as(i64, @intFromBool((bits & @as(i64, 7)) != @as(i64, 0)));
}
pub fn _ArrowBitsUnpackInt8(word: u8, arg_out: [*c]i8) callconv(.c) void {
    _ = &word;
    var out = arg_out;
    _ = &out;
    out[@as(c_int, 0)] = @intFromBool((@as(c_int, word) & @as(c_int, 1)) != @as(c_int, 0));
    out[@as(c_int, 1)] = @intFromBool((@as(c_int, word) & @as(c_int, 2)) != @as(c_int, 0));
    out[@as(c_int, 2)] = @intFromBool((@as(c_int, word) & @as(c_int, 4)) != @as(c_int, 0));
    out[@as(c_int, 3)] = @intFromBool((@as(c_int, word) & @as(c_int, 8)) != @as(c_int, 0));
    out[@as(c_int, 4)] = @intFromBool((@as(c_int, word) & @as(c_int, 16)) != @as(c_int, 0));
    out[@as(c_int, 5)] = @intFromBool((@as(c_int, word) & @as(c_int, 32)) != @as(c_int, 0));
    out[@as(c_int, 6)] = @intFromBool((@as(c_int, word) & @as(c_int, 64)) != @as(c_int, 0));
    out[@as(c_int, 7)] = @intFromBool((@as(c_int, word) & @as(c_int, 128)) != @as(c_int, 0));
}
pub fn _ArrowBitsUnpackInt32(word: u8, arg_out: [*c]i32) callconv(.c) void {
    _ = &word;
    var out = arg_out;
    _ = &out;
    out[@as(c_int, 0)] = @intFromBool((@as(c_int, word) & @as(c_int, 1)) != @as(c_int, 0));
    out[@as(c_int, 1)] = @intFromBool((@as(c_int, word) & @as(c_int, 2)) != @as(c_int, 0));
    out[@as(c_int, 2)] = @intFromBool((@as(c_int, word) & @as(c_int, 4)) != @as(c_int, 0));
    out[@as(c_int, 3)] = @intFromBool((@as(c_int, word) & @as(c_int, 8)) != @as(c_int, 0));
    out[@as(c_int, 4)] = @intFromBool((@as(c_int, word) & @as(c_int, 16)) != @as(c_int, 0));
    out[@as(c_int, 5)] = @intFromBool((@as(c_int, word) & @as(c_int, 32)) != @as(c_int, 0));
    out[@as(c_int, 6)] = @intFromBool((@as(c_int, word) & @as(c_int, 64)) != @as(c_int, 0));
    out[@as(c_int, 7)] = @intFromBool((@as(c_int, word) & @as(c_int, 128)) != @as(c_int, 0));
}
pub fn _ArrowBitmapPackInt8(arg_values: [*c]const i8, arg_out: [*c]u8) callconv(.c) void {
    var values = arg_values;
    _ = &values;
    var out = arg_out;
    _ = &out;
    out.* = @bitCast(@as(i8, @truncate(((((((@as(c_int, values[@as(c_int, 0)]) | ((@as(c_int, values[@as(c_int, 1)]) + @as(c_int, 1)) & @as(c_int, 2))) | ((@as(c_int, values[@as(c_int, 2)]) + @as(c_int, 3)) & @as(c_int, 4))) | ((@as(c_int, values[@as(c_int, 3)]) + @as(c_int, 7)) & @as(c_int, 8))) | ((@as(c_int, values[@as(c_int, 4)]) + @as(c_int, 15)) & @as(c_int, 16))) | ((@as(c_int, values[@as(c_int, 5)]) + @as(c_int, 31)) & @as(c_int, 32))) | ((@as(c_int, values[@as(c_int, 6)]) + @as(c_int, 63)) & @as(c_int, 64))) | ((@as(c_int, values[@as(c_int, 7)]) + @as(c_int, 127)) & @as(c_int, 128)))));
}
pub fn _ArrowBitmapPackInt32(arg_values: [*c]const i32, arg_out: [*c]u8) callconv(.c) void {
    var values = arg_values;
    _ = &values;
    var out = arg_out;
    _ = &out;
    out.* = @bitCast(@as(i8, @truncate(((((((values[@as(c_int, 0)] | ((values[@as(c_int, 1)] + @as(c_int, 1)) & @as(c_int, 2))) | ((values[@as(c_int, 2)] + @as(c_int, 3)) & @as(c_int, 4))) | ((values[@as(c_int, 3)] + @as(c_int, 7)) & @as(c_int, 8))) | ((values[@as(c_int, 4)] + @as(c_int, 15)) & @as(c_int, 16))) | ((values[@as(c_int, 5)] + @as(c_int, 31)) & @as(c_int, 32))) | ((values[@as(c_int, 6)] + @as(c_int, 63)) & @as(c_int, 64))) | ((values[@as(c_int, 7)] + @as(c_int, 127)) & @as(c_int, 128)))));
}
pub fn _ArrowArrayUnionChildIndex(arg_array: [*c]struct_ArrowArray, arg_type_id: i8) callconv(.c) i8 {
    var array = arg_array;
    _ = &array;
    var type_id = arg_type_id;
    _ = &type_id;
    _ = &array;
    return type_id;
}
pub fn _ArrowArrayUnionTypeId(arg_array: [*c]struct_ArrowArray, arg_child_index: i8) callconv(.c) i8 {
    var array = arg_array;
    _ = &array;
    var child_index = arg_child_index;
    _ = &child_index;
    _ = &array;
    return child_index;
}
pub fn _ArrowParseUnionTypeIds(arg_type_ids: [*c]const u8, arg_out: [*c]i8) callconv(.c) i32 {
    var type_ids = arg_type_ids;
    _ = &type_ids;
    var out = arg_out;
    _ = &out;
    if (@as(c_int, type_ids.*) == @as(c_int, '\x00')) {
        return 0;
    }
    var i: i32 = 0;
    _ = &i;
    var type_id: c_long = undefined;
    _ = &type_id;
    var end_ptr: [*c]u8 = undefined;
    _ = &end_ptr;
    while (true) {
        type_id = strtol(type_ids, &end_ptr, 10);
        if (((end_ptr == type_ids) or (type_id < @as(c_long, 0))) or (type_id > @as(c_long, 127))) {
            return -@as(c_int, 1);
        }
        if (@as(?*anyopaque, @ptrCast(@alignCast(out))) != @as(?*anyopaque, null)) {
            out[@bitCast(@as(isize, @intCast(i)))] = @truncate(type_id);
        }
        i += 1;
        type_ids = end_ptr;
        if (@as(c_int, type_ids.*) == @as(c_int, '\x00')) {
            return i;
        } else if (@as(c_int, type_ids.*) != @as(c_int, ',')) {
            return -@as(c_int, 1);
        } else {
            type_ids += 1;
        }
    }
    return -@as(c_int, 1);
}
pub fn _ArrowParsedUnionTypeIdsWillEqualChildIndices(arg_type_ids: [*c]const i8, arg_n_type_ids: i64, arg_n_children: i64) callconv(.c) i8 {
    var type_ids = arg_type_ids;
    _ = &type_ids;
    var n_type_ids = arg_n_type_ids;
    _ = &n_type_ids;
    var n_children = arg_n_children;
    _ = &n_children;
    if (n_type_ids != n_children) {
        return 0;
    }
    {
        var i: i8 = 0;
        _ = &i;
        while (@as(i64, @as(c_int, i)) < n_type_ids) : (i += 1) {
            if (@as(c_int, type_ids[@bitCast(@as(isize, @intCast(i)))]) != @as(c_int, i)) {
                return 0;
            }
        }
    }
    return 1;
}
pub fn _ArrowUnionTypeIdsWillEqualChildIndices(arg_type_id_str: [*c]const u8, arg_n_children: i64) callconv(.c) i8 {
    var type_id_str = arg_type_id_str;
    _ = &type_id_str;
    var n_children = arg_n_children;
    _ = &n_children;
    var type_ids: [128]i8 = undefined;
    _ = &type_ids;
    var n_type_ids: i32 = _ArrowParseUnionTypeIds(type_id_str, @ptrCast(@alignCast(&type_ids)));
    _ = &n_type_ids;
    return _ArrowParsedUnionTypeIdsWillEqualChildIndices(@ptrCast(@alignCast(&type_ids)), n_type_ids, n_children);
}
pub fn _ArrowArrayAppendBits(arg_array: [*c]struct_ArrowArray, arg_buffer_i: i64, arg_value: u8, arg_n: i64) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var buffer_i = arg_buffer_i;
    _ = &buffer_i;
    var value = arg_value;
    _ = &value;
    var n = arg_n;
    _ = &n;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    var buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, buffer_i);
    _ = &buffer;
    var bytes_required: i64 = @divTrunc(_ArrowRoundUpToMultipleOf8(private_data.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(buffer_i)))] * (array.*.length + @as(i64, 1))), @as(i64, 8));
    _ = &bytes_required;
    if (bytes_required > buffer.*.size_bytes) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(buffer, 0, bytes_required - buffer.*.size_bytes);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
    }
    ArrowBitsSetTo(buffer.*.data, array.*.length, n, value);
    return NANOARROW_OK;
}
pub fn _ArrowArrayAppendEmptyInternal(arg_array: [*c]struct_ArrowArray, arg_n: i64, arg_is_valid: u8) callconv(.c) ArrowErrorCode {
    var array = arg_array;
    _ = &array;
    var n = arg_n;
    _ = &n;
    var is_valid = arg_is_valid;
    _ = &is_valid;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    if (n == @as(i64, 0)) {
        return NANOARROW_OK;
    }
    while (true) {
        switch (private_data.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_NA) => {
                array.*.null_count += n;
                array.*.length += n;
                return NANOARROW_OK;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_DENSE_UNION) => {
                {
                    var type_id: i8 = _ArrowArrayUnionTypeId(array, 0);
                    _ = &type_id;
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = _ArrowArrayAppendEmptyInternal(array.*.children[@as(c_int, 0)], 1, is_valid);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(ArrowArrayBuffer(array, 0), @bitCast(@as(i8, type_id)), n);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    {
                        var i: i64 = 0;
                        _ = &i;
                        while (i < n) : (i += 1) {
                            while (true) {
                                const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendInt32(ArrowArrayBuffer(array, 1), @as(i32, @truncate(array.*.children[@as(c_int, 0)].*.length)) - @as(c_int, 1));
                                _ = &errno_status__nanoarrow_unique_suffix;
                                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                                if (!false) break;
                            }
                        }
                    }
                    array.*.length += n;
                    return NANOARROW_OK;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_SPARSE_UNION) => {
                {
                    var type_id: i8 = _ArrowArrayUnionTypeId(array, 0);
                    _ = &type_id;
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = _ArrowArrayAppendEmptyInternal(array.*.children[@as(c_int, 0)], n, is_valid);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    {
                        var i: i64 = 1;
                        _ = &i;
                        while (i < array.*.n_children) : (i += 1) {
                            while (true) {
                                const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayAppendEmpty(array.*.children[@bitCast(@as(isize, @intCast(i)))], n);
                                _ = &errno_status__nanoarrow_unique_suffix;
                                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                                if (!false) break;
                            }
                        }
                    }
                    while (true) {
                        const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(ArrowArrayBuffer(array, 0), @bitCast(@as(i8, type_id)), n);
                        _ = &errno_status__nanoarrow_unique_suffix;
                        if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                        if (!false) break;
                    }
                    array.*.length += n;
                    return NANOARROW_OK;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_FIXED_SIZE_LIST) => {
                while (true) {
                    const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayAppendEmpty(array.*.children[@as(c_int, 0)], n * private_data.*.layout.child_size_elements);
                    _ = &errno_status__nanoarrow_unique_suffix;
                    if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                    if (!false) break;
                }
                break;
            },
            @as(enum_ArrowType, NANOARROW_TYPE_STRUCT) => {
                {
                    var i: i64 = 0;
                    _ = &i;
                    while (i < array.*.n_children) : (i += 1) {
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowArrayAppendEmpty(array.*.children[@bitCast(@as(isize, @intCast(i)))], n);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                    }
                }
                break;
            },
            else => {
                break;
            },
        }
        break;
    }
    if (!(@as(c_int, is_valid) != 0) and (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) == @as(?*anyopaque, null))) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapReserve(&private_data.*.bitmap, array.*.length + n);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
        ArrowBitmapAppendUnsafe(&private_data.*.bitmap, 1, array.*.length);
        ArrowBitmapAppendUnsafe(&private_data.*.bitmap, is_valid, n);
    } else if (@as(?*anyopaque, @ptrCast(@alignCast(private_data.*.bitmap.buffer.data))) != @as(?*anyopaque, null)) {
        while (true) {
            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBitmapReserve(&private_data.*.bitmap, n);
            _ = &errno_status__nanoarrow_unique_suffix;
            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
            if (!false) break;
        }
        ArrowBitmapAppendUnsafe(&private_data.*.bitmap, is_valid, n);
    }
    {
        var i: c_int = 0;
        _ = &i;
        while (i < NANOARROW_MAX_FIXED_BUFFERS) : (i += 1) {
            var buffer: [*c]struct_ArrowBuffer = ArrowArrayBuffer(array, i);
            _ = &buffer;
            var size_bytes: i64 = @divTrunc(private_data.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))], @as(i64, 8));
            _ = &size_bytes;
            while (true) {
                switch (private_data.*.layout.buffer_type[@bitCast(@as(isize, @intCast(i)))]) {
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_NONE), @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_VARIADIC_DATA), @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_VARIADIC_SIZE), @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_VALIDITY) => {
                        break;
                    },
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_SIZE) => {
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(buffer, 0, size_bytes * n);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                        break;
                    },
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_DATA_OFFSET) => {
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferReserve(buffer, size_bytes * n);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                        {
                            var j: i64 = 0;
                            _ = &j;
                            while (j < n) : (j += 1) {
                                ArrowBufferAppendUnsafe(buffer, @ptrCast(@alignCast(buffer.*.data + @as(usize, @bitCast(@as(isize, @intCast(size_bytes * (array.*.length + j))))))), size_bytes);
                            }
                        }
                        i += 1;
                        break;
                    },
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_DATA) => {
                        if (__helpers.signedRemainder(private_data.*.layout.element_size_bits[@bitCast(@as(isize, @intCast(i)))], @as(i64, 8)) == @as(i64, 0)) {
                            while (true) {
                                const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(buffer, 0, size_bytes * n);
                                _ = &errno_status__nanoarrow_unique_suffix;
                                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                                if (!false) break;
                            }
                        } else {
                            while (true) {
                                const errno_status__nanoarrow_unique_suffix: c_int = _ArrowArrayAppendBits(array, i, 0, n);
                                _ = &errno_status__nanoarrow_unique_suffix;
                                if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                                if (!false) break;
                            }
                        }
                        break;
                    },
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_VIEW_OFFSET) => {
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferReserve(buffer, size_bytes * n);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                        while (true) {
                            const errno_status__nanoarrow_unique_suffix: c_int = ArrowBufferAppendFill(buffer, 0, size_bytes * n);
                            _ = &errno_status__nanoarrow_unique_suffix;
                            if (errno_status__nanoarrow_unique_suffix != 0) return errno_status__nanoarrow_unique_suffix;
                            if (!false) break;
                        }
                        break;
                    },
                    @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_TYPE_ID), @as(enum_ArrowBufferType, NANOARROW_BUFFER_TYPE_UNION_OFFSET) => {
                        return EINVAL;
                    },
                    else => {},
                }
                break;
            }
        }
    }
    array.*.length += n;
    array.*.null_count += n * @as(i64, @intFromBool(!(@as(c_int, is_valid) != 0)));
    return NANOARROW_OK;
}
pub fn ArrowArrayVariadicBufferCount(arg_array: [*c]struct_ArrowArray) callconv(.c) i32 {
    var array = arg_array;
    _ = &array;
    var private_data: [*c]struct_ArrowArrayPrivateData = @ptrCast(@alignCast(array.*.private_data));
    _ = &private_data;
    return private_data.*.n_variadic_buffers;
}
pub fn ArrowArrayViewListChildOffset(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) i64 {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_LIST), @as(enum_ArrowType, NANOARROW_TYPE_MAP), @as(enum_ArrowType, NANOARROW_TYPE_LIST_VIEW) => {
                return array_view.*.buffer_views[@as(c_int, 1)].data.as_int32[@bitCast(@as(isize, @intCast(i)))];
            },
            @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST), @as(enum_ArrowType, NANOARROW_TYPE_LARGE_LIST_VIEW) => {
                return array_view.*.buffer_views[@as(c_int, 1)].data.as_int64[@bitCast(@as(isize, @intCast(i)))];
            },
            else => {
                return -@as(c_int, 1);
            },
        }
        break;
    }
    return undefined;
}
pub fn ArrowArrayViewGetBytesFromViewArrayUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64) callconv(.c) struct_ArrowBufferView {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var bv: [*c]const union_ArrowBinaryView = &array_view.*.buffer_views[@as(c_int, 1)].data.as_binary_view[@bitCast(@as(isize, @intCast(i)))];
    _ = &bv;
    var out: struct_ArrowBufferView = struct_ArrowBufferView{
        .data = union_ArrowBufferViewData{
            .data = null,
        },
        .size_bytes = bv.*.inlined.size,
    };
    _ = &out;
    if (bv.*.inlined.size <= NANOARROW_BINARY_VIEW_INLINE_SIZE) {
        out.data.as_uint8 = @ptrCast(@alignCast(&bv.*.inlined.data));
        return out;
    }
    out.data.data = array_view.*.variadic_buffers[@bitCast(@as(isize, @intCast(bv.*.ref.buffer_index)))];
    out.data.as_uint8 += @as(usize, @bitCast(@as(isize, @intCast(bv.*.ref.offset))));
    return out;
}
pub fn ArrowArrayViewGetIntervalUnsafe(arg_array_view: [*c]const struct_ArrowArrayView, arg_i: i64, arg_out: [*c]struct_ArrowInterval) callconv(.c) void {
    var array_view = arg_array_view;
    _ = &array_view;
    var i = arg_i;
    _ = &i;
    var out = arg_out;
    _ = &out;
    var data_view: [*c]const u8 = array_view.*.buffer_views[@as(c_int, 1)].data.as_uint8;
    _ = &data_view;
    const offset: i64 = array_view.*.offset;
    _ = &offset;
    const index_1: i64 = offset + i;
    _ = &index_1;
    while (true) {
        switch (array_view.*.storage_type) {
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTHS) => {
                {
                    const size: usize = @sizeOf(i32);
                    _ = &size;
                    _ = memcpy(@ptrCast(@alignCast(&out.*.months)), @ptrCast(@alignCast(data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size))), @sizeOf(i32));
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_DAY_TIME) => {
                {
                    const size: usize = @sizeOf(i32) +% @sizeOf(i32);
                    _ = &size;
                    _ = memcpy(@ptrCast(@alignCast(&out.*.days)), @ptrCast(@alignCast(data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size))), @sizeOf(i32));
                    _ = memcpy(@ptrCast(@alignCast(&out.*.ms)), @ptrCast(@alignCast((data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size)) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 4))))))), @sizeOf(i32));
                    break;
                }
            },
            @as(enum_ArrowType, NANOARROW_TYPE_INTERVAL_MONTH_DAY_NANO) => {
                {
                    const size: usize = (@sizeOf(i32) +% @sizeOf(i32)) +% @sizeOf(i64);
                    _ = &size;
                    _ = memcpy(@ptrCast(@alignCast(&out.*.months)), @ptrCast(@alignCast(data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size))), @sizeOf(i32));
                    _ = memcpy(@ptrCast(@alignCast(&out.*.days)), @ptrCast(@alignCast((data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size)) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 4))))))), @sizeOf(i32));
                    _ = memcpy(@ptrCast(@alignCast(&out.*.ns)), @ptrCast(@alignCast((data_view + (@as(usize, @bitCast(@as(c_long, index_1))) *% size)) + @as(usize, @bitCast(@as(isize, @intCast(@as(c_int, 8))))))), @sizeOf(i64));
                    break;
                }
            },
            else => {
                break;
            },
        }
        break;
    }
}
pub const struct___va_list_tag_5 = extern struct {
    unnamed_0: c_uint = 0,
    unnamed_1: c_uint = 0,
    unnamed_2: ?*anyopaque = null,
    unnamed_3: ?*anyopaque = null,
};
pub const __builtin_va_list = [1]struct___va_list_tag_5;
pub const va_list = __builtin_va_list;
pub const __gnuc_va_list = __builtin_va_list;
const union_unnamed_6 = extern union {
    __wch: c_uint,
    __wchb: [4]u8,
};
pub const __mbstate_t = extern struct {
    __count: c_int = 0,
    __value: union_unnamed_6 = @import("std").mem.zeroes(union_unnamed_6),
};
pub const struct__G_fpos_t = extern struct {
    __pos: __off_t = 0,
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos_t = struct__G_fpos_t;
pub const struct__G_fpos64_t = extern struct {
    __pos: __off64_t = 0,
    __state: __mbstate_t = @import("std").mem.zeroes(__mbstate_t),
};
pub const __fpos64_t = struct__G_fpos64_t;
pub const struct__IO_marker = opaque {}; // /usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h:74:7: warning: struct demoted to opaque type - has bitfield
pub const struct__IO_FILE = opaque {
    pub const fclose = __root.fclose;
    pub const fflush = __root.fflush;
    pub const fflush_unlocked = __root.fflush_unlocked;
    pub const setbuf = __root.setbuf;
    pub const setvbuf = __root.setvbuf;
    pub const setbuffer = __root.setbuffer;
    pub const setlinebuf = __root.setlinebuf;
    pub const fprintf = __root.fprintf;
    pub const vfprintf = __root.vfprintf;
    pub const fscanf = __root.fscanf;
    pub const vfscanf = __root.vfscanf;
    pub const fgetc = __root.fgetc;
    pub const getc = __root.getc;
    pub const getc_unlocked = __root.getc_unlocked;
    pub const fgetc_unlocked = __root.fgetc_unlocked;
    pub const getw = __root.getw;
    pub const fseek = __root.fseek;
    pub const ftell = __root.ftell;
    pub const rewind = __root.rewind;
    pub const fseeko = __root.fseeko;
    pub const ftello = __root.ftello;
    pub const fgetpos = __root.fgetpos;
    pub const fsetpos = __root.fsetpos;
    pub const clearerr = __root.clearerr;
    pub const feof = __root.feof;
    pub const ferror = __root.ferror;
    pub const clearerr_unlocked = __root.clearerr_unlocked;
    pub const feof_unlocked = __root.feof_unlocked;
    pub const ferror_unlocked = __root.ferror_unlocked;
    pub const fileno = __root.fileno;
    pub const fileno_unlocked = __root.fileno_unlocked;
    pub const pclose = __root.pclose;
    pub const flockfile = __root.flockfile;
    pub const ftrylockfile = __root.ftrylockfile;
    pub const funlockfile = __root.funlockfile;
    pub const __uflow = __root.__uflow;
    pub const __overflow = __root.__overflow;
    pub const rl_getc = __root.rl_getc;
    pub const unlocked = __root.fflush_unlocked;
    pub const uflow = __root.__uflow;
    pub const overflow = __root.__overflow;
};
pub const __FILE = struct__IO_FILE;
pub const FILE = struct__IO_FILE;
pub const struct__IO_codecvt = opaque {};
pub const struct__IO_wide_data = opaque {};
pub const _IO_lock_t = anyopaque;
pub const cookie_read_function_t = fn (__cookie: ?*anyopaque, __buf: [*c]u8, __nbytes: usize) callconv(.c) __ssize_t;
pub const cookie_write_function_t = fn (__cookie: ?*anyopaque, __buf: [*c]const u8, __nbytes: usize) callconv(.c) __ssize_t;
pub const cookie_seek_function_t = fn (__cookie: ?*anyopaque, __pos: [*c]__off64_t, __w: c_int) callconv(.c) c_int;
pub const cookie_close_function_t = fn (__cookie: ?*anyopaque) callconv(.c) c_int;
pub const struct__IO_cookie_io_functions_t = extern struct {
    read: ?*const cookie_read_function_t = null,
    write: ?*const cookie_write_function_t = null,
    seek: ?*const cookie_seek_function_t = null,
    close: ?*const cookie_close_function_t = null,
};
pub const cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const fpos_t = __fpos_t;
pub extern var stdin: ?*FILE;
pub extern var stdout: ?*FILE;
pub extern var stderr: ?*FILE;
pub extern fn remove(__filename: [*c]const u8) c_int;
pub extern fn rename(__old: [*c]const u8, __new: [*c]const u8) c_int;
pub extern fn renameat(__oldfd: c_int, __old: [*c]const u8, __newfd: c_int, __new: [*c]const u8) c_int;
pub extern fn fclose(__stream: ?*FILE) c_int;
pub extern fn tmpfile() ?*FILE;
pub extern fn tmpnam([*c]u8) [*c]u8;
pub extern fn tmpnam_r(__s: [*c]u8) [*c]u8;
pub extern fn tempnam(__dir: [*c]const u8, __pfx: [*c]const u8) [*c]u8;
pub extern fn fflush(__stream: ?*FILE) c_int;
pub extern fn fflush_unlocked(__stream: ?*FILE) c_int;
pub extern fn fopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8) ?*FILE;
pub extern fn freopen(noalias __filename: [*c]const u8, noalias __modes: [*c]const u8, noalias __stream: ?*FILE) ?*FILE;
pub extern fn fdopen(__fd: c_int, __modes: [*c]const u8) ?*FILE;
pub extern fn fopencookie(noalias __magic_cookie: ?*anyopaque, noalias __modes: [*c]const u8, __io_funcs: cookie_io_functions_t) ?*FILE;
pub extern fn fmemopen(__s: ?*anyopaque, __len: usize, __modes: [*c]const u8) ?*FILE;
pub extern fn open_memstream(__bufloc: [*c][*c]u8, __sizeloc: [*c]usize) ?*FILE;
pub extern fn setbuf(noalias __stream: ?*FILE, noalias __buf: [*c]u8) void;
pub extern fn setvbuf(noalias __stream: ?*FILE, noalias __buf: [*c]u8, __modes: c_int, __n: usize) c_int;
pub extern fn setbuffer(noalias __stream: ?*FILE, noalias __buf: [*c]u8, __size: usize) void;
pub extern fn setlinebuf(__stream: ?*FILE) void;
pub extern fn fprintf(noalias __stream: ?*FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn printf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sprintf(noalias __s: [*c]u8, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vfprintf(noalias __s: ?*FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn vprintf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn vsprintf(noalias __s: [*c]u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn snprintf(noalias __s: [*c]u8, __maxlen: usize, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vsnprintf(noalias __s: [*c]u8, __maxlen: usize, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn vasprintf(noalias __ptr: [*c][*c]u8, noalias __f: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn __asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn asprintf(noalias __ptr: [*c][*c]u8, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn vdprintf(__fd: c_int, noalias __fmt: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn dprintf(__fd: c_int, noalias __fmt: [*c]const u8, ...) c_int;
pub extern fn fscanf(noalias __stream: ?*FILE, noalias __format: [*c]const u8, ...) c_int;
pub extern fn scanf(noalias __format: [*c]const u8, ...) c_int;
pub extern fn sscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, ...) c_int;
pub extern fn vfscanf(noalias __s: ?*FILE, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn vscanf(noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn vsscanf(noalias __s: [*c]const u8, noalias __format: [*c]const u8, __arg: [*c]struct___va_list_tag_5) c_int;
pub extern fn fgetc(__stream: ?*FILE) c_int;
pub extern fn getc(__stream: ?*FILE) c_int;
pub extern fn getchar() c_int;
pub extern fn getc_unlocked(__stream: ?*FILE) c_int;
pub extern fn getchar_unlocked() c_int;
pub extern fn fgetc_unlocked(__stream: ?*FILE) c_int;
pub extern fn fputc(__c: c_int, __stream: ?*FILE) c_int;
pub extern fn putc(__c: c_int, __stream: ?*FILE) c_int;
pub extern fn putchar(__c: c_int) c_int;
pub extern fn fputc_unlocked(__c: c_int, __stream: ?*FILE) c_int;
pub extern fn putc_unlocked(__c: c_int, __stream: ?*FILE) c_int;
pub extern fn putchar_unlocked(__c: c_int) c_int;
pub extern fn getw(__stream: ?*FILE) c_int;
pub extern fn putw(__w: c_int, __stream: ?*FILE) c_int;
pub extern fn fgets(noalias __s: [*c]u8, __n: c_int, noalias __stream: ?*FILE) [*c]u8;
pub extern fn __getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: ?*FILE) __ssize_t;
pub extern fn getdelim(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, __delimiter: c_int, noalias __stream: ?*FILE) __ssize_t;
pub extern fn getline(noalias __lineptr: [*c][*c]u8, noalias __n: [*c]usize, noalias __stream: ?*FILE) __ssize_t;
pub extern fn fputs(noalias __s: [*c]const u8, noalias __stream: ?*FILE) c_int;
pub extern fn puts(__s: [*c]const u8) c_int;
pub extern fn ungetc(__c: c_int, __stream: ?*FILE) c_int;
pub extern fn fread(noalias __ptr: ?*anyopaque, __size: usize, __n: usize, noalias __stream: ?*FILE) usize;
pub extern fn fwrite(noalias __ptr: ?*const anyopaque, __size: usize, __n: usize, noalias __s: ?*FILE) usize;
pub extern fn fread_unlocked(noalias __ptr: ?*anyopaque, __size: usize, __n: usize, noalias __stream: ?*FILE) usize;
pub extern fn fwrite_unlocked(noalias __ptr: ?*const anyopaque, __size: usize, __n: usize, noalias __stream: ?*FILE) usize;
pub extern fn fseek(__stream: ?*FILE, __off: c_long, __whence: c_int) c_int;
pub extern fn ftell(__stream: ?*FILE) c_long;
pub extern fn rewind(__stream: ?*FILE) void;
pub extern fn fseeko(__stream: ?*FILE, __off: __off_t, __whence: c_int) c_int;
pub extern fn ftello(__stream: ?*FILE) __off_t;
pub extern fn fgetpos(noalias __stream: ?*FILE, noalias __pos: [*c]fpos_t) c_int;
pub extern fn fsetpos(__stream: ?*FILE, __pos: [*c]const fpos_t) c_int;
pub extern fn clearerr(__stream: ?*FILE) void;
pub extern fn feof(__stream: ?*FILE) c_int;
pub extern fn ferror(__stream: ?*FILE) c_int;
pub extern fn clearerr_unlocked(__stream: ?*FILE) void;
pub extern fn feof_unlocked(__stream: ?*FILE) c_int;
pub extern fn ferror_unlocked(__stream: ?*FILE) c_int;
pub extern fn perror(__s: [*c]const u8) void;
pub extern fn fileno(__stream: ?*FILE) c_int;
pub extern fn fileno_unlocked(__stream: ?*FILE) c_int;
pub extern fn pclose(__stream: ?*FILE) c_int;
pub extern fn popen(__command: [*c]const u8, __modes: [*c]const u8) ?*FILE;
pub extern fn ctermid(__s: [*c]u8) [*c]u8;
pub extern fn flockfile(__stream: ?*FILE) void;
pub extern fn ftrylockfile(__stream: ?*FILE) c_int;
pub extern fn funlockfile(__stream: ?*FILE) void;
pub extern fn __uflow(?*FILE) c_int;
pub extern fn __overflow(?*FILE, c_int) c_int;
pub const Function = fn (...) callconv(.c) c_int;
pub const VFunction = fn (...) callconv(.c) void;
pub const CPFunction = fn (...) callconv(.c) [*c]u8;
pub const CPPFunction = fn (...) callconv(.c) [*c][*c]u8;
pub const rl_command_func_t = fn (c_int, c_int) callconv(.c) c_int;
pub const rl_compentry_func_t = fn ([*c]const u8, c_int) callconv(.c) [*c]u8;
pub const rl_completion_func_t = fn ([*c]const u8, c_int, c_int) callconv(.c) [*c][*c]u8;
pub const rl_quote_func_t = fn ([*c]u8, c_int, [*c]u8) callconv(.c) [*c]u8;
pub const rl_dequote_func_t = fn ([*c]u8, c_int) callconv(.c) [*c]u8;
pub const rl_compignore_func_t = fn ([*c][*c]u8) callconv(.c) c_int;
pub const rl_compdisp_func_t = fn ([*c][*c]u8, c_int, c_int) callconv(.c) void;
pub const rl_hook_func_t = fn () callconv(.c) c_int;
pub const rl_getc_func_t = fn (?*FILE) callconv(.c) c_int;
pub const rl_linebuf_func_t = fn ([*c]u8, c_int) callconv(.c) c_int;
pub const rl_intfunc_t = fn (c_int) callconv(.c) c_int;
pub const rl_icpfunc_t = fn ([*c]u8) callconv(.c) c_int;
pub const rl_icppfunc_t = fn ([*c][*c]u8) callconv(.c) c_int;
pub const rl_voidfunc_t = fn () callconv(.c) void;
pub const rl_vintfunc_t = fn (c_int) callconv(.c) void;
pub const rl_vcpfunc_t = fn ([*c]u8) callconv(.c) void;
pub const rl_vcppfunc_t = fn ([*c][*c]u8) callconv(.c) void;
pub const rl_cpvfunc_t = fn () callconv(.c) [*c]u8;
pub const rl_cpifunc_t = fn (c_int) callconv(.c) [*c]u8;
pub const rl_cpcpfunc_t = fn ([*c]u8) callconv(.c) [*c]u8;
pub const rl_cpcppfunc_t = fn ([*c][*c]u8) callconv(.c) [*c]u8;
pub const _ISupper: c_int = 256;
pub const _ISlower: c_int = 512;
pub const _ISalpha: c_int = 1024;
pub const _ISdigit: c_int = 2048;
pub const _ISxdigit: c_int = 4096;
pub const _ISspace: c_int = 8192;
pub const _ISprint: c_int = 16384;
pub const _ISgraph: c_int = 32768;
pub const _ISblank: c_int = 1;
pub const _IScntrl: c_int = 2;
pub const _ISpunct: c_int = 4;
pub const _ISalnum: c_int = 8;
const enum_unnamed_7 = c_uint;
pub extern fn __ctype_b_loc() [*c][*c]const c_ushort;
pub extern fn __ctype_tolower_loc() [*c][*c]const __int32_t;
pub extern fn __ctype_toupper_loc() [*c][*c]const __int32_t;
pub extern fn isalnum(c_int) c_int;
pub extern fn isalpha(c_int) c_int;
pub extern fn iscntrl(c_int) c_int;
pub extern fn isdigit(c_int) c_int;
pub extern fn islower(c_int) c_int;
pub extern fn isgraph(c_int) c_int;
pub extern fn isprint(c_int) c_int;
pub extern fn ispunct(c_int) c_int;
pub extern fn isspace(c_int) c_int;
pub extern fn isupper(c_int) c_int;
pub extern fn isxdigit(c_int) c_int;
pub extern fn tolower(__c: c_int) c_int;
pub extern fn toupper(__c: c_int) c_int;
pub extern fn isblank(c_int) c_int;
pub extern fn isascii(__c: c_int) c_int;
pub extern fn toascii(__c: c_int) c_int;
pub extern fn _toupper(c_int) c_int;
pub extern fn _tolower(c_int) c_int;
pub extern fn isalnum_l(c_int, locale_t) c_int;
pub extern fn isalpha_l(c_int, locale_t) c_int;
pub extern fn iscntrl_l(c_int, locale_t) c_int;
pub extern fn isdigit_l(c_int, locale_t) c_int;
pub extern fn islower_l(c_int, locale_t) c_int;
pub extern fn isgraph_l(c_int, locale_t) c_int;
pub extern fn isprint_l(c_int, locale_t) c_int;
pub extern fn ispunct_l(c_int, locale_t) c_int;
pub extern fn isspace_l(c_int, locale_t) c_int;
pub extern fn isupper_l(c_int, locale_t) c_int;
pub extern fn isxdigit_l(c_int, locale_t) c_int;
pub extern fn isblank_l(c_int, locale_t) c_int;
pub extern fn __tolower_l(__c: c_int, __l: locale_t) c_int;
pub extern fn tolower_l(__c: c_int, __l: locale_t) c_int;
pub extern fn __toupper_l(__c: c_int, __l: locale_t) c_int;
pub extern fn toupper_l(__c: c_int, __l: locale_t) c_int;
pub const struct__keymap_entry = extern struct {
    type: u8 = 0,
    function: ?*const rl_command_func_t = null,
    pub const rl_copy_keymap = __root.rl_copy_keymap;
    pub const rl_discard_keymap = __root.rl_discard_keymap;
    pub const rl_set_keymap = __root.rl_set_keymap;
    pub const rl_empty_keymap = __root.rl_empty_keymap;
    pub const rl_free_keymap = __root.rl_free_keymap;
    pub const rl_get_keymap_name = __root.rl_get_keymap_name;
    pub const rl_tty_set_default_bindings = __root.rl_tty_set_default_bindings;
    pub const rl_tty_unset_default_bindings = __root.rl_tty_unset_default_bindings;
    pub const keymap = __root.rl_copy_keymap;
    pub const name = __root.rl_get_keymap_name;
    pub const bindings = __root.rl_tty_set_default_bindings;
};
pub const KEYMAP_ENTRY = struct__keymap_entry;
pub const KEYMAP_ENTRY_ARRAY = [257]KEYMAP_ENTRY;
pub const Keymap = [*c]KEYMAP_ENTRY;
pub extern var emacs_standard_keymap: KEYMAP_ENTRY_ARRAY;
pub extern var emacs_meta_keymap: KEYMAP_ENTRY_ARRAY;
pub extern var emacs_ctlx_keymap: KEYMAP_ENTRY_ARRAY;
pub extern var vi_insertion_keymap: KEYMAP_ENTRY_ARRAY;
pub extern var vi_movement_keymap: KEYMAP_ENTRY_ARRAY;
pub extern fn rl_make_bare_keymap() Keymap;
pub extern fn rl_copy_keymap(Keymap) Keymap;
pub extern fn rl_make_keymap() Keymap;
pub extern fn rl_discard_keymap(Keymap) void;
pub extern fn rl_get_keymap_by_name([*c]const u8) Keymap;
pub extern fn rl_get_keymap() Keymap;
pub extern fn rl_set_keymap(Keymap) void;
pub extern fn rl_set_keymap_name([*c]const u8, Keymap) c_int;
pub const tilde_hook_func_t = fn ([*c]u8) callconv(.c) [*c]u8;
pub extern var tilde_expansion_preexpansion_hook: ?*const tilde_hook_func_t;
pub extern var tilde_expansion_failure_hook: ?*const tilde_hook_func_t;
pub extern var tilde_additional_prefixes: [*c][*c]u8;
pub extern var tilde_additional_suffixes: [*c][*c]u8;
pub extern fn tilde_expand([*c]const u8) [*c]u8;
pub extern fn tilde_expand_word([*c]const u8) [*c]u8;
pub extern fn tilde_find_word([*c]const u8, c_int, [*c]c_int) [*c]u8;
pub const UNDO_DELETE: c_int = 0;
pub const UNDO_INSERT: c_int = 1;
pub const UNDO_BEGIN: c_int = 2;
pub const UNDO_END: c_int = 3;
pub const enum_undo_code = c_uint;
pub const struct_undo_list = extern struct {
    next: [*c]struct_undo_list = null,
    start: c_int = 0,
    end: c_int = 0,
    text: [*c]u8 = null,
    what: enum_undo_code = @import("std").mem.zeroes(enum_undo_code),
};
pub const UNDO_LIST = struct_undo_list;
pub extern var rl_undo_list: [*c]UNDO_LIST;
pub const struct__funmap = extern struct {
    name: [*c]const u8 = null,
    function: ?*const rl_command_func_t = null,
};
pub const FUNMAP = struct__funmap;
pub extern var funmap: [*c][*c]FUNMAP;
pub extern fn rl_digit_argument(c_int, c_int) c_int;
pub extern fn rl_universal_argument(c_int, c_int) c_int;
pub extern fn rl_forward_byte(c_int, c_int) c_int;
pub extern fn rl_forward_char(c_int, c_int) c_int;
pub extern fn rl_forward(c_int, c_int) c_int;
pub extern fn rl_backward_byte(c_int, c_int) c_int;
pub extern fn rl_backward_char(c_int, c_int) c_int;
pub extern fn rl_backward(c_int, c_int) c_int;
pub extern fn rl_beg_of_line(c_int, c_int) c_int;
pub extern fn rl_end_of_line(c_int, c_int) c_int;
pub extern fn rl_forward_word(c_int, c_int) c_int;
pub extern fn rl_backward_word(c_int, c_int) c_int;
pub extern fn rl_refresh_line(c_int, c_int) c_int;
pub extern fn rl_clear_screen(c_int, c_int) c_int;
pub extern fn rl_clear_display(c_int, c_int) c_int;
pub extern fn rl_skip_csi_sequence(c_int, c_int) c_int;
pub extern fn rl_arrow_keys(c_int, c_int) c_int;
pub extern fn rl_previous_screen_line(c_int, c_int) c_int;
pub extern fn rl_next_screen_line(c_int, c_int) c_int;
pub extern fn rl_insert(c_int, c_int) c_int;
pub extern fn rl_quoted_insert(c_int, c_int) c_int;
pub extern fn rl_tab_insert(c_int, c_int) c_int;
pub extern fn rl_newline(c_int, c_int) c_int;
pub extern fn rl_do_lowercase_version(c_int, c_int) c_int;
pub extern fn rl_rubout(c_int, c_int) c_int;
pub extern fn rl_delete(c_int, c_int) c_int;
pub extern fn rl_rubout_or_delete(c_int, c_int) c_int;
pub extern fn rl_delete_horizontal_space(c_int, c_int) c_int;
pub extern fn rl_delete_or_show_completions(c_int, c_int) c_int;
pub extern fn rl_insert_comment(c_int, c_int) c_int;
pub extern fn rl_upcase_word(c_int, c_int) c_int;
pub extern fn rl_downcase_word(c_int, c_int) c_int;
pub extern fn rl_capitalize_word(c_int, c_int) c_int;
pub extern fn rl_transpose_words(c_int, c_int) c_int;
pub extern fn rl_transpose_chars(c_int, c_int) c_int;
pub extern fn rl_char_search(c_int, c_int) c_int;
pub extern fn rl_backward_char_search(c_int, c_int) c_int;
pub extern fn rl_beginning_of_history(c_int, c_int) c_int;
pub extern fn rl_end_of_history(c_int, c_int) c_int;
pub extern fn rl_get_next_history(c_int, c_int) c_int;
pub extern fn rl_get_previous_history(c_int, c_int) c_int;
pub extern fn rl_operate_and_get_next(c_int, c_int) c_int;
pub extern fn rl_fetch_history(c_int, c_int) c_int;
pub extern fn rl_set_mark(c_int, c_int) c_int;
pub extern fn rl_exchange_point_and_mark(c_int, c_int) c_int;
pub extern fn rl_vi_editing_mode(c_int, c_int) c_int;
pub extern fn rl_emacs_editing_mode(c_int, c_int) c_int;
pub extern fn rl_overwrite_mode(c_int, c_int) c_int;
pub extern fn rl_re_read_init_file(c_int, c_int) c_int;
pub extern fn rl_dump_functions(c_int, c_int) c_int;
pub extern fn rl_dump_macros(c_int, c_int) c_int;
pub extern fn rl_dump_variables(c_int, c_int) c_int;
pub extern fn rl_complete(c_int, c_int) c_int;
pub extern fn rl_possible_completions(c_int, c_int) c_int;
pub extern fn rl_insert_completions(c_int, c_int) c_int;
pub extern fn rl_old_menu_complete(c_int, c_int) c_int;
pub extern fn rl_menu_complete(c_int, c_int) c_int;
pub extern fn rl_backward_menu_complete(c_int, c_int) c_int;
pub extern fn rl_kill_word(c_int, c_int) c_int;
pub extern fn rl_backward_kill_word(c_int, c_int) c_int;
pub extern fn rl_kill_line(c_int, c_int) c_int;
pub extern fn rl_backward_kill_line(c_int, c_int) c_int;
pub extern fn rl_kill_full_line(c_int, c_int) c_int;
pub extern fn rl_unix_word_rubout(c_int, c_int) c_int;
pub extern fn rl_unix_filename_rubout(c_int, c_int) c_int;
pub extern fn rl_unix_line_discard(c_int, c_int) c_int;
pub extern fn rl_copy_region_to_kill(c_int, c_int) c_int;
pub extern fn rl_kill_region(c_int, c_int) c_int;
pub extern fn rl_copy_forward_word(c_int, c_int) c_int;
pub extern fn rl_copy_backward_word(c_int, c_int) c_int;
pub extern fn rl_yank(c_int, c_int) c_int;
pub extern fn rl_yank_pop(c_int, c_int) c_int;
pub extern fn rl_yank_nth_arg(c_int, c_int) c_int;
pub extern fn rl_yank_last_arg(c_int, c_int) c_int;
pub extern fn rl_bracketed_paste_begin(c_int, c_int) c_int;
pub extern fn rl_reverse_search_history(c_int, c_int) c_int;
pub extern fn rl_forward_search_history(c_int, c_int) c_int;
pub extern fn rl_start_kbd_macro(c_int, c_int) c_int;
pub extern fn rl_end_kbd_macro(c_int, c_int) c_int;
pub extern fn rl_call_last_kbd_macro(c_int, c_int) c_int;
pub extern fn rl_print_last_kbd_macro(c_int, c_int) c_int;
pub extern fn rl_revert_line(c_int, c_int) c_int;
pub extern fn rl_undo_command(c_int, c_int) c_int;
pub extern fn rl_tilde_expand(c_int, c_int) c_int;
pub extern fn rl_restart_output(c_int, c_int) c_int;
pub extern fn rl_stop_output(c_int, c_int) c_int;
pub extern fn rl_abort(c_int, c_int) c_int;
pub extern fn rl_tty_status(c_int, c_int) c_int;
pub extern fn rl_history_search_forward(c_int, c_int) c_int;
pub extern fn rl_history_search_backward(c_int, c_int) c_int;
pub extern fn rl_history_substr_search_forward(c_int, c_int) c_int;
pub extern fn rl_history_substr_search_backward(c_int, c_int) c_int;
pub extern fn rl_noninc_forward_search(c_int, c_int) c_int;
pub extern fn rl_noninc_reverse_search(c_int, c_int) c_int;
pub extern fn rl_noninc_forward_search_again(c_int, c_int) c_int;
pub extern fn rl_noninc_reverse_search_again(c_int, c_int) c_int;
pub extern fn rl_insert_close(c_int, c_int) c_int;
pub extern fn rl_callback_handler_install([*c]const u8, ?*const rl_vcpfunc_t) void;
pub extern fn rl_callback_read_char() void;
pub extern fn rl_callback_handler_remove() void;
pub extern fn rl_callback_sigcleanup() void;
pub extern fn rl_vi_redo(c_int, c_int) c_int;
pub extern fn rl_vi_undo(c_int, c_int) c_int;
pub extern fn rl_vi_yank_arg(c_int, c_int) c_int;
pub extern fn rl_vi_fetch_history(c_int, c_int) c_int;
pub extern fn rl_vi_search_again(c_int, c_int) c_int;
pub extern fn rl_vi_search(c_int, c_int) c_int;
pub extern fn rl_vi_complete(c_int, c_int) c_int;
pub extern fn rl_vi_tilde_expand(c_int, c_int) c_int;
pub extern fn rl_vi_prev_word(c_int, c_int) c_int;
pub extern fn rl_vi_next_word(c_int, c_int) c_int;
pub extern fn rl_vi_end_word(c_int, c_int) c_int;
pub extern fn rl_vi_insert_beg(c_int, c_int) c_int;
pub extern fn rl_vi_append_mode(c_int, c_int) c_int;
pub extern fn rl_vi_append_eol(c_int, c_int) c_int;
pub extern fn rl_vi_eof_maybe(c_int, c_int) c_int;
pub extern fn rl_vi_insertion_mode(c_int, c_int) c_int;
pub extern fn rl_vi_insert_mode(c_int, c_int) c_int;
pub extern fn rl_vi_movement_mode(c_int, c_int) c_int;
pub extern fn rl_vi_arg_digit(c_int, c_int) c_int;
pub extern fn rl_vi_change_case(c_int, c_int) c_int;
pub extern fn rl_vi_put(c_int, c_int) c_int;
pub extern fn rl_vi_column(c_int, c_int) c_int;
pub extern fn rl_vi_delete_to(c_int, c_int) c_int;
pub extern fn rl_vi_change_to(c_int, c_int) c_int;
pub extern fn rl_vi_yank_to(c_int, c_int) c_int;
pub extern fn rl_vi_yank_pop(c_int, c_int) c_int;
pub extern fn rl_vi_rubout(c_int, c_int) c_int;
pub extern fn rl_vi_delete(c_int, c_int) c_int;
pub extern fn rl_vi_back_to_indent(c_int, c_int) c_int;
pub extern fn rl_vi_unix_word_rubout(c_int, c_int) c_int;
pub extern fn rl_vi_first_print(c_int, c_int) c_int;
pub extern fn rl_vi_char_search(c_int, c_int) c_int;
pub extern fn rl_vi_match(c_int, c_int) c_int;
pub extern fn rl_vi_change_char(c_int, c_int) c_int;
pub extern fn rl_vi_subst(c_int, c_int) c_int;
pub extern fn rl_vi_overstrike(c_int, c_int) c_int;
pub extern fn rl_vi_overstrike_delete(c_int, c_int) c_int;
pub extern fn rl_vi_replace(c_int, c_int) c_int;
pub extern fn rl_vi_set_mark(c_int, c_int) c_int;
pub extern fn rl_vi_goto_mark(c_int, c_int) c_int;
pub extern fn rl_vi_check() c_int;
pub extern fn rl_vi_domove(c_int, [*c]c_int) c_int;
pub extern fn rl_vi_bracktype(c_int) c_int;
pub extern fn rl_vi_start_inserting(c_int, c_int, c_int) void;
pub extern fn rl_vi_fWord(c_int, c_int) c_int;
pub extern fn rl_vi_bWord(c_int, c_int) c_int;
pub extern fn rl_vi_eWord(c_int, c_int) c_int;
pub extern fn rl_vi_fword(c_int, c_int) c_int;
pub extern fn rl_vi_bword(c_int, c_int) c_int;
pub extern fn rl_vi_eword(c_int, c_int) c_int;
pub extern fn readline([*c]const u8) [*c]u8;
pub extern fn rl_set_prompt([*c]const u8) c_int;
pub extern fn rl_expand_prompt([*c]u8) c_int;
pub extern fn rl_initialize() c_int;
pub extern fn rl_discard_argument() c_int;
pub extern fn rl_add_defun([*c]const u8, ?*const rl_command_func_t, c_int) c_int;
pub extern fn rl_bind_key(c_int, ?*const rl_command_func_t) c_int;
pub extern fn rl_bind_key_in_map(c_int, ?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_unbind_key(c_int) c_int;
pub extern fn rl_unbind_key_in_map(c_int, Keymap) c_int;
pub extern fn rl_bind_key_if_unbound(c_int, ?*const rl_command_func_t) c_int;
pub extern fn rl_bind_key_if_unbound_in_map(c_int, ?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_unbind_function_in_map(?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_unbind_command_in_map([*c]const u8, Keymap) c_int;
pub extern fn rl_bind_keyseq([*c]const u8, ?*const rl_command_func_t) c_int;
pub extern fn rl_bind_keyseq_in_map([*c]const u8, ?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_bind_keyseq_if_unbound([*c]const u8, ?*const rl_command_func_t) c_int;
pub extern fn rl_bind_keyseq_if_unbound_in_map([*c]const u8, ?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_generic_bind(c_int, [*c]const u8, [*c]u8, Keymap) c_int;
pub extern fn rl_variable_value([*c]const u8) [*c]u8;
pub extern fn rl_variable_bind([*c]const u8, [*c]const u8) c_int;
pub extern fn rl_set_key([*c]const u8, ?*const rl_command_func_t, Keymap) c_int;
pub extern fn rl_macro_bind([*c]const u8, [*c]const u8, Keymap) c_int;
pub extern fn rl_translate_keyseq([*c]const u8, [*c]u8, [*c]c_int) c_int;
pub extern fn rl_untranslate_keyseq(c_int) [*c]u8;
pub extern fn rl_named_function([*c]const u8) ?*const rl_command_func_t;
pub extern fn rl_function_of_keyseq([*c]const u8, Keymap, [*c]c_int) ?*const rl_command_func_t;
pub extern fn rl_function_of_keyseq_len([*c]const u8, usize, Keymap, [*c]c_int) ?*const rl_command_func_t;
pub extern fn rl_trim_arg_from_keyseq([*c]const u8, usize, Keymap) c_int;
pub extern fn rl_list_funmap_names() void;
pub extern fn rl_invoking_keyseqs_in_map(?*const rl_command_func_t, Keymap) [*c][*c]u8;
pub extern fn rl_invoking_keyseqs(?*const rl_command_func_t) [*c][*c]u8;
pub extern fn rl_function_dumper(c_int) void;
pub extern fn rl_macro_dumper(c_int) void;
pub extern fn rl_variable_dumper(c_int) void;
pub extern fn rl_read_init_file([*c]const u8) c_int;
pub extern fn rl_parse_and_bind([*c]u8) c_int;
pub extern fn rl_empty_keymap(Keymap) c_int;
pub extern fn rl_free_keymap(Keymap) void;
pub extern fn rl_get_keymap_name(Keymap) [*c]u8;
pub extern fn rl_set_keymap_from_edit_mode() void;
pub extern fn rl_get_keymap_name_from_edit_mode() [*c]u8;
pub extern fn rl_add_funmap_entry([*c]const u8, ?*const rl_command_func_t) c_int;
pub extern fn rl_funmap_names() [*c][*c]const u8;
pub extern fn rl_initialize_funmap() void;
pub extern fn rl_push_macro_input([*c]u8) void;
pub extern fn rl_add_undo(enum_undo_code, c_int, c_int, [*c]u8) void;
pub extern fn rl_free_undo_list() void;
pub extern fn rl_do_undo() c_int;
pub extern fn rl_begin_undo_group() c_int;
pub extern fn rl_end_undo_group() c_int;
pub extern fn rl_modifying(c_int, c_int) c_int;
pub extern fn rl_redisplay() void;
pub extern fn rl_on_new_line() c_int;
pub extern fn rl_on_new_line_with_prompt() c_int;
pub extern fn rl_forced_update_display() c_int;
pub extern fn rl_clear_visible_line() c_int;
pub extern fn rl_clear_message() c_int;
pub extern fn rl_reset_line_state() c_int;
pub extern fn rl_crlf() c_int;
pub extern fn rl_keep_mark_active() void;
pub extern fn rl_activate_mark() void;
pub extern fn rl_deactivate_mark() void;
pub extern fn rl_mark_active_p() c_int;
pub extern fn rl_message(...) c_int;
pub extern fn rl_show_char(c_int) c_int;
pub extern fn rl_character_len(c_int, c_int) c_int;
pub extern fn rl_redraw_prompt_last_line() void;
pub extern fn rl_save_prompt() void;
pub extern fn rl_restore_prompt() void;
pub extern fn rl_replace_line([*c]const u8, c_int) void;
pub extern fn rl_insert_text([*c]const u8) c_int;
pub extern fn rl_delete_text(c_int, c_int) c_int;
pub extern fn rl_kill_text(c_int, c_int) c_int;
pub extern fn rl_copy_text(c_int, c_int) [*c]u8;
pub extern fn rl_prep_terminal(c_int) void;
pub extern fn rl_deprep_terminal() void;
pub extern fn rl_tty_set_default_bindings(Keymap) void;
pub extern fn rl_tty_unset_default_bindings(Keymap) void;
pub extern fn rl_tty_set_echoing(c_int) c_int;
pub extern fn rl_reset_terminal([*c]const u8) c_int;
pub extern fn rl_resize_terminal() void;
pub extern fn rl_set_screen_size(c_int, c_int) void;
pub extern fn rl_get_screen_size([*c]c_int, [*c]c_int) void;
pub extern fn rl_reset_screen_size() void;
pub extern fn rl_get_termcap([*c]const u8) [*c]u8;
pub extern fn rl_stuff_char(c_int) c_int;
pub extern fn rl_execute_next(c_int) c_int;
pub extern fn rl_clear_pending_input() c_int;
pub extern fn rl_read_key() c_int;
pub extern fn rl_getc(?*FILE) c_int;
pub extern fn rl_set_keyboard_input_timeout(c_int) c_int;
pub extern fn rl_set_timeout(c_uint, c_uint) c_int;
pub extern fn rl_timeout_remaining([*c]c_uint, [*c]c_uint) c_int;
pub extern fn rl_extend_line_buffer(c_int) void;
pub extern fn rl_ding() c_int;
pub extern fn rl_alphabetic(c_int) c_int;
pub extern fn rl_free(?*anyopaque) void;
pub extern fn rl_set_signals() c_int;
pub extern fn rl_clear_signals() c_int;
pub extern fn rl_cleanup_after_signal() void;
pub extern fn rl_reset_after_signal() void;
pub extern fn rl_free_line_state() void;
pub extern fn rl_pending_signal() c_int;
pub extern fn rl_check_signals() void;
pub extern fn rl_echo_signal_char(c_int) void;
pub extern fn rl_set_paren_blink_timeout(c_int) c_int;
pub extern fn rl_clear_history() void;
pub extern fn rl_maybe_save_line() c_int;
pub extern fn rl_maybe_unsave_line() c_int;
pub extern fn rl_maybe_replace_line() c_int;
pub extern fn rl_complete_internal(c_int) c_int;
pub extern fn rl_display_match_list([*c][*c]u8, c_int, c_int) void;
pub extern fn rl_completion_matches([*c]const u8, ?*const rl_compentry_func_t) [*c][*c]u8;
pub extern fn rl_username_completion_function([*c]const u8, c_int) [*c]u8;
pub extern fn rl_filename_completion_function([*c]const u8, c_int) [*c]u8;
pub extern fn rl_completion_mode(?*const rl_command_func_t) c_int;
pub extern var rl_library_version: [*c]const u8;
pub extern var rl_readline_version: c_int;
pub extern var rl_gnu_readline_p: c_int;
pub extern var rl_readline_state: c_ulong;
pub extern var rl_editing_mode: c_int;
pub extern var rl_insert_mode: c_int;
pub extern var rl_readline_name: [*c]const u8;
pub extern var rl_prompt: [*c]u8;
pub extern var rl_display_prompt: [*c]u8;
pub extern var rl_line_buffer: [*c]u8;
pub extern var rl_point: c_int;
pub extern var rl_end: c_int;
pub extern var rl_mark: c_int;
pub extern var rl_done: c_int;
pub extern var rl_eof_found: c_int;
pub extern var rl_pending_input: c_int;
pub extern var rl_dispatching: c_int;
pub extern var rl_explicit_arg: c_int;
pub extern var rl_numeric_arg: c_int;
pub extern var rl_last_func: ?*const rl_command_func_t;
pub extern var rl_terminal_name: [*c]const u8;
pub extern var rl_instream: ?*FILE;
pub extern var rl_outstream: ?*FILE;
pub extern var rl_prefer_env_winsize: c_int;
pub extern var rl_startup_hook: ?*const rl_hook_func_t;
pub extern var rl_pre_input_hook: ?*const rl_hook_func_t;
pub extern var rl_event_hook: ?*const rl_hook_func_t;
pub extern var rl_signal_event_hook: ?*const rl_hook_func_t;
pub extern var rl_timeout_event_hook: ?*const rl_hook_func_t;
pub extern var rl_input_available_hook: ?*const rl_hook_func_t;
pub extern var rl_getc_function: ?*const rl_getc_func_t;
pub extern var rl_redisplay_function: ?*const rl_voidfunc_t;
pub extern var rl_prep_term_function: ?*const rl_vintfunc_t;
pub extern var rl_deprep_term_function: ?*const rl_voidfunc_t;
pub extern var rl_executing_keymap: Keymap;
pub extern var rl_binding_keymap: Keymap;
pub extern var rl_executing_key: c_int;
pub extern var rl_executing_keyseq: [*c]u8;
pub extern var rl_key_sequence_length: c_int;
pub extern var rl_erase_empty_line: c_int;
pub extern var rl_already_prompted: c_int;
pub extern var rl_num_chars_to_read: c_int;
pub extern var rl_executing_macro: [*c]u8;
pub extern var rl_catch_signals: c_int;
pub extern var rl_catch_sigwinch: c_int;
pub extern var rl_change_environment: c_int;
pub extern var rl_completion_entry_function: ?*const rl_compentry_func_t;
pub extern var rl_menu_completion_entry_function: ?*const rl_compentry_func_t;
pub extern var rl_ignore_some_completions_function: ?*const rl_compignore_func_t;
pub extern var rl_attempted_completion_function: ?*const rl_completion_func_t;
pub extern var rl_basic_word_break_characters: [*c]const u8;
pub extern var rl_completer_word_break_characters: [*c]const u8;
pub extern var rl_completion_word_break_hook: ?*const rl_cpvfunc_t;
pub extern var rl_completer_quote_characters: [*c]const u8;
pub extern var rl_basic_quote_characters: [*c]const u8;
pub extern var rl_filename_quote_characters: [*c]const u8;
pub extern var rl_special_prefixes: [*c]const u8;
pub extern var rl_directory_completion_hook: ?*const rl_icppfunc_t;
pub extern var rl_directory_rewrite_hook: ?*const rl_icppfunc_t;
pub extern var rl_filename_stat_hook: ?*const rl_icppfunc_t;
pub extern var rl_filename_rewrite_hook: ?*const rl_dequote_func_t;
pub extern var rl_completion_display_matches_hook: ?*const rl_compdisp_func_t;
pub extern var rl_filename_completion_desired: c_int;
pub extern var rl_filename_quoting_desired: c_int;
pub extern var rl_filename_quoting_function: ?*const rl_quote_func_t;
pub extern var rl_filename_dequoting_function: ?*const rl_dequote_func_t;
pub extern var rl_char_is_quoted_p: ?*const rl_linebuf_func_t;
pub extern var rl_attempted_completion_over: c_int;
pub extern var rl_completion_type: c_int;
pub extern var rl_completion_invoking_key: c_int;
pub extern var rl_completion_query_items: c_int;
pub extern var rl_completion_append_character: c_int;
pub extern var rl_completion_suppress_append: c_int;
pub extern var rl_completion_quote_character: c_int;
pub extern var rl_completion_found_quote: c_int;
pub extern var rl_completion_suppress_quote: c_int;
pub extern var rl_sort_completion_matches: c_int;
pub extern var rl_completion_mark_symlink_dirs: c_int;
pub extern var rl_ignore_completion_duplicates: c_int;
pub extern var rl_inhibit_completion: c_int;
pub extern var rl_persistent_signal_handlers: c_int;
pub const struct_readline_state = extern struct {
    point: c_int = 0,
    end: c_int = 0,
    mark: c_int = 0,
    buflen: c_int = 0,
    buffer: [*c]u8 = null,
    ul: [*c]UNDO_LIST = null,
    prompt: [*c]u8 = null,
    rlstate: c_int = 0,
    done: c_int = 0,
    kmap: Keymap = null,
    lastfunc: ?*const rl_command_func_t = null,
    insmode: c_int = 0,
    edmode: c_int = 0,
    kseq: [*c]u8 = null,
    kseqlen: c_int = 0,
    pendingin: c_int = 0,
    inf: ?*FILE = null,
    outf: ?*FILE = null,
    macro: [*c]u8 = null,
    catchsigs: c_int = 0,
    catchsigwinch: c_int = 0,
    entryfunc: ?*const rl_compentry_func_t = null,
    menuentryfunc: ?*const rl_compentry_func_t = null,
    ignorefunc: ?*const rl_compignore_func_t = null,
    attemptfunc: ?*const rl_completion_func_t = null,
    wordbreakchars: [*c]const u8 = null,
    reserved: [64]u8 = @import("std").mem.zeroes([64]u8),
    pub const rl_save_state = __root.rl_save_state;
    pub const rl_restore_state = __root.rl_restore_state;
    pub const state = __root.rl_save_state;
};
pub extern fn rl_save_state([*c]struct_readline_state) c_int;
pub extern fn rl_restore_state([*c]struct_readline_state) c_int;
pub const struct_tm = extern struct {
    tm_sec: c_int = 0,
    tm_min: c_int = 0,
    tm_hour: c_int = 0,
    tm_mday: c_int = 0,
    tm_mon: c_int = 0,
    tm_year: c_int = 0,
    tm_wday: c_int = 0,
    tm_yday: c_int = 0,
    tm_isdst: c_int = 0,
    tm_gmtoff: c_long = 0,
    tm_zone: [*c]const u8 = null,
    pub const mktime = __root.mktime;
    pub const asctime = __root.asctime;
    pub const asctime_r = __root.asctime_r;
    pub const timegm = __root.timegm;
    pub const timelocal = __root.timelocal;
    pub const r = __root.asctime_r;
};
pub const struct_itimerspec = extern struct {
    it_interval: struct_timespec = @import("std").mem.zeroes(struct_timespec),
    it_value: struct_timespec = @import("std").mem.zeroes(struct_timespec),
};
pub const struct_sigevent = opaque {};
pub extern fn clock() clock_t;
pub extern fn time(__timer: [*c]time_t) time_t;
pub extern fn difftime(__time1: time_t, __time0: time_t) f64;
pub extern fn mktime(__tp: [*c]struct_tm) time_t;
pub extern fn strftime(noalias __s: [*c]u8, __maxsize: usize, noalias __format: [*c]const u8, noalias __tp: [*c]const struct_tm) usize;
pub extern fn strftime_l(noalias __s: [*c]u8, __maxsize: usize, noalias __format: [*c]const u8, noalias __tp: [*c]const struct_tm, __loc: locale_t) usize;
pub extern fn gmtime(__timer: [*c]const time_t) [*c]struct_tm;
pub extern fn localtime(__timer: [*c]const time_t) [*c]struct_tm;
pub extern fn gmtime_r(noalias __timer: [*c]const time_t, noalias __tp: [*c]struct_tm) [*c]struct_tm;
pub extern fn localtime_r(noalias __timer: [*c]const time_t, noalias __tp: [*c]struct_tm) [*c]struct_tm;
pub extern fn asctime(__tp: [*c]const struct_tm) [*c]u8;
pub extern fn ctime(__timer: [*c]const time_t) [*c]u8;
pub extern fn asctime_r(noalias __tp: [*c]const struct_tm, noalias __buf: [*c]u8) [*c]u8;
pub extern fn ctime_r(noalias __timer: [*c]const time_t, noalias __buf: [*c]u8) [*c]u8;
pub extern var __tzname: [2][*c]u8;
pub extern var __daylight: c_int;
pub extern var __timezone: c_long;
pub extern var tzname: [2][*c]u8;
pub extern fn tzset() void;
pub extern var daylight: c_int;
pub extern var timezone: c_long;
pub extern fn timegm(__tp: [*c]struct_tm) time_t;
pub extern fn timelocal(__tp: [*c]struct_tm) time_t;
pub extern fn dysize(__year: c_int) c_int;
pub extern fn nanosleep(__requested_time: [*c]const struct_timespec, __remaining: [*c]struct_timespec) c_int;
pub extern fn clock_getres(__clock_id: clockid_t, __res: [*c]struct_timespec) c_int;
pub extern fn clock_gettime(__clock_id: clockid_t, __tp: [*c]struct_timespec) c_int;
pub extern fn clock_settime(__clock_id: clockid_t, __tp: [*c]const struct_timespec) c_int;
pub extern fn clock_nanosleep(__clock_id: clockid_t, __flags: c_int, __req: [*c]const struct_timespec, __rem: [*c]struct_timespec) c_int;
pub extern fn clock_getcpuclockid(__pid: pid_t, __clock_id: [*c]clockid_t) c_int;
pub extern fn timer_create(__clock_id: clockid_t, noalias __evp: ?*struct_sigevent, noalias __timerid: [*c]timer_t) c_int;
pub extern fn timer_delete(__timerid: timer_t) c_int;
pub extern fn timer_settime(__timerid: timer_t, __flags: c_int, noalias __value: [*c]const struct_itimerspec, noalias __ovalue: [*c]struct_itimerspec) c_int;
pub extern fn timer_gettime(__timerid: timer_t, __value: [*c]struct_itimerspec) c_int;
pub extern fn timer_getoverrun(__timerid: timer_t) c_int;
pub extern fn timespec_get(__ts: [*c]struct_timespec, __base: c_int) c_int;
pub const histdata_t = ?*anyopaque;
pub const struct__hist_entry = extern struct {
    line: [*c]u8 = null,
    timestamp: [*c]u8 = null,
    data: histdata_t = null,
    pub const copy_history_entry = __root.copy_history_entry;
    pub const free_history_entry = __root.free_history_entry;
    pub const history_get_time = __root.history_get_time;
    pub const entry = __root.copy_history_entry;
};
pub const HIST_ENTRY = struct__hist_entry;
pub const struct__hist_state = extern struct {
    entries: [*c][*c]HIST_ENTRY = null,
    offset: c_int = 0,
    length: c_int = 0,
    size: c_int = 0,
    flags: c_int = 0,
    pub const history_set_history_state = __root.history_set_history_state;
    pub const state = __root.history_set_history_state;
};
pub const HISTORY_STATE = struct__hist_state;
pub extern fn using_history() void;
pub extern fn history_get_history_state() [*c]HISTORY_STATE;
pub extern fn history_set_history_state([*c]HISTORY_STATE) void;
pub extern fn add_history([*c]const u8) void;
pub extern fn add_history_time([*c]const u8) void;
pub extern fn remove_history(c_int) [*c]HIST_ENTRY;
pub extern fn remove_history_range(c_int, c_int) [*c][*c]HIST_ENTRY;
pub extern fn alloc_history_entry([*c]u8, [*c]u8) [*c]HIST_ENTRY;
pub extern fn copy_history_entry([*c]HIST_ENTRY) [*c]HIST_ENTRY;
pub extern fn free_history_entry([*c]HIST_ENTRY) histdata_t;
pub extern fn replace_history_entry(c_int, [*c]const u8, histdata_t) [*c]HIST_ENTRY;
pub extern fn clear_history() void;
pub extern fn stifle_history(c_int) void;
pub extern fn unstifle_history() c_int;
pub extern fn history_is_stifled() c_int;
pub extern fn history_list() [*c][*c]HIST_ENTRY;
pub extern fn where_history() c_int;
pub extern fn current_history() [*c]HIST_ENTRY;
pub extern fn history_get(c_int) [*c]HIST_ENTRY;
pub extern fn history_get_time([*c]HIST_ENTRY) time_t;
pub extern fn history_total_bytes() c_int;
pub extern fn history_set_pos(c_int) c_int;
pub extern fn previous_history() [*c]HIST_ENTRY;
pub extern fn next_history() [*c]HIST_ENTRY;
pub extern fn history_search([*c]const u8, c_int) c_int;
pub extern fn history_search_prefix([*c]const u8, c_int) c_int;
pub extern fn history_search_pos([*c]const u8, c_int, c_int) c_int;
pub extern fn read_history([*c]const u8) c_int;
pub extern fn read_history_range([*c]const u8, c_int, c_int) c_int;
pub extern fn write_history([*c]const u8) c_int;
pub extern fn append_history(c_int, [*c]const u8) c_int;
pub extern fn history_truncate_file([*c]const u8, c_int) c_int;
pub extern fn history_expand([*c]u8, [*c][*c]u8) c_int;
pub extern fn history_arg_extract(c_int, c_int, [*c]const u8) [*c]u8;
pub extern fn get_history_event([*c]const u8, [*c]c_int, c_int) [*c]u8;
pub extern fn history_tokenize([*c]const u8) [*c][*c]u8;
pub extern var history_base: c_int;
pub extern var history_length: c_int;
pub extern var history_max_entries: c_int;
pub extern var history_offset: c_int;
pub extern var history_lines_read_from_file: c_int;
pub extern var history_lines_written_to_file: c_int;
pub extern var history_expansion_char: u8;
pub extern var history_subst_char: u8;
pub extern var history_word_delimiters: [*c]u8;
pub extern var history_comment_char: u8;
pub extern var history_no_expand_chars: [*c]u8;
pub extern var history_search_delimiter_chars: [*c]u8;
pub extern var history_quotes_inhibit_expansion: c_int;
pub extern var history_quoting_state: c_int;
pub extern var history_write_timestamps: c_int;
pub extern var history_multiline_entries: c_int;
pub extern var history_file_version: c_int;
pub extern var max_input_history: c_int;
pub extern var history_inhibit_expansion_function: ?*const rl_linebuf_func_t;

pub const __VERSION__ = "Aro aro-zig";
pub const __Aro__ = "";
pub const __STDC__ = @as(c_int, 1);
pub const __STDC_HOSTED__ = @as(c_int, 1);
pub const __STDC_UTF_16__ = @as(c_int, 1);
pub const __STDC_UTF_32__ = @as(c_int, 1);
pub const __STDC_EMBED_NOT_FOUND__ = @as(c_int, 0);
pub const __STDC_EMBED_FOUND__ = @as(c_int, 1);
pub const __STDC_EMBED_EMPTY__ = @as(c_int, 2);
pub const __STDC_VERSION__ = @as(c_long, 201710);
pub const __GNUC__ = @as(c_int, 7);
pub const __GNUC_MINOR__ = @as(c_int, 1);
pub const __GNUC_PATCHLEVEL__ = @as(c_int, 0);
pub const __ARO_EMULATE_NO__ = @as(c_int, 0);
pub const __ARO_EMULATE_CLANG__ = @as(c_int, 1);
pub const __ARO_EMULATE_GCC__ = @as(c_int, 2);
pub const __ARO_EMULATE_MSVC__ = @as(c_int, 3);
pub const __ARO_EMULATE__ = __ARO_EMULATE_GCC__;
pub inline fn __building_module(x: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &x;
    return @as(c_int, 0);
}
pub const linux = @as(c_int, 1);
pub const __linux = @as(c_int, 1);
pub const __linux__ = @as(c_int, 1);
pub const unix = @as(c_int, 1);
pub const __unix = @as(c_int, 1);
pub const __unix__ = @as(c_int, 1);
pub const __code_model_small__ = @as(c_int, 1);
pub const __amd64__ = @as(c_int, 1);
pub const __amd64 = @as(c_int, 1);
pub const __x86_64__ = @as(c_int, 1);
pub const __x86_64 = @as(c_int, 1);
pub const __SEG_GS = @as(c_int, 1);
pub const __SEG_FS = @as(c_int, 1);
pub const __seg_gs = @compileError("unable to translate macro: undefined identifier `address_space`"); // <builtin>:33:9
pub const __seg_fs = @compileError("unable to translate macro: undefined identifier `address_space`"); // <builtin>:34:9
pub const __LAHF_SAHF__ = @as(c_int, 1);
pub const __AES__ = @as(c_int, 1);
pub const __VAES__ = @as(c_int, 1);
pub const __PCLMUL__ = @as(c_int, 1);
pub const __VPCLMULQDQ__ = @as(c_int, 1);
pub const __LZCNT__ = @as(c_int, 1);
pub const __RDRND__ = @as(c_int, 1);
pub const __FSGSBASE__ = @as(c_int, 1);
pub const __BMI__ = @as(c_int, 1);
pub const __BMI2__ = @as(c_int, 1);
pub const __POPCNT__ = @as(c_int, 1);
pub const __PRFCHW__ = @as(c_int, 1);
pub const __RDSEED__ = @as(c_int, 1);
pub const __ADX__ = @as(c_int, 1);
pub const __MOVBE__ = @as(c_int, 1);
pub const __FMA__ = @as(c_int, 1);
pub const __F16C__ = @as(c_int, 1);
pub const __GFNI__ = @as(c_int, 1);
pub const __EVEX512__ = @as(c_int, 1);
pub const __AVX512CD__ = @as(c_int, 1);
pub const __AVX512VPOPCNTDQ__ = @as(c_int, 1);
pub const __AVX512VNNI__ = @as(c_int, 1);
pub const __AVX512DQ__ = @as(c_int, 1);
pub const __AVX512BITALG__ = @as(c_int, 1);
pub const __AVX512BW__ = @as(c_int, 1);
pub const __AVX512VL__ = @as(c_int, 1);
pub const __EVEX256__ = @as(c_int, 1);
pub const __AVX512VBMI__ = @as(c_int, 1);
pub const __AVX512VBMI2__ = @as(c_int, 1);
pub const __AVX512IFMA__ = @as(c_int, 1);
pub const __AVX512VP2INTERSECT__ = @as(c_int, 1);
pub const __SHA__ = @as(c_int, 1);
pub const __FXSR__ = @as(c_int, 1);
pub const __XSAVE__ = @as(c_int, 1);
pub const __XSAVEOPT__ = @as(c_int, 1);
pub const __XSAVEC__ = @as(c_int, 1);
pub const __XSAVES__ = @as(c_int, 1);
pub const __PKU__ = @as(c_int, 1);
pub const __CLFLUSHOPT__ = @as(c_int, 1);
pub const __CLWB__ = @as(c_int, 1);
pub const __SHSTK__ = @as(c_int, 1);
pub const __KL__ = @as(c_int, 1);
pub const __WIDEKL__ = @as(c_int, 1);
pub const __RDPID__ = @as(c_int, 1);
pub const __MOVDIRI__ = @as(c_int, 1);
pub const __MOVDIR64B__ = @as(c_int, 1);
pub const __INVPCID__ = @as(c_int, 1);
pub const __CRC32__ = @as(c_int, 1);
pub const __AVX512F__ = @as(c_int, 1);
pub const __AVX2__ = @as(c_int, 1);
pub const __AVX__ = @as(c_int, 1);
pub const __SSE4_2__ = @as(c_int, 1);
pub const __SSE4_1__ = @as(c_int, 1);
pub const __SSSE3__ = @as(c_int, 1);
pub const __SSE3__ = @as(c_int, 1);
pub const __SSE2__ = @as(c_int, 1);
pub const __SSE__ = @as(c_int, 1);
pub const __SSE_MATH__ = @as(c_int, 1);
pub const __MMX__ = @as(c_int, 1);
pub const __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 = @as(c_int, 1);
pub const __SIZEOF_FLOAT128__ = @as(c_int, 16);
pub const _LP64 = @as(c_int, 1);
pub const __LP64__ = @as(c_int, 1);
pub const __FLOAT128__ = @as(c_int, 1);
pub const __ORDER_LITTLE_ENDIAN__ = @as(c_int, 1234);
pub const __ORDER_BIG_ENDIAN__ = @as(c_int, 4321);
pub const __ORDER_PDP_ENDIAN__ = @as(c_int, 3412);
pub const __BYTE_ORDER__ = __ORDER_LITTLE_ENDIAN__;
pub const __LITTLE_ENDIAN__ = @as(c_int, 1);
pub const __ELF__ = @as(c_int, 1);
pub const __ATOMIC_RELAXED = @as(c_int, 0);
pub const __ATOMIC_CONSUME = @as(c_int, 1);
pub const __ATOMIC_ACQUIRE = @as(c_int, 2);
pub const __ATOMIC_RELEASE = @as(c_int, 3);
pub const __ATOMIC_ACQ_REL = @as(c_int, 4);
pub const __ATOMIC_SEQ_CST = @as(c_int, 5);
pub const __ATOMIC_BOOL_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR16_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_CHAR32_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_WCHAR_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_WINT_T_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_SHORT_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_INT_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_LONG_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_LLONG_LOCK_FREE = @as(c_int, 1);
pub const __ATOMIC_POINTER_LOCK_FREE = @as(c_int, 1);
pub const __WINT_UNSIGNED__ = @as(c_int, 1);
pub const __CHAR_BIT__ = @as(c_int, 8);
pub const __BOOL_WIDTH__ = @as(c_int, 8);
pub const __SCHAR_MAX__ = @as(c_int, 127);
pub const __SCHAR_WIDTH__ = @as(c_int, 8);
pub const __SHRT_MAX__ = @as(c_int, 32767);
pub const __SHRT_WIDTH__ = @as(c_int, 16);
pub const __INT_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_WIDTH__ = @as(c_int, 32);
pub const __LONG_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __LONG_WIDTH__ = @as(c_int, 64);
pub const __LONG_LONG_MAX__ = @as(c_longlong, 9223372036854775807);
pub const __LONG_LONG_WIDTH__ = @as(c_int, 64);
pub const __WCHAR_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __WCHAR_WIDTH__ = @as(c_int, 32);
pub const __WINT_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __WINT_WIDTH__ = @as(c_int, 32);
pub const __INTMAX_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTMAX_WIDTH__ = @as(c_int, 64);
pub const __SIZE_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __SIZE_WIDTH__ = @as(c_int, 64);
pub const __UINTMAX_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTMAX_WIDTH__ = @as(c_int, 64);
pub const __PTRDIFF_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __PTRDIFF_WIDTH__ = @as(c_int, 64);
pub const __INTPTR_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INTPTR_WIDTH__ = @as(c_int, 64);
pub const __UINTPTR_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __UINTPTR_WIDTH__ = @as(c_int, 64);
pub const __SIG_ATOMIC_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __SIG_ATOMIC_WIDTH__ = @as(c_int, 32);
pub const __BITINT_MAXWIDTH__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const __SIZEOF_FLOAT__ = @as(c_int, 4);
pub const __SIZEOF_DOUBLE__ = @as(c_int, 8);
pub const __SIZEOF_LONG_DOUBLE__ = @as(c_int, 10);
pub const __SIZEOF_SHORT__ = @as(c_int, 2);
pub const __SIZEOF_INT__ = @as(c_int, 4);
pub const __SIZEOF_LONG__ = @as(c_int, 8);
pub const __SIZEOF_LONG_LONG__ = @as(c_int, 8);
pub const __SIZEOF_POINTER__ = @as(c_int, 8);
pub const __SIZEOF_PTRDIFF_T__ = @as(c_int, 8);
pub const __SIZEOF_SIZE_T__ = @as(c_int, 8);
pub const __SIZEOF_WCHAR_T__ = @as(c_int, 4);
pub const __SIZEOF_WINT_T__ = @as(c_int, 4);
pub const __SIZEOF_INT128__ = @as(c_int, 16);
pub const __INTPTR_TYPE__ = c_long;
pub const __UINTPTR_TYPE__ = c_ulong;
pub const __INTMAX_TYPE__ = c_long;
pub const __INTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // <builtin>:171:9
pub const __INTMAX_C = __helpers.L_SUFFIX;
pub const __UINTMAX_TYPE__ = c_ulong;
pub const __UINTMAX_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // <builtin>:174:9
pub const __UINTMAX_C = __helpers.UL_SUFFIX;
pub const __PTRDIFF_TYPE__ = c_long;
pub const __SIZE_TYPE__ = c_ulong;
pub const __WCHAR_TYPE__ = c_int;
pub const __WINT_TYPE__ = c_uint;
pub const __CHAR16_TYPE__ = c_ushort;
pub const __CHAR32_TYPE__ = c_uint;
pub const __INT8_TYPE__ = i8;
pub const __INT8_FMTd__ = "hhd";
pub const __INT8_FMTi__ = "hhi";
pub const __INT8_C_SUFFIX__ = "";
pub inline fn __INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT16_TYPE__ = c_short;
pub const __INT16_FMTd__ = "hd";
pub const __INT16_FMTi__ = "hi";
pub const __INT16_C_SUFFIX__ = "";
pub inline fn __INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT32_TYPE__ = c_int;
pub const __INT32_FMTd__ = "d";
pub const __INT32_FMTi__ = "i";
pub const __INT32_C_SUFFIX__ = "";
pub inline fn __INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __INT64_TYPE__ = c_long;
pub const __INT64_FMTd__ = "ld";
pub const __INT64_FMTi__ = "li";
pub const __INT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `L`"); // <builtin>:200:9
pub const __INT64_C = __helpers.L_SUFFIX;
pub const __UINT8_TYPE__ = u8;
pub const __UINT8_FMTo__ = "hho";
pub const __UINT8_FMTu__ = "hhu";
pub const __UINT8_FMTx__ = "hhx";
pub const __UINT8_FMTX__ = "hhX";
pub const __UINT8_C_SUFFIX__ = "";
pub inline fn __UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT8_MAX__ = @as(c_int, 255);
pub const __INT8_MAX__ = @as(c_int, 127);
pub const __UINT16_TYPE__ = c_ushort;
pub const __UINT16_FMTo__ = "ho";
pub const __UINT16_FMTu__ = "hu";
pub const __UINT16_FMTx__ = "hx";
pub const __UINT16_FMTX__ = "hX";
pub const __UINT16_C_SUFFIX__ = "";
pub inline fn __UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const __UINT16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const __INT16_MAX__ = @as(c_int, 32767);
pub const __UINT32_TYPE__ = c_uint;
pub const __UINT32_FMTo__ = "o";
pub const __UINT32_FMTu__ = "u";
pub const __UINT32_FMTx__ = "x";
pub const __UINT32_FMTX__ = "X";
pub const __UINT32_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `U`"); // <builtin>:225:9
pub const __UINT32_C = __helpers.U_SUFFIX;
pub const __UINT32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const __INT32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __UINT64_TYPE__ = c_ulong;
pub const __UINT64_FMTo__ = "lo";
pub const __UINT64_FMTu__ = "lu";
pub const __UINT64_FMTx__ = "lx";
pub const __UINT64_FMTX__ = "lX";
pub const __UINT64_C_SUFFIX__ = @compileError("unable to translate macro: undefined identifier `UL`"); // <builtin>:234:9
pub const __UINT64_C = __helpers.UL_SUFFIX;
pub const __UINT64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const __INT64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST8_TYPE__ = i8;
pub const __INT_LEAST8_MAX__ = @as(c_int, 127);
pub const __INT_LEAST8_WIDTH__ = @as(c_int, 8);
pub const INT_LEAST8_FMTd__ = "hhd";
pub const INT_LEAST8_FMTi__ = "hhi";
pub const __UINT_LEAST8_TYPE__ = u8;
pub const __UINT_LEAST8_MAX__ = @as(c_int, 255);
pub const UINT_LEAST8_FMTo__ = "hho";
pub const UINT_LEAST8_FMTu__ = "hhu";
pub const UINT_LEAST8_FMTx__ = "hhx";
pub const UINT_LEAST8_FMTX__ = "hhX";
pub const __INT_FAST8_TYPE__ = i8;
pub const __INT_FAST8_MAX__ = @as(c_int, 127);
pub const __INT_FAST8_WIDTH__ = @as(c_int, 8);
pub const INT_FAST8_FMTd__ = "hhd";
pub const INT_FAST8_FMTi__ = "hhi";
pub const __UINT_FAST8_TYPE__ = u8;
pub const __UINT_FAST8_MAX__ = @as(c_int, 255);
pub const UINT_FAST8_FMTo__ = "hho";
pub const UINT_FAST8_FMTu__ = "hhu";
pub const UINT_FAST8_FMTx__ = "hhx";
pub const UINT_FAST8_FMTX__ = "hhX";
pub const __INT_LEAST16_TYPE__ = c_short;
pub const __INT_LEAST16_MAX__ = @as(c_int, 32767);
pub const __INT_LEAST16_WIDTH__ = @as(c_int, 16);
pub const INT_LEAST16_FMTd__ = "hd";
pub const INT_LEAST16_FMTi__ = "hi";
pub const __UINT_LEAST16_TYPE__ = c_ushort;
pub const __UINT_LEAST16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST16_FMTo__ = "ho";
pub const UINT_LEAST16_FMTu__ = "hu";
pub const UINT_LEAST16_FMTx__ = "hx";
pub const UINT_LEAST16_FMTX__ = "hX";
pub const __INT_FAST16_TYPE__ = c_short;
pub const __INT_FAST16_MAX__ = @as(c_int, 32767);
pub const __INT_FAST16_WIDTH__ = @as(c_int, 16);
pub const INT_FAST16_FMTd__ = "hd";
pub const INT_FAST16_FMTi__ = "hi";
pub const __UINT_FAST16_TYPE__ = c_ushort;
pub const __UINT_FAST16_MAX__ = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_FAST16_FMTo__ = "ho";
pub const UINT_FAST16_FMTu__ = "hu";
pub const UINT_FAST16_FMTx__ = "hx";
pub const UINT_FAST16_FMTX__ = "hX";
pub const __INT_LEAST32_TYPE__ = c_int;
pub const __INT_LEAST32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_LEAST32_WIDTH__ = @as(c_int, 32);
pub const INT_LEAST32_FMTd__ = "d";
pub const INT_LEAST32_FMTi__ = "i";
pub const __UINT_LEAST32_TYPE__ = c_uint;
pub const __UINT_LEAST32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST32_FMTo__ = "o";
pub const UINT_LEAST32_FMTu__ = "u";
pub const UINT_LEAST32_FMTx__ = "x";
pub const UINT_LEAST32_FMTX__ = "X";
pub const __INT_FAST32_TYPE__ = c_int;
pub const __INT_FAST32_MAX__ = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const __INT_FAST32_WIDTH__ = @as(c_int, 32);
pub const INT_FAST32_FMTd__ = "d";
pub const INT_FAST32_FMTi__ = "i";
pub const __UINT_FAST32_TYPE__ = c_uint;
pub const __UINT_FAST32_MAX__ = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_FAST32_FMTo__ = "o";
pub const UINT_FAST32_FMTu__ = "u";
pub const UINT_FAST32_FMTx__ = "x";
pub const UINT_FAST32_FMTX__ = "X";
pub const __INT_LEAST64_TYPE__ = c_long;
pub const __INT_LEAST64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_LEAST64_WIDTH__ = @as(c_int, 64);
pub const INT_LEAST64_FMTd__ = "ld";
pub const INT_LEAST64_FMTi__ = "li";
pub const __UINT_LEAST64_TYPE__ = c_ulong;
pub const __UINT_LEAST64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_LEAST64_FMTo__ = "lo";
pub const UINT_LEAST64_FMTu__ = "lu";
pub const UINT_LEAST64_FMTx__ = "lx";
pub const UINT_LEAST64_FMTX__ = "lX";
pub const __INT_FAST64_TYPE__ = c_long;
pub const __INT_FAST64_MAX__ = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const __INT_FAST64_WIDTH__ = @as(c_int, 64);
pub const INT_FAST64_FMTd__ = "ld";
pub const INT_FAST64_FMTi__ = "li";
pub const __UINT_FAST64_TYPE__ = c_ulong;
pub const __UINT_FAST64_MAX__ = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_FMTo__ = "lo";
pub const UINT_FAST64_FMTu__ = "lu";
pub const UINT_FAST64_FMTx__ = "lx";
pub const UINT_FAST64_FMTX__ = "lX";
pub const __FLT16_DENORM_MIN__ = @as(f16, 5.9604644775390625e-8);
pub const __FLT16_HAS_DENORM__ = "";
pub const __FLT16_DIG__ = @as(c_int, 3);
pub const __FLT16_DECIMAL_DIG__ = @as(c_int, 5);
pub const __FLT16_EPSILON__ = @as(f16, 9.765625e-4);
pub const __FLT16_HAS_INFINITY__ = "";
pub const __FLT16_HAS_QUIET_NAN__ = "";
pub const __FLT16_MANT_DIG__ = @as(c_int, 11);
pub const __FLT16_MAX_10_EXP__ = @as(c_int, 4);
pub const __FLT16_MAX_EXP__ = @as(c_int, 16);
pub const __FLT16_MAX__ = @as(f16, 6.5504e+4);
pub const __FLT16_MIN_10_EXP__ = -@as(c_int, 4);
pub const __FLT16_MIN_EXP__ = -@as(c_int, 13);
pub const __FLT16_MIN__ = @as(f16, 6.103515625e-5);
pub const __FLT_DENORM_MIN__ = @as(f32, 1.40129846e-45);
pub const __FLT_HAS_DENORM__ = "";
pub const __FLT_DIG__ = @as(c_int, 6);
pub const __FLT_DECIMAL_DIG__ = @as(c_int, 9);
pub const __FLT_EPSILON__ = @as(f32, 1.19209290e-7);
pub const __FLT_HAS_INFINITY__ = "";
pub const __FLT_HAS_QUIET_NAN__ = "";
pub const __FLT_MANT_DIG__ = @as(c_int, 24);
pub const __FLT_MAX_10_EXP__ = @as(c_int, 38);
pub const __FLT_MAX_EXP__ = @as(c_int, 128);
pub const __FLT_MAX__ = @as(f32, 3.40282347e+38);
pub const __FLT_MIN_10_EXP__ = -@as(c_int, 37);
pub const __FLT_MIN_EXP__ = -@as(c_int, 125);
pub const __FLT_MIN__ = @as(f32, 1.17549435e-38);
pub const __DBL_DENORM_MIN__ = @as(f64, 4.9406564584124654e-324);
pub const __DBL_HAS_DENORM__ = "";
pub const __DBL_DIG__ = @as(c_int, 15);
pub const __DBL_DECIMAL_DIG__ = @as(c_int, 17);
pub const __DBL_EPSILON__ = @as(f64, 2.2204460492503131e-16);
pub const __DBL_HAS_INFINITY__ = "";
pub const __DBL_HAS_QUIET_NAN__ = "";
pub const __DBL_MANT_DIG__ = @as(c_int, 53);
pub const __DBL_MAX_10_EXP__ = @as(c_int, 308);
pub const __DBL_MAX_EXP__ = @as(c_int, 1024);
pub const __DBL_MAX__ = @as(f64, 1.7976931348623157e+308);
pub const __DBL_MIN_10_EXP__ = -@as(c_int, 307);
pub const __DBL_MIN_EXP__ = -@as(c_int, 1021);
pub const __DBL_MIN__ = @as(f64, 2.2250738585072014e-308);
pub const __LDBL_DENORM_MIN__ = @as(c_longdouble, 3.64519953188247460253e-4951);
pub const __LDBL_HAS_DENORM__ = "";
pub const __LDBL_DIG__ = @as(c_int, 18);
pub const __LDBL_DECIMAL_DIG__ = @as(c_int, 21);
pub const __LDBL_EPSILON__ = @as(c_longdouble, 1.08420217248550443401e-19);
pub const __LDBL_HAS_INFINITY__ = "";
pub const __LDBL_HAS_QUIET_NAN__ = "";
pub const __LDBL_MANT_DIG__ = @as(c_int, 64);
pub const __LDBL_MAX_10_EXP__ = @as(c_int, 4932);
pub const __LDBL_MAX_EXP__ = @as(c_int, 16384);
pub const __LDBL_MAX__ = @as(c_longdouble, 1.18973149535723176502e+4932);
pub const __LDBL_MIN_10_EXP__ = -@as(c_int, 4931);
pub const __LDBL_MIN_EXP__ = -@as(c_int, 16381);
pub const __LDBL_MIN__ = @as(c_longdouble, 3.36210314311209350626e-4932);
pub const __FLT_EVAL_METHOD__ = @as(c_int, 0);
pub const __FLT_RADIX__ = @as(c_int, 2);
pub const __DECIMAL_DIG__ = __LDBL_DECIMAL_DIG__;
pub const __pic__ = @as(c_int, 2);
pub const __PIC__ = @as(c_int, 2);
pub const __GLIBC_MINOR__ = @as(c_int, 41);
pub const __STDC_VERSION_STDDEF_H__ = @as(c_long, 202311);
pub const NULL = __helpers.cast(?*anyopaque, @as(c_int, 0));
pub const offsetof = @compileError("unable to translate macro: undefined identifier `__builtin_offsetof`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stddef.h:18:9
pub const __CLANG_STDINT_H = "";
pub const _STDINT_H = @as(c_int, 1);
pub const _FEATURES_H = @as(c_int, 1);
pub const __KERNEL_STRICT_NAMES = "";
pub inline fn __GNUC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GNUC__ << @as(c_int, 16)) + __GNUC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub inline fn __glibc_clang_prereq(maj: anytype, min: anytype) @TypeOf(@as(c_int, 0)) {
    _ = &maj;
    _ = &min;
    return @as(c_int, 0);
}
pub const __GLIBC_USE = @compileError("unable to translate macro: undefined identifier `__GLIBC_USE_`"); // /usr/include/features.h:191:9
pub const _DEFAULT_SOURCE = @as(c_int, 1);
pub const __GLIBC_USE_ISOC2Y = @as(c_int, 0);
pub const __GLIBC_USE_ISOC23 = @as(c_int, 0);
pub const __USE_ISOC11 = @as(c_int, 1);
pub const __USE_POSIX_IMPLICITLY = @as(c_int, 1);
pub const _POSIX_SOURCE = @as(c_int, 1);
pub const _POSIX_C_SOURCE = @as(c_long, 200809);
pub const __USE_POSIX = @as(c_int, 1);
pub const __USE_POSIX2 = @as(c_int, 1);
pub const __USE_POSIX199309 = @as(c_int, 1);
pub const __USE_POSIX199506 = @as(c_int, 1);
pub const __USE_XOPEN2K = @as(c_int, 1);
pub const __USE_ISOC95 = @as(c_int, 1);
pub const __USE_ISOC99 = @as(c_int, 1);
pub const __USE_XOPEN2K8 = @as(c_int, 1);
pub const _ATFILE_SOURCE = @as(c_int, 1);
pub const __WORDSIZE = @as(c_int, 64);
pub const __WORDSIZE_TIME64_COMPAT32 = @as(c_int, 1);
pub const __SYSCALL_WORDSIZE = @as(c_int, 64);
pub const __TIMESIZE = __WORDSIZE;
pub const __USE_TIME_BITS64 = @as(c_int, 1);
pub const __USE_MISC = @as(c_int, 1);
pub const __USE_ATFILE = @as(c_int, 1);
pub const __USE_FORTIFY_LEVEL = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_GETS = @as(c_int, 0);
pub const __GLIBC_USE_DEPRECATED_SCANF = @as(c_int, 0);
pub const __GLIBC_USE_C23_STRTOL = @as(c_int, 0);
pub const _STDC_PREDEF_H = @as(c_int, 1);
pub const __STDC_IEC_559__ = @as(c_int, 1);
pub const __STDC_IEC_60559_BFP__ = @as(c_long, 201404);
pub const __STDC_IEC_559_COMPLEX__ = @as(c_int, 1);
pub const __STDC_IEC_60559_COMPLEX__ = @as(c_long, 201404);
pub const __STDC_ISO_10646__ = @as(c_long, 201706);
pub const __GNU_LIBRARY__ = @as(c_int, 6);
pub const __GLIBC__ = @as(c_int, 2);
pub inline fn __GLIBC_PREREQ(maj: anytype, min: anytype) @TypeOf(((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min)) {
    _ = &maj;
    _ = &min;
    return ((__GLIBC__ << @as(c_int, 16)) + __GLIBC_MINOR__) >= ((maj << @as(c_int, 16)) + min);
}
pub const _SYS_CDEFS_H = @as(c_int, 1);
pub const __glibc_has_attribute = @compileError("unable to translate macro: undefined identifier `__has_attribute`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:45:10
pub inline fn __glibc_has_builtin(name: anytype) @TypeOf(__builtin.has_builtin(name)) {
    _ = &name;
    return __builtin.has_builtin(name);
}
pub const __glibc_has_extension = @compileError("unable to translate macro: undefined identifier `__has_extension`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:55:10
pub const __LEAF = @compileError("unable to translate macro: undefined identifier `__leaf__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:65:11
pub const __LEAF_ATTR = @compileError("unable to translate macro: undefined identifier `__leaf__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:66:11
pub const __THROW = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:79:11
pub const __THROWNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:80:11
pub const __NTH = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:81:11
pub const __NTHNL = @compileError("unable to translate macro: undefined identifier `__nothrow__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:82:11
pub const __COLD = @compileError("unable to translate macro: undefined identifier `__cold__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:102:11
pub inline fn __P(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub inline fn __PMT(args: anytype) @TypeOf(args) {
    _ = &args;
    return args;
}
pub const __CONCAT = @compileError("unable to translate C expr: unexpected token '##'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:131:9
pub const __STRING = @compileError("unable to translate C expr: unexpected token ''"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:132:9
pub const __ptr_t = ?*anyopaque;
pub const __BEGIN_DECLS = "";
pub const __END_DECLS = "";
pub const __attribute_overloadable__ = "";
pub inline fn __bos(ptr: anytype) @TypeOf(__builtin.object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1))) {
    _ = &ptr;
    return __builtin.object_size(ptr, __USE_FORTIFY_LEVEL > @as(c_int, 1));
}
pub inline fn __bos0(ptr: anytype) @TypeOf(__builtin.object_size(ptr, @as(c_int, 0))) {
    _ = &ptr;
    return __builtin.object_size(ptr, @as(c_int, 0));
}
pub inline fn __glibc_objsize0(__o: anytype) @TypeOf(__bos0(__o)) {
    _ = &__o;
    return __bos0(__o);
}
pub inline fn __glibc_objsize(__o: anytype) @TypeOf(__bos(__o)) {
    _ = &__o;
    return __bos(__o);
}
pub const __warnattr = @compileError("unable to translate macro: undefined identifier `__warning__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:366:10
pub const __errordecl = @compileError("unable to translate macro: undefined identifier `__error__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:367:10
pub const __flexarr = @compileError("unable to translate C expr: unexpected token '['"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:379:10
pub const __glibc_c99_flexarr_available = @as(c_int, 1);
pub const __REDIRECT = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:410:10
pub const __REDIRECT_NTH = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:417:11
pub const __REDIRECT_NTHNL = @compileError("unable to translate C expr: unexpected token '__asm__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:419:11
pub const __ASMNAME = @compileError("unable to translate macro: undefined identifier `__USER_LABEL_PREFIX__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:422:10
pub inline fn __ASMNAME2(prefix: anytype, cname: anytype) @TypeOf(__STRING(prefix) ++ cname) {
    _ = &prefix;
    _ = &cname;
    return __STRING(prefix) ++ cname;
}
pub const __REDIRECT_FORTIFY = __REDIRECT;
pub const __REDIRECT_FORTIFY_NTH = __REDIRECT_NTH;
pub const __attribute_malloc__ = @compileError("unable to translate macro: undefined identifier `__malloc__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:452:10
pub const __attribute_alloc_size__ = @compileError("unable to translate macro: undefined identifier `__alloc_size__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:460:10
pub const __attribute_alloc_align__ = @compileError("unable to translate macro: undefined identifier `__alloc_align__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:469:10
pub const __attribute_pure__ = @compileError("unable to translate macro: undefined identifier `__pure__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:479:10
pub const __attribute_const__ = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:486:10
pub const __attribute_maybe_unused__ = @compileError("unable to translate macro: undefined identifier `__unused__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:492:10
pub const __attribute_used__ = @compileError("unable to translate macro: undefined identifier `__used__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:501:10
pub const __attribute_noinline__ = @compileError("unable to translate macro: undefined identifier `__noinline__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:502:10
pub const __attribute_deprecated__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:510:10
pub const __attribute_deprecated_msg__ = @compileError("unable to translate macro: undefined identifier `__deprecated__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:520:10
pub const __attribute_format_arg__ = @compileError("unable to translate macro: undefined identifier `__format_arg__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:533:10
pub const __attribute_format_strfmon__ = @compileError("unable to translate macro: undefined identifier `__format__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:543:10
pub const __attribute_nonnull__ = @compileError("unable to translate macro: undefined identifier `__nonnull__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:555:11
pub inline fn __nonnull(params: anytype) @TypeOf(__attribute_nonnull__(params)) {
    _ = &params;
    return __attribute_nonnull__(params);
}
pub const __returns_nonnull = @compileError("unable to translate macro: undefined identifier `__returns_nonnull__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:568:10
pub const __attribute_warn_unused_result__ = @compileError("unable to translate macro: undefined identifier `__warn_unused_result__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:577:10
pub const __wur = "";
pub const __always_inline = @compileError("unable to translate macro: undefined identifier `__always_inline__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:595:10
pub const __attribute_artificial__ = @compileError("unable to translate macro: undefined identifier `__artificial__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:604:10
pub const __extern_inline = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:626:11
pub const __extern_always_inline = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:627:11
pub const __fortify_function = __extern_always_inline ++ __attribute_artificial__;
pub const __va_arg_pack = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg_pack`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:638:10
pub const __va_arg_pack_len = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg_pack_len`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:639:10
pub const __restrict_arr = @compileError("unable to translate C expr: unexpected token '__restrict'"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:666:10
pub inline fn __glibc_unlikely(cond: anytype) @TypeOf(__builtin.expect(cond, @as(c_int, 0))) {
    _ = &cond;
    return __builtin.expect(cond, @as(c_int, 0));
}
pub inline fn __glibc_likely(cond: anytype) @TypeOf(__builtin.expect(cond, @as(c_int, 1))) {
    _ = &cond;
    return __builtin.expect(cond, @as(c_int, 1));
}
pub const __attribute_nonstring__ = "";
pub inline fn __attribute_copy__(arg: anytype) void {
    _ = &arg;
    return;
}
pub const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = @as(c_int, 0);
pub inline fn __LDBL_REDIR1(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR(name: anytype, proto: anytype) @TypeOf(name ++ proto) {
    _ = &name;
    _ = &proto;
    return name ++ proto;
}
pub inline fn __LDBL_REDIR1_NTH(name: anytype, proto: anytype, alias: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR_NTH(name: anytype, proto: anytype) @TypeOf(name ++ proto ++ __THROW) {
    _ = &name;
    _ = &proto;
    return name ++ proto ++ __THROW;
}
pub inline fn __LDBL_REDIR2_DECL(name: anytype) void {
    _ = &name;
    return;
}
pub inline fn __LDBL_REDIR_DECL(name: anytype) void {
    _ = &name;
    return;
}
pub inline fn __REDIRECT_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT(name, proto, alias);
}
pub inline fn __REDIRECT_NTH_LDBL(name: anytype, proto: anytype, alias: anytype) @TypeOf(__REDIRECT_NTH(name, proto, alias)) {
    _ = &name;
    _ = &proto;
    _ = &alias;
    return __REDIRECT_NTH(name, proto, alias);
}
pub const __glibc_macro_warning1 = @compileError("unable to translate macro: undefined identifier `_Pragma`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:807:10
pub const __glibc_macro_warning = @compileError("unable to translate macro: undefined identifier `GCC`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:808:10
pub const __HAVE_GENERIC_SELECTION = @as(c_int, 1);
pub inline fn __fortified_attr_access(a: anytype, o: anytype, s: anytype) void {
    _ = &a;
    _ = &o;
    _ = &s;
    return;
}
pub inline fn __attr_access(x: anytype) void {
    _ = &x;
    return;
}
pub inline fn __attr_access_none(argno: anytype) void {
    _ = &argno;
    return;
}
pub inline fn __attr_dealloc(dealloc: anytype, argno: anytype) void {
    _ = &dealloc;
    _ = &argno;
    return;
}
pub const __attr_dealloc_free = "";
pub const __attribute_returns_twice__ = @compileError("unable to translate macro: undefined identifier `__returns_twice__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:872:10
pub const __attribute_struct_may_alias__ = @compileError("unable to translate macro: undefined identifier `__may_alias__`"); // /usr/include/x86_64-linux-gnu/sys/cdefs.h:881:10
pub const __stub___compat_bdflush = "";
pub const __stub_chflags = "";
pub const __stub_fchflags = "";
pub const __stub_gtty = "";
pub const __stub_revoke = "";
pub const __stub_setlogin = "";
pub const __stub_sigreturn = "";
pub const __stub_stty = "";
pub const _BITS_TYPES_H = @as(c_int, 1);
pub const __S16_TYPE = c_short;
pub const __U16_TYPE = c_ushort;
pub const __S32_TYPE = c_int;
pub const __U32_TYPE = c_uint;
pub const __SLONGWORD_TYPE = c_long;
pub const __ULONGWORD_TYPE = c_ulong;
pub const __SQUAD_TYPE = c_long;
pub const __UQUAD_TYPE = c_ulong;
pub const __SWORD_TYPE = c_long;
pub const __UWORD_TYPE = c_ulong;
pub const __SLONG32_TYPE = c_int;
pub const __ULONG32_TYPE = c_uint;
pub const __S64_TYPE = c_long;
pub const __U64_TYPE = c_ulong;
pub const _BITS_TYPESIZES_H = @as(c_int, 1);
pub const __SYSCALL_SLONG_TYPE = __SLONGWORD_TYPE;
pub const __SYSCALL_ULONG_TYPE = __ULONGWORD_TYPE;
pub const __DEV_T_TYPE = __UQUAD_TYPE;
pub const __UID_T_TYPE = __U32_TYPE;
pub const __GID_T_TYPE = __U32_TYPE;
pub const __INO_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __INO64_T_TYPE = __UQUAD_TYPE;
pub const __MODE_T_TYPE = __U32_TYPE;
pub const __NLINK_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSWORD_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __OFF64_T_TYPE = __SQUAD_TYPE;
pub const __PID_T_TYPE = __S32_TYPE;
pub const __RLIM_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __RLIM64_T_TYPE = __UQUAD_TYPE;
pub const __BLKCNT_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __BLKCNT64_T_TYPE = __SQUAD_TYPE;
pub const __FSBLKCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSBLKCNT64_T_TYPE = __UQUAD_TYPE;
pub const __FSFILCNT_T_TYPE = __SYSCALL_ULONG_TYPE;
pub const __FSFILCNT64_T_TYPE = __UQUAD_TYPE;
pub const __ID_T_TYPE = __U32_TYPE;
pub const __CLOCK_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __TIME_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __USECONDS_T_TYPE = __U32_TYPE;
pub const __SUSECONDS_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __SUSECONDS64_T_TYPE = __SQUAD_TYPE;
pub const __DADDR_T_TYPE = __S32_TYPE;
pub const __KEY_T_TYPE = __S32_TYPE;
pub const __CLOCKID_T_TYPE = __S32_TYPE;
pub const __TIMER_T_TYPE = ?*anyopaque;
pub const __BLKSIZE_T_TYPE = __SYSCALL_SLONG_TYPE;
pub const __FSID_T_TYPE = @compileError("unable to translate macro: undefined identifier `__val`"); // /usr/include/x86_64-linux-gnu/bits/typesizes.h:73:9
pub const __SSIZE_T_TYPE = __SWORD_TYPE;
pub const __CPU_MASK_TYPE = __SYSCALL_ULONG_TYPE;
pub const __OFF_T_MATCHES_OFF64_T = @as(c_int, 1);
pub const __INO_T_MATCHES_INO64_T = @as(c_int, 1);
pub const __RLIM_T_MATCHES_RLIM64_T = @as(c_int, 1);
pub const __STATFS_MATCHES_STATFS64 = @as(c_int, 1);
pub const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = @as(c_int, 1);
pub const __FD_SETSIZE = @as(c_int, 1024);
pub const _BITS_TIME64_H = @as(c_int, 1);
pub const __TIME64_T_TYPE = __TIME_T_TYPE;
pub const _BITS_WCHAR_H = @as(c_int, 1);
pub const __WCHAR_MAX = __WCHAR_MAX__;
pub const __WCHAR_MIN = -__WCHAR_MAX - @as(c_int, 1);
pub const _BITS_STDINT_INTN_H = @as(c_int, 1);
pub const _BITS_STDINT_UINTN_H = @as(c_int, 1);
pub const _BITS_STDINT_LEAST_H = @as(c_int, 1);
pub const __intptr_t_defined = "";
pub const INT8_MIN = -@as(c_int, 128);
pub const INT16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT32_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT8_MAX = @as(c_int, 127);
pub const INT16_MAX = @as(c_int, 32767);
pub const INT32_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT8_MAX = @as(c_int, 255);
pub const UINT16_MAX = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT32_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_LEAST8_MIN = -@as(c_int, 128);
pub const INT_LEAST16_MIN = -@as(c_int, 32767) - @as(c_int, 1);
pub const INT_LEAST32_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const INT_LEAST64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_LEAST8_MAX = @as(c_int, 127);
pub const INT_LEAST16_MAX = @as(c_int, 32767);
pub const INT_LEAST32_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const INT_LEAST64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_LEAST8_MAX = @as(c_int, 255);
pub const UINT_LEAST16_MAX = __helpers.promoteIntLiteral(c_int, 65535, .decimal);
pub const UINT_LEAST32_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub const UINT_LEAST64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INT_FAST8_MIN = -@as(c_int, 128);
pub const INT_FAST16_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST32_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INT_FAST64_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INT_FAST8_MAX = @as(c_int, 127);
pub const INT_FAST16_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST32_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const INT_FAST64_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINT_FAST8_MAX = @as(c_int, 255);
pub const UINT_FAST16_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST32_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const UINT_FAST64_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const INTPTR_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const INTPTR_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const UINTPTR_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const INTMAX_MIN = -__INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal)) - @as(c_int, 1);
pub const INTMAX_MAX = __INT64_C(__helpers.promoteIntLiteral(c_int, 9223372036854775807, .decimal));
pub const UINTMAX_MAX = __UINT64_C(__helpers.promoteIntLiteral(c_int, 18446744073709551615, .decimal));
pub const PTRDIFF_MIN = -__helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal) - @as(c_int, 1);
pub const PTRDIFF_MAX = __helpers.promoteIntLiteral(c_long, 9223372036854775807, .decimal);
pub const SIG_ATOMIC_MIN = -__helpers.promoteIntLiteral(c_int, 2147483647, .decimal) - @as(c_int, 1);
pub const SIG_ATOMIC_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SIZE_MAX = __helpers.promoteIntLiteral(c_ulong, 18446744073709551615, .decimal);
pub const WCHAR_MIN = __WCHAR_MIN;
pub const WCHAR_MAX = __WCHAR_MAX;
pub const WINT_MIN = @as(c_uint, 0);
pub const WINT_MAX = __helpers.promoteIntLiteral(c_uint, 4294967295, .decimal);
pub inline fn INT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn INT32_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const INT64_C = __helpers.L_SUFFIX;
pub inline fn UINT8_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub inline fn UINT16_C(c: anytype) @TypeOf(c) {
    _ = &c;
    return c;
}
pub const UINT32_C = __helpers.U_SUFFIX;
pub const UINT64_C = __helpers.UL_SUFFIX;
pub const INTMAX_C = __helpers.L_SUFFIX;
pub const UINTMAX_C = __helpers.UL_SUFFIX;
pub const ARROW_C_DATA_INTERFACE = "";
pub const ARROW_FLAG_DICTIONARY_ORDERED = @as(c_int, 1);
pub const ARROW_FLAG_NULLABLE = @as(c_int, 2);
pub const ARROW_FLAG_MAP_KEYS_SORTED = @as(c_int, 4);
pub const ARROW_C_STREAM_INTERFACE = "";
pub const ADBC = "";
pub const ADBC_EXPORT = "";
pub const ADBC_STATUS_OK = @as(c_int, 0);
pub const ADBC_STATUS_UNKNOWN = @as(c_int, 1);
pub const ADBC_STATUS_NOT_IMPLEMENTED = @as(c_int, 2);
pub const ADBC_STATUS_NOT_FOUND = @as(c_int, 3);
pub const ADBC_STATUS_ALREADY_EXISTS = @as(c_int, 4);
pub const ADBC_STATUS_INVALID_ARGUMENT = @as(c_int, 5);
pub const ADBC_STATUS_INVALID_STATE = @as(c_int, 6);
pub const ADBC_STATUS_INVALID_DATA = @as(c_int, 7);
pub const ADBC_STATUS_INTEGRITY = @as(c_int, 8);
pub const ADBC_STATUS_INTERNAL = @as(c_int, 9);
pub const ADBC_STATUS_IO = @as(c_int, 10);
pub const ADBC_STATUS_CANCELLED = @as(c_int, 11);
pub const ADBC_STATUS_TIMEOUT = @as(c_int, 12);
pub const ADBC_STATUS_UNAUTHENTICATED = @as(c_int, 13);
pub const ADBC_STATUS_UNAUTHORIZED = @as(c_int, 14);
pub const ADBC_ERROR_VENDOR_CODE_PRIVATE_DATA = INT32_MIN;
pub const ADBC_ERROR_INIT = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/local/include//arrow-adbc/adbc.h:335:9
pub const ADBC_ERROR_1_0_0_SIZE = @compileError("unable to translate macro: undefined identifier `private_data`"); // /usr/local/include//arrow-adbc/adbc.h:347:9
pub const ADBC_ERROR_1_1_0_SIZE = __helpers.sizeof(struct_AdbcError);
pub const ADBC_VERSION_1_0_0 = __helpers.promoteIntLiteral(c_int, 1000000, .decimal);
pub const ADBC_VERSION_1_1_0 = __helpers.promoteIntLiteral(c_int, 1001000, .decimal);
pub const ADBC_OPTION_VALUE_ENABLED = "true";
pub const ADBC_OPTION_VALUE_DISABLED = "false";
pub const ADBC_OPTION_URI = "uri";
pub const ADBC_OPTION_USERNAME = "username";
pub const ADBC_OPTION_PASSWORD = "password";
pub const ADBC_INFO_VENDOR_NAME = @as(c_int, 0);
pub const ADBC_INFO_VENDOR_VERSION = @as(c_int, 1);
pub const ADBC_INFO_VENDOR_ARROW_VERSION = @as(c_int, 2);
pub const ADBC_INFO_VENDOR_SQL = @as(c_int, 3);
pub const ADBC_INFO_VENDOR_SUBSTRAIT = @as(c_int, 4);
pub const ADBC_INFO_VENDOR_SUBSTRAIT_MIN_VERSION = @as(c_int, 5);
pub const ADBC_INFO_VENDOR_SUBSTRAIT_MAX_VERSION = @as(c_int, 6);
pub const ADBC_INFO_DRIVER_NAME = @as(c_int, 100);
pub const ADBC_INFO_DRIVER_VERSION = @as(c_int, 101);
pub const ADBC_INFO_DRIVER_ARROW_VERSION = @as(c_int, 102);
pub const ADBC_INFO_DRIVER_ADBC_VERSION = @as(c_int, 103);
pub const ADBC_OBJECT_DEPTH_ALL = @as(c_int, 0);
pub const ADBC_OBJECT_DEPTH_CATALOGS = @as(c_int, 1);
pub const ADBC_OBJECT_DEPTH_DB_SCHEMAS = @as(c_int, 2);
pub const ADBC_OBJECT_DEPTH_TABLES = @as(c_int, 3);
pub const ADBC_OBJECT_DEPTH_COLUMNS = ADBC_OBJECT_DEPTH_ALL;
pub const ADBC_STATISTIC_AVERAGE_BYTE_WIDTH_KEY = @as(c_int, 0);
pub const ADBC_STATISTIC_AVERAGE_BYTE_WIDTH_NAME = "adbc.statistic.byte_width";
pub const ADBC_STATISTIC_DISTINCT_COUNT_KEY = @as(c_int, 1);
pub const ADBC_STATISTIC_DISTINCT_COUNT_NAME = "adbc.statistic.distinct_count";
pub const ADBC_STATISTIC_MAX_BYTE_WIDTH_KEY = @as(c_int, 2);
pub const ADBC_STATISTIC_MAX_BYTE_WIDTH_NAME = "adbc.statistic.max_byte_width";
pub const ADBC_STATISTIC_MAX_VALUE_KEY = @as(c_int, 3);
pub const ADBC_STATISTIC_MAX_VALUE_NAME = "adbc.statistic.max_value";
pub const ADBC_STATISTIC_MIN_VALUE_KEY = @as(c_int, 4);
pub const ADBC_STATISTIC_MIN_VALUE_NAME = "adbc.statistic.min_value";
pub const ADBC_STATISTIC_NULL_COUNT_KEY = @as(c_int, 5);
pub const ADBC_STATISTIC_NULL_COUNT_NAME = "adbc.statistic.null_count";
pub const ADBC_STATISTIC_ROW_COUNT_KEY = @as(c_int, 6);
pub const ADBC_STATISTIC_ROW_COUNT_NAME = "adbc.statistic.row_count";
pub const ADBC_CONNECTION_OPTION_AUTOCOMMIT = "adbc.connection.autocommit";
pub const ADBC_CONNECTION_OPTION_READ_ONLY = "adbc.connection.readonly";
pub const ADBC_CONNECTION_OPTION_CURRENT_CATALOG = "adbc.connection.catalog";
pub const ADBC_CONNECTION_OPTION_CURRENT_DB_SCHEMA = "adbc.connection.db_schema";
pub const ADBC_STATEMENT_OPTION_INCREMENTAL = "adbc.statement.exec.incremental";
pub const ADBC_STATEMENT_OPTION_PROGRESS = "adbc.statement.exec.progress";
pub const ADBC_STATEMENT_OPTION_MAX_PROGRESS = "adbc.statement.exec.max_progress";
pub const ADBC_CONNECTION_OPTION_ISOLATION_LEVEL = "adbc.connection.transaction.isolation_level";
pub const ADBC_OPTION_ISOLATION_LEVEL_DEFAULT = "adbc.connection.transaction.isolation.default";
pub const ADBC_OPTION_ISOLATION_LEVEL_READ_UNCOMMITTED = "adbc.connection.transaction.isolation.read_uncommitted";
pub const ADBC_OPTION_ISOLATION_LEVEL_READ_COMMITTED = "adbc.connection.transaction.isolation.read_committed";
pub const ADBC_OPTION_ISOLATION_LEVEL_REPEATABLE_READ = "adbc.connection.transaction.isolation.repeatable_read";
pub const ADBC_OPTION_ISOLATION_LEVEL_SNAPSHOT = "adbc.connection.transaction.isolation.snapshot";
pub const ADBC_OPTION_ISOLATION_LEVEL_SERIALIZABLE = "adbc.connection.transaction.isolation.serializable";
pub const ADBC_OPTION_ISOLATION_LEVEL_LINEARIZABLE = "adbc.connection.transaction.isolation.linearizable";
pub const ADBC_INGEST_OPTION_TARGET_TABLE = "adbc.ingest.target_table";
pub const ADBC_INGEST_OPTION_MODE = "adbc.ingest.mode";
pub const ADBC_INGEST_OPTION_MODE_CREATE = "adbc.ingest.mode.create";
pub const ADBC_INGEST_OPTION_MODE_APPEND = "adbc.ingest.mode.append";
pub const ADBC_INGEST_OPTION_MODE_REPLACE = "adbc.ingest.mode.replace";
pub const ADBC_INGEST_OPTION_MODE_CREATE_APPEND = "adbc.ingest.mode.create_append";
pub const ADBC_INGEST_OPTION_TARGET_CATALOG = "adbc.ingest.target_catalog";
pub const ADBC_INGEST_OPTION_TARGET_DB_SCHEMA = "adbc.ingest.target_db_schema";
pub const ADBC_INGEST_OPTION_TEMPORARY = "adbc.ingest.temporary";
pub const ADBC_DRIVER_1_0_0_SIZE = @compileError("unable to translate macro: undefined identifier `ErrorGetDetailCount`"); // /usr/local/include//arrow-adbc/adbc.h:1146:9
pub const ADBC_DRIVER_1_1_0_SIZE = __helpers.sizeof(struct_AdbcDriver);
pub const NANOARROW_H_INCLUDED = "";
pub const __need_size_t = "";
pub const __need_wchar_t = "";
pub const __need_NULL = "";
pub const _STDLIB_H = @as(c_int, 1);
pub const WNOHANG = @as(c_int, 1);
pub const WUNTRACED = @as(c_int, 2);
pub const WSTOPPED = @as(c_int, 2);
pub const WEXITED = @as(c_int, 4);
pub const WCONTINUED = @as(c_int, 8);
pub const WNOWAIT = __helpers.promoteIntLiteral(c_int, 0x01000000, .hex);
pub const __WNOTHREAD = __helpers.promoteIntLiteral(c_int, 0x20000000, .hex);
pub const __WALL = __helpers.promoteIntLiteral(c_int, 0x40000000, .hex);
pub const __WCLONE = __helpers.promoteIntLiteral(c_int, 0x80000000, .hex);
pub inline fn __WEXITSTATUS(status: anytype) @TypeOf((status & __helpers.promoteIntLiteral(c_int, 0xff00, .hex)) >> @as(c_int, 8)) {
    _ = &status;
    return (status & __helpers.promoteIntLiteral(c_int, 0xff00, .hex)) >> @as(c_int, 8);
}
pub inline fn __WTERMSIG(status: anytype) @TypeOf(status & @as(c_int, 0x7f)) {
    _ = &status;
    return status & @as(c_int, 0x7f);
}
pub inline fn __WSTOPSIG(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    _ = &status;
    return __WEXITSTATUS(status);
}
pub inline fn __WIFEXITED(status: anytype) @TypeOf(__WTERMSIG(status) == @as(c_int, 0)) {
    _ = &status;
    return __WTERMSIG(status) == @as(c_int, 0);
}
pub inline fn __WIFSIGNALED(status: anytype) @TypeOf((__helpers.cast(i8, (status & @as(c_int, 0x7f)) + @as(c_int, 1)) >> @as(c_int, 1)) > @as(c_int, 0)) {
    _ = &status;
    return (__helpers.cast(i8, (status & @as(c_int, 0x7f)) + @as(c_int, 1)) >> @as(c_int, 1)) > @as(c_int, 0);
}
pub inline fn __WIFSTOPPED(status: anytype) @TypeOf((status & @as(c_int, 0xff)) == @as(c_int, 0x7f)) {
    _ = &status;
    return (status & @as(c_int, 0xff)) == @as(c_int, 0x7f);
}
pub inline fn __WIFCONTINUED(status: anytype) @TypeOf(status == __W_CONTINUED) {
    _ = &status;
    return status == __W_CONTINUED;
}
pub inline fn __WCOREDUMP(status: anytype) @TypeOf(status & __WCOREFLAG) {
    _ = &status;
    return status & __WCOREFLAG;
}
pub inline fn __W_EXITCODE(ret: anytype, sig: anytype) @TypeOf((ret << @as(c_int, 8)) | sig) {
    _ = &ret;
    _ = &sig;
    return (ret << @as(c_int, 8)) | sig;
}
pub inline fn __W_STOPCODE(sig: anytype) @TypeOf((sig << @as(c_int, 8)) | @as(c_int, 0x7f)) {
    _ = &sig;
    return (sig << @as(c_int, 8)) | @as(c_int, 0x7f);
}
pub const __W_CONTINUED = __helpers.promoteIntLiteral(c_int, 0xffff, .hex);
pub const __WCOREFLAG = @as(c_int, 0x80);
pub inline fn WEXITSTATUS(status: anytype) @TypeOf(__WEXITSTATUS(status)) {
    _ = &status;
    return __WEXITSTATUS(status);
}
pub inline fn WTERMSIG(status: anytype) @TypeOf(__WTERMSIG(status)) {
    _ = &status;
    return __WTERMSIG(status);
}
pub inline fn WSTOPSIG(status: anytype) @TypeOf(__WSTOPSIG(status)) {
    _ = &status;
    return __WSTOPSIG(status);
}
pub inline fn WIFEXITED(status: anytype) @TypeOf(__WIFEXITED(status)) {
    _ = &status;
    return __WIFEXITED(status);
}
pub inline fn WIFSIGNALED(status: anytype) @TypeOf(__WIFSIGNALED(status)) {
    _ = &status;
    return __WIFSIGNALED(status);
}
pub inline fn WIFSTOPPED(status: anytype) @TypeOf(__WIFSTOPPED(status)) {
    _ = &status;
    return __WIFSTOPPED(status);
}
pub inline fn WIFCONTINUED(status: anytype) @TypeOf(__WIFCONTINUED(status)) {
    _ = &status;
    return __WIFCONTINUED(status);
}
pub const _BITS_FLOATN_H = "";
pub const __HAVE_FLOAT128 = @as(c_int, 1);
pub const __HAVE_DISTINCT_FLOAT128 = @as(c_int, 1);
pub const __HAVE_FLOAT64X = @as(c_int, 1);
pub const __HAVE_FLOAT64X_LONG_DOUBLE = @as(c_int, 1);
pub const __f128 = @compileError("unable to translate macro: undefined identifier `f128`"); // /usr/include/x86_64-linux-gnu/bits/floatn.h:72:12
pub const __CFLOAT128 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn.h:86:12
pub const _BITS_FLOATN_COMMON_H = "";
pub const __HAVE_FLOAT16 = @as(c_int, 0);
pub const __HAVE_FLOAT32 = @as(c_int, 1);
pub const __HAVE_FLOAT64 = @as(c_int, 1);
pub const __HAVE_FLOAT32X = @as(c_int, 1);
pub const __HAVE_FLOAT128X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT16 = __HAVE_FLOAT16;
pub const __HAVE_DISTINCT_FLOAT32 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64 = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT32X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT64X = @as(c_int, 0);
pub const __HAVE_DISTINCT_FLOAT128X = __HAVE_FLOAT128X;
pub const __HAVE_FLOAT128_UNLIKE_LDBL = (__HAVE_DISTINCT_FLOAT128 != 0) and (__LDBL_MANT_DIG__ != @as(c_int, 113));
pub const __HAVE_FLOATN_NOT_TYPEDEF = @as(c_int, 1);
pub const __f32 = @compileError("unable to translate macro: undefined identifier `f32`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:93:12
pub const __f64 = @compileError("unable to translate macro: undefined identifier `f64`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:105:12
pub const __f32x = @compileError("unable to translate macro: undefined identifier `f32x`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:113:12
pub const __f64x = @compileError("unable to translate macro: undefined identifier `f64x`"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:125:12
pub const __CFLOAT32 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:151:12
pub const __CFLOAT64 = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:163:12
pub const __CFLOAT32X = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:171:12
pub const __CFLOAT64X = @compileError("unable to translate: invalid numeric type"); // /usr/include/x86_64-linux-gnu/bits/floatn-common.h:183:12
pub const __ldiv_t_defined = @as(c_int, 1);
pub const __lldiv_t_defined = @as(c_int, 1);
pub const RAND_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const EXIT_FAILURE = @as(c_int, 1);
pub const EXIT_SUCCESS = @as(c_int, 0);
pub const MB_CUR_MAX = __ctype_get_mb_cur_max();
pub const _SYS_TYPES_H = @as(c_int, 1);
pub const __u_char_defined = "";
pub const __ino_t_defined = "";
pub const __dev_t_defined = "";
pub const __gid_t_defined = "";
pub const __mode_t_defined = "";
pub const __nlink_t_defined = "";
pub const __uid_t_defined = "";
pub const __off_t_defined = "";
pub const __pid_t_defined = "";
pub const __id_t_defined = "";
pub const __ssize_t_defined = "";
pub const __daddr_t_defined = "";
pub const __key_t_defined = "";
pub const __clock_t_defined = @as(c_int, 1);
pub const __clockid_t_defined = @as(c_int, 1);
pub const __time_t_defined = @as(c_int, 1);
pub const __timer_t_defined = @as(c_int, 1);
pub const __BIT_TYPES_DEFINED__ = @as(c_int, 1);
pub const _ENDIAN_H = @as(c_int, 1);
pub const _BITS_ENDIAN_H = @as(c_int, 1);
pub const __LITTLE_ENDIAN = @as(c_int, 1234);
pub const __BIG_ENDIAN = @as(c_int, 4321);
pub const __PDP_ENDIAN = @as(c_int, 3412);
pub const _BITS_ENDIANNESS_H = @as(c_int, 1);
pub const __BYTE_ORDER = __LITTLE_ENDIAN;
pub const __FLOAT_WORD_ORDER = __BYTE_ORDER;
pub inline fn __LONG_LONG_PAIR(HI: anytype, LO: anytype) @TypeOf(HI) {
    _ = &HI;
    _ = &LO;
    return blk: {
        _ = &LO;
        break :blk HI;
    };
}
pub const LITTLE_ENDIAN = __LITTLE_ENDIAN;
pub const BIG_ENDIAN = __BIG_ENDIAN;
pub const PDP_ENDIAN = __PDP_ENDIAN;
pub const BYTE_ORDER = __BYTE_ORDER;
pub const _BITS_BYTESWAP_H = @as(c_int, 1);
pub inline fn __bswap_constant_16(x: anytype) __uint16_t {
    _ = &x;
    return __helpers.cast(__uint16_t, ((x >> @as(c_int, 8)) & @as(c_int, 0xff)) | ((x & @as(c_int, 0xff)) << @as(c_int, 8)));
}
pub inline fn __bswap_constant_32(x: anytype) @TypeOf(((((x & __helpers.promoteIntLiteral(c_uint, 0xff000000, .hex)) >> @as(c_int, 24)) | ((x & __helpers.promoteIntLiteral(c_uint, 0x00ff0000, .hex)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24))) {
    _ = &x;
    return ((((x & __helpers.promoteIntLiteral(c_uint, 0xff000000, .hex)) >> @as(c_int, 24)) | ((x & __helpers.promoteIntLiteral(c_uint, 0x00ff0000, .hex)) >> @as(c_int, 8))) | ((x & @as(c_uint, 0x0000ff00)) << @as(c_int, 8))) | ((x & @as(c_uint, 0x000000ff)) << @as(c_int, 24));
}
pub inline fn __bswap_constant_64(x: anytype) @TypeOf(((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56))) {
    _ = &x;
    return ((((((((x & @as(c_ulonglong, 0xff00000000000000)) >> @as(c_int, 56)) | ((x & @as(c_ulonglong, 0x00ff000000000000)) >> @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x0000ff0000000000)) >> @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000ff00000000)) >> @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x00000000ff000000)) << @as(c_int, 8))) | ((x & @as(c_ulonglong, 0x0000000000ff0000)) << @as(c_int, 24))) | ((x & @as(c_ulonglong, 0x000000000000ff00)) << @as(c_int, 40))) | ((x & @as(c_ulonglong, 0x00000000000000ff)) << @as(c_int, 56));
}
pub const _BITS_UINTN_IDENTITY_H = @as(c_int, 1);
pub inline fn htobe16(x: anytype) @TypeOf(__bswap_16(x)) {
    _ = &x;
    return __bswap_16(x);
}
pub inline fn htole16(x: anytype) @TypeOf(__uint16_identity(x)) {
    _ = &x;
    return __uint16_identity(x);
}
pub inline fn be16toh(x: anytype) @TypeOf(__bswap_16(x)) {
    _ = &x;
    return __bswap_16(x);
}
pub inline fn le16toh(x: anytype) @TypeOf(__uint16_identity(x)) {
    _ = &x;
    return __uint16_identity(x);
}
pub inline fn htobe32(x: anytype) @TypeOf(__bswap_32(x)) {
    _ = &x;
    return __bswap_32(x);
}
pub inline fn htole32(x: anytype) @TypeOf(__uint32_identity(x)) {
    _ = &x;
    return __uint32_identity(x);
}
pub inline fn be32toh(x: anytype) @TypeOf(__bswap_32(x)) {
    _ = &x;
    return __bswap_32(x);
}
pub inline fn le32toh(x: anytype) @TypeOf(__uint32_identity(x)) {
    _ = &x;
    return __uint32_identity(x);
}
pub inline fn htobe64(x: anytype) @TypeOf(__bswap_64(x)) {
    _ = &x;
    return __bswap_64(x);
}
pub inline fn htole64(x: anytype) @TypeOf(__uint64_identity(x)) {
    _ = &x;
    return __uint64_identity(x);
}
pub inline fn be64toh(x: anytype) @TypeOf(__bswap_64(x)) {
    _ = &x;
    return __bswap_64(x);
}
pub inline fn le64toh(x: anytype) @TypeOf(__uint64_identity(x)) {
    _ = &x;
    return __uint64_identity(x);
}
pub const _SYS_SELECT_H = @as(c_int, 1);
pub const __FD_ZERO = @compileError("unable to translate macro: undefined identifier `__i`"); // /usr/include/x86_64-linux-gnu/bits/select.h:25:9
pub const __FD_SET = @compileError("unable to translate C expr: expected ')' instead got '|='"); // /usr/include/x86_64-linux-gnu/bits/select.h:32:9
pub const __FD_CLR = @compileError("unable to translate C expr: expected ')' instead got '&='"); // /usr/include/x86_64-linux-gnu/bits/select.h:34:9
pub inline fn __FD_ISSET(d: anytype, s: anytype) @TypeOf((__FDS_BITS(s)[@as(usize, @intCast(__FD_ELT(d)))] & __FD_MASK(d)) != @as(c_int, 0)) {
    _ = &d;
    _ = &s;
    return (__FDS_BITS(s)[@as(usize, @intCast(__FD_ELT(d)))] & __FD_MASK(d)) != @as(c_int, 0);
}
pub const __sigset_t_defined = @as(c_int, 1);
pub const ____sigset_t_defined = "";
pub const _SIGSET_NWORDS = __helpers.div(@as(c_int, 1024), @as(c_int, 8) * __helpers.sizeof(c_ulong));
pub const __timeval_defined = @as(c_int, 1);
pub const _STRUCT_TIMESPEC = @as(c_int, 1);
pub const __suseconds_t_defined = "";
pub const __NFDBITS = @as(c_int, 8) * __helpers.cast(c_int, __helpers.sizeof(__fd_mask));
pub inline fn __FD_ELT(d: anytype) @TypeOf(__helpers.div(d, __NFDBITS)) {
    _ = &d;
    return __helpers.div(d, __NFDBITS);
}
pub inline fn __FD_MASK(d: anytype) __fd_mask {
    _ = &d;
    return __helpers.cast(__fd_mask, @as(c_ulong, 1) << __helpers.rem(d, __NFDBITS));
}
pub inline fn __FDS_BITS(set: anytype) @TypeOf(set.*.__fds_bits) {
    _ = &set;
    return set.*.__fds_bits;
}
pub const FD_SETSIZE = __FD_SETSIZE;
pub const NFDBITS = __NFDBITS;
pub inline fn FD_SET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_SET(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_SET(fd, fdsetp);
}
pub inline fn FD_CLR(fd: anytype, fdsetp: anytype) @TypeOf(__FD_CLR(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_CLR(fd, fdsetp);
}
pub inline fn FD_ISSET(fd: anytype, fdsetp: anytype) @TypeOf(__FD_ISSET(fd, fdsetp)) {
    _ = &fd;
    _ = &fdsetp;
    return __FD_ISSET(fd, fdsetp);
}
pub inline fn FD_ZERO(fdsetp: anytype) @TypeOf(__FD_ZERO(fdsetp)) {
    _ = &fdsetp;
    return __FD_ZERO(fdsetp);
}
pub const __blksize_t_defined = "";
pub const __blkcnt_t_defined = "";
pub const __fsblkcnt_t_defined = "";
pub const __fsfilcnt_t_defined = "";
pub const _BITS_PTHREADTYPES_COMMON_H = @as(c_int, 1);
pub const _THREAD_SHARED_TYPES_H = @as(c_int, 1);
pub const _BITS_PTHREADTYPES_ARCH_H = @as(c_int, 1);
pub const __SIZEOF_PTHREAD_MUTEX_T = @as(c_int, 40);
pub const __SIZEOF_PTHREAD_ATTR_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_RWLOCK_T = @as(c_int, 56);
pub const __SIZEOF_PTHREAD_BARRIER_T = @as(c_int, 32);
pub const __SIZEOF_PTHREAD_MUTEXATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_COND_T = @as(c_int, 48);
pub const __SIZEOF_PTHREAD_CONDATTR_T = @as(c_int, 4);
pub const __SIZEOF_PTHREAD_RWLOCKATTR_T = @as(c_int, 8);
pub const __SIZEOF_PTHREAD_BARRIERATTR_T = @as(c_int, 4);
pub const __LOCK_ALIGNMENT = "";
pub const __ONCE_ALIGNMENT = "";
pub const _BITS_ATOMIC_WIDE_COUNTER_H = "";
pub const _THREAD_MUTEX_INTERNAL_H = @as(c_int, 1);
pub const __PTHREAD_MUTEX_HAVE_PREV = @as(c_int, 1);
pub const __PTHREAD_MUTEX_INITIALIZER = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/struct_mutex.h:56:10
pub const _RWLOCK_INTERNAL_H = "";
pub const __PTHREAD_RWLOCK_ELISION_EXTRA = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/struct_rwlock.h:40:11
pub inline fn __PTHREAD_RWLOCK_INITIALIZER(__flags: anytype) @TypeOf(__flags) {
    _ = &__flags;
    return blk: {
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = @as(c_int, 0);
        _ = &__PTHREAD_RWLOCK_ELISION_EXTRA;
        _ = @as(c_int, 0);
        break :blk __flags;
    };
}
pub const __ONCE_FLAG_INIT = @compileError("unable to translate C expr: unexpected token '{'"); // /usr/include/x86_64-linux-gnu/bits/thread-shared-types.h:114:9
pub const __have_pthread_attr_t = @as(c_int, 1);
pub const _ALLOCA_H = @as(c_int, 1);
pub const __COMPAR_FN_T = "";
pub const NANOARROW_NANOARROW_TYPES_H_INCLUDED = "";
pub const _STRING_H = @as(c_int, 1);
pub const _BITS_TYPES_LOCALE_T_H = @as(c_int, 1);
pub const _BITS_TYPES___LOCALE_T_H = @as(c_int, 1);
pub const _STRINGS_H = @as(c_int, 1);
pub const NANOARROW_CONFIG_H_INCLUDED = "";
pub const NANOARROW_VERSION_MAJOR = @as(c_int, 0);
pub const NANOARROW_VERSION_MINOR = @as(c_int, 9);
pub const NANOARROW_VERSION_PATCH = @as(c_int, 0);
pub const NANOARROW_VERSION = "0.9.0-SNAPSHOT";
pub const NANOARROW_VERSION_INT = ((NANOARROW_VERSION_MAJOR * @as(c_int, 10000)) + (NANOARROW_VERSION_MINOR * @as(c_int, 100))) + NANOARROW_VERSION_PATCH;
pub const NANOARROW_CXX_NAMESPACE = @compileError("unable to translate macro: undefined identifier `nanoarrow`"); // /usr/local/include//nanoarrow/nanoarrow_config.h:33:9
pub const NANOARROW_CXX_NAMESPACE_BEGIN = @compileError("unable to translate macro: undefined identifier `namespace`"); // /usr/local/include//nanoarrow/nanoarrow_config.h:36:9
pub const NANOARROW_CXX_NAMESPACE_END = @compileError("unable to translate C expr: unexpected token '}'"); // /usr/local/include//nanoarrow/nanoarrow_config.h:37:9
pub const _NANOARROW_CONCAT = @compileError("unable to translate C expr: unexpected token '##'"); // /usr/local/include//nanoarrow/common/inline_types.h:136:9
pub inline fn _NANOARROW_MAKE_NAME(x: anytype, y: anytype) @TypeOf(_NANOARROW_CONCAT(x, y)) {
    _ = &x;
    _ = &y;
    return _NANOARROW_CONCAT(x, y);
}
pub const _NANOARROW_RETURN_NOT_OK_IMPL = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/local/include//nanoarrow/common/inline_types.h:139:9
pub const _NANOARROW_UNIQUE_SUFFIX = @compileError("unable to translate macro: undefined identifier `_nanoarrow_unique_suffix`"); // /usr/local/include//nanoarrow/common/inline_types.h:150:9
pub inline fn _NANOARROW_CHECK_RANGE(x_: anytype, min_: anytype, max_: anytype) @TypeOf(NANOARROW_RETURN_NOT_OK(if (__helpers.cast(bool, (x_ >= min_) and (x_ <= max_))) NANOARROW_OK else EINVAL)) {
    _ = &x_;
    _ = &min_;
    _ = &max_;
    return NANOARROW_RETURN_NOT_OK(if (__helpers.cast(bool, (x_ >= min_) and (x_ <= max_))) NANOARROW_OK else EINVAL);
}
pub inline fn _NANOARROW_CHECK_UPPER_LIMIT(x_: anytype, max_: anytype) @TypeOf(NANOARROW_RETURN_NOT_OK(if (__helpers.cast(bool, x_ <= max_)) NANOARROW_OK else EINVAL)) {
    _ = &x_;
    _ = &max_;
    return NANOARROW_RETURN_NOT_OK(if (__helpers.cast(bool, x_ <= max_)) NANOARROW_OK else EINVAL);
}
pub const _NANOARROW_RETURN_NOT_OK_WITH_ERROR_IMPL = @compileError("unable to translate C expr: unexpected token 'do'"); // /usr/local/include//nanoarrow/common/inline_types.h:169:9
pub const NANOARROW_CHECK_RETURN_ATTRIBUTE = "";
pub const NANOARROW_CHECK_PRINTF_ATTRIBUTE = "";
pub const NANOARROW_UNUSED = __helpers.DISCARD;
pub const NANOARROW_OK = @as(c_int, 0);
pub const NANOARROW_FLAG_ALL_SUPPORTED = (ARROW_FLAG_DICTIONARY_ORDERED | ARROW_FLAG_NULLABLE) | ARROW_FLAG_MAP_KEYS_SORTED;
pub const NANOARROW_RETURN_NOT_OK = @compileError("unable to translate macro: undefined identifier `errno_status_`"); // /usr/local/include//nanoarrow/common/inline_types.h:275:9
pub const NANOARROW_RETURN_NOT_OK_WITH_ERROR = @compileError("unable to translate macro: undefined identifier `errno_status_`"); // /usr/local/include//nanoarrow/common/inline_types.h:286:9
pub const NANOARROW_ASSERT_OK = __helpers.DISCARD;
pub inline fn NANOARROW_DCHECK(EXPR: anytype) void {
    _ = &EXPR;
    return;
}
pub const NANOARROW_MAX_FIXED_BUFFERS = @as(c_int, 3);
pub const NANOARROW_DLL = @compileError("unable to translate macro: undefined identifier `visibility`"); // /usr/local/include//nanoarrow/nanoarrow.h:152:9
pub const NANOARROW_ARRAY_INLINE_H_INCLUDED = "";
pub const _ERRNO_H = @as(c_int, 1);
pub const _BITS_ERRNO_H = @as(c_int, 1);
pub const _ASM_GENERIC_ERRNO_H = "";
pub const _ASM_GENERIC_ERRNO_BASE_H = "";
pub const EPERM = @as(c_int, 1);
pub const ENOENT = @as(c_int, 2);
pub const ESRCH = @as(c_int, 3);
pub const EINTR = @as(c_int, 4);
pub const EIO = @as(c_int, 5);
pub const ENXIO = @as(c_int, 6);
pub const E2BIG = @as(c_int, 7);
pub const ENOEXEC = @as(c_int, 8);
pub const EBADF = @as(c_int, 9);
pub const ECHILD = @as(c_int, 10);
pub const EAGAIN = @as(c_int, 11);
pub const ENOMEM = @as(c_int, 12);
pub const EACCES = @as(c_int, 13);
pub const EFAULT = @as(c_int, 14);
pub const ENOTBLK = @as(c_int, 15);
pub const EBUSY = @as(c_int, 16);
pub const EEXIST = @as(c_int, 17);
pub const EXDEV = @as(c_int, 18);
pub const ENODEV = @as(c_int, 19);
pub const ENOTDIR = @as(c_int, 20);
pub const EISDIR = @as(c_int, 21);
pub const EINVAL = @as(c_int, 22);
pub const ENFILE = @as(c_int, 23);
pub const EMFILE = @as(c_int, 24);
pub const ENOTTY = @as(c_int, 25);
pub const ETXTBSY = @as(c_int, 26);
pub const EFBIG = @as(c_int, 27);
pub const ENOSPC = @as(c_int, 28);
pub const ESPIPE = @as(c_int, 29);
pub const EROFS = @as(c_int, 30);
pub const EMLINK = @as(c_int, 31);
pub const EPIPE = @as(c_int, 32);
pub const EDOM = @as(c_int, 33);
pub const ERANGE = @as(c_int, 34);
pub const EDEADLK = @as(c_int, 35);
pub const ENAMETOOLONG = @as(c_int, 36);
pub const ENOLCK = @as(c_int, 37);
pub const ENOSYS = @as(c_int, 38);
pub const ENOTEMPTY = @as(c_int, 39);
pub const ELOOP = @as(c_int, 40);
pub const EWOULDBLOCK = EAGAIN;
pub const ENOMSG = @as(c_int, 42);
pub const EIDRM = @as(c_int, 43);
pub const ECHRNG = @as(c_int, 44);
pub const EL2NSYNC = @as(c_int, 45);
pub const EL3HLT = @as(c_int, 46);
pub const EL3RST = @as(c_int, 47);
pub const ELNRNG = @as(c_int, 48);
pub const EUNATCH = @as(c_int, 49);
pub const ENOCSI = @as(c_int, 50);
pub const EL2HLT = @as(c_int, 51);
pub const EBADE = @as(c_int, 52);
pub const EBADR = @as(c_int, 53);
pub const EXFULL = @as(c_int, 54);
pub const ENOANO = @as(c_int, 55);
pub const EBADRQC = @as(c_int, 56);
pub const EBADSLT = @as(c_int, 57);
pub const EDEADLOCK = EDEADLK;
pub const EBFONT = @as(c_int, 59);
pub const ENOSTR = @as(c_int, 60);
pub const ENODATA = @as(c_int, 61);
pub const ETIME = @as(c_int, 62);
pub const ENOSR = @as(c_int, 63);
pub const ENONET = @as(c_int, 64);
pub const ENOPKG = @as(c_int, 65);
pub const EREMOTE = @as(c_int, 66);
pub const ENOLINK = @as(c_int, 67);
pub const EADV = @as(c_int, 68);
pub const ESRMNT = @as(c_int, 69);
pub const ECOMM = @as(c_int, 70);
pub const EPROTO = @as(c_int, 71);
pub const EMULTIHOP = @as(c_int, 72);
pub const EDOTDOT = @as(c_int, 73);
pub const EBADMSG = @as(c_int, 74);
pub const EOVERFLOW = @as(c_int, 75);
pub const ENOTUNIQ = @as(c_int, 76);
pub const EBADFD = @as(c_int, 77);
pub const EREMCHG = @as(c_int, 78);
pub const ELIBACC = @as(c_int, 79);
pub const ELIBBAD = @as(c_int, 80);
pub const ELIBSCN = @as(c_int, 81);
pub const ELIBMAX = @as(c_int, 82);
pub const ELIBEXEC = @as(c_int, 83);
pub const EILSEQ = @as(c_int, 84);
pub const ERESTART = @as(c_int, 85);
pub const ESTRPIPE = @as(c_int, 86);
pub const EUSERS = @as(c_int, 87);
pub const ENOTSOCK = @as(c_int, 88);
pub const EDESTADDRREQ = @as(c_int, 89);
pub const EMSGSIZE = @as(c_int, 90);
pub const EPROTOTYPE = @as(c_int, 91);
pub const ENOPROTOOPT = @as(c_int, 92);
pub const EPROTONOSUPPORT = @as(c_int, 93);
pub const ESOCKTNOSUPPORT = @as(c_int, 94);
pub const EOPNOTSUPP = @as(c_int, 95);
pub const EPFNOSUPPORT = @as(c_int, 96);
pub const EAFNOSUPPORT = @as(c_int, 97);
pub const EADDRINUSE = @as(c_int, 98);
pub const EADDRNOTAVAIL = @as(c_int, 99);
pub const ENETDOWN = @as(c_int, 100);
pub const ENETUNREACH = @as(c_int, 101);
pub const ENETRESET = @as(c_int, 102);
pub const ECONNABORTED = @as(c_int, 103);
pub const ECONNRESET = @as(c_int, 104);
pub const ENOBUFS = @as(c_int, 105);
pub const EISCONN = @as(c_int, 106);
pub const ENOTCONN = @as(c_int, 107);
pub const ESHUTDOWN = @as(c_int, 108);
pub const ETOOMANYREFS = @as(c_int, 109);
pub const ETIMEDOUT = @as(c_int, 110);
pub const ECONNREFUSED = @as(c_int, 111);
pub const EHOSTDOWN = @as(c_int, 112);
pub const EHOSTUNREACH = @as(c_int, 113);
pub const EALREADY = @as(c_int, 114);
pub const EINPROGRESS = @as(c_int, 115);
pub const ESTALE = @as(c_int, 116);
pub const EUCLEAN = @as(c_int, 117);
pub const ENOTNAM = @as(c_int, 118);
pub const ENAVAIL = @as(c_int, 119);
pub const EISNAM = @as(c_int, 120);
pub const EREMOTEIO = @as(c_int, 121);
pub const EDQUOT = @as(c_int, 122);
pub const ENOMEDIUM = @as(c_int, 123);
pub const EMEDIUMTYPE = @as(c_int, 124);
pub const ECANCELED = @as(c_int, 125);
pub const ENOKEY = @as(c_int, 126);
pub const EKEYEXPIRED = @as(c_int, 127);
pub const EKEYREVOKED = @as(c_int, 128);
pub const EKEYREJECTED = @as(c_int, 129);
pub const EOWNERDEAD = @as(c_int, 130);
pub const ENOTRECOVERABLE = @as(c_int, 131);
pub const ERFKILL = @as(c_int, 132);
pub const EHWPOISON = @as(c_int, 133);
pub const ENOTSUP = EOPNOTSUPP;
pub const errno = __errno_location().*;
pub const FLT_RADIX = __FLT_RADIX__;
pub const FLT_MANT_DIG = __FLT_MANT_DIG__;
pub const DBL_MANT_DIG = __DBL_MANT_DIG__;
pub const LDBL_MANT_DIG = __LDBL_MANT_DIG__;
pub const FLT_EVAL_METHOD = __FLT_EVAL_METHOD__;
pub const DECIMAL_DIG = __DECIMAL_DIG__;
pub const FLT_DIG = __FLT_DIG__;
pub const DBL_DIG = __DBL_DIG__;
pub const LDBL_DIG = __LDBL_DIG__;
pub const FLT_MIN_EXP = __FLT_MIN_EXP__;
pub const DBL_MIN_EXP = __DBL_MIN_EXP__;
pub const LDBL_MIN_EXP = __LDBL_MIN_EXP__;
pub const FLT_MIN_10_EXP = __FLT_MIN_10_EXP__;
pub const DBL_MIN_10_EXP = __DBL_MIN_10_EXP__;
pub const LDBL_MIN_10_EXP = __LDBL_MIN_10_EXP__;
pub const FLT_MAX_EXP = __FLT_MAX_EXP__;
pub const DBL_MAX_EXP = __DBL_MAX_EXP__;
pub const LDBL_MAX_EXP = __LDBL_MAX_EXP__;
pub const FLT_MAX_10_EXP = __FLT_MAX_10_EXP__;
pub const DBL_MAX_10_EXP = __DBL_MAX_10_EXP__;
pub const LDBL_MAX_10_EXP = __LDBL_MAX_10_EXP__;
pub const FLT_MAX = __FLT_MAX__;
pub const DBL_MAX = __DBL_MAX__;
pub const LDBL_MAX = __LDBL_MAX__;
pub const FLT_EPSILON = __FLT_EPSILON__;
pub const DBL_EPSILON = __DBL_EPSILON__;
pub const LDBL_EPSILON = __LDBL_EPSILON__;
pub const FLT_MIN = __FLT_MIN__;
pub const DBL_MIN = __DBL_MIN__;
pub const LDBL_MIN = __LDBL_MIN__;
pub const FLT_TRUE_MIN = __FLT_DENORM_MIN__;
pub const DBL_TRUE_MIN = __DBL_DENORM_MIN__;
pub const LDBL_TRUE_MIN = __LDBL_DENORM_MIN__;
pub const FLT_DECIMAL_DIG = __FLT_DECIMAL_DIG__;
pub const DBL_DECIMAL_DIG = __DBL_DECIMAL_DIG__;
pub const LDBL_DECIMAL_DIG = __LDBL_DECIMAL_DIG__;
pub const FLT_HAS_SUBNORM = "";
pub const DBL_HAS_SUBNORM = "";
pub const LDBL_HAS_SUBNORM = "";
pub const _GCC_LIMITS_H_ = "";
pub const __CLANG_LIMITS_H = "";
pub const _LIBC_LIMITS_H_ = @as(c_int, 1);
pub const MB_LEN_MAX = @as(c_int, 16);
pub const _BITS_POSIX1_LIM_H = @as(c_int, 1);
pub const _POSIX_AIO_LISTIO_MAX = @as(c_int, 2);
pub const _POSIX_AIO_MAX = @as(c_int, 1);
pub const _POSIX_ARG_MAX = @as(c_int, 4096);
pub const _POSIX_CHILD_MAX = @as(c_int, 25);
pub const _POSIX_DELAYTIMER_MAX = @as(c_int, 32);
pub const _POSIX_HOST_NAME_MAX = @as(c_int, 255);
pub const _POSIX_LINK_MAX = @as(c_int, 8);
pub const _POSIX_LOGIN_NAME_MAX = @as(c_int, 9);
pub const _POSIX_MAX_CANON = @as(c_int, 255);
pub const _POSIX_MAX_INPUT = @as(c_int, 255);
pub const _POSIX_MQ_OPEN_MAX = @as(c_int, 8);
pub const _POSIX_MQ_PRIO_MAX = @as(c_int, 32);
pub const _POSIX_NAME_MAX = @as(c_int, 14);
pub const _POSIX_NGROUPS_MAX = @as(c_int, 8);
pub const _POSIX_OPEN_MAX = @as(c_int, 20);
pub const _POSIX_PATH_MAX = @as(c_int, 256);
pub const _POSIX_PIPE_BUF = @as(c_int, 512);
pub const _POSIX_RE_DUP_MAX = @as(c_int, 255);
pub const _POSIX_RTSIG_MAX = @as(c_int, 8);
pub const _POSIX_SEM_NSEMS_MAX = @as(c_int, 256);
pub const _POSIX_SEM_VALUE_MAX = @as(c_int, 32767);
pub const _POSIX_SIGQUEUE_MAX = @as(c_int, 32);
pub const _POSIX_SSIZE_MAX = @as(c_int, 32767);
pub const _POSIX_STREAM_MAX = @as(c_int, 8);
pub const _POSIX_SYMLINK_MAX = @as(c_int, 255);
pub const _POSIX_SYMLOOP_MAX = @as(c_int, 8);
pub const _POSIX_TIMER_MAX = @as(c_int, 32);
pub const _POSIX_TTY_NAME_MAX = @as(c_int, 9);
pub const _POSIX_TZNAME_MAX = @as(c_int, 6);
pub const _POSIX_CLOCKRES_MIN = __helpers.promoteIntLiteral(c_int, 20000000, .decimal);
pub const _LINUX_LIMITS_H = "";
pub const NGROUPS_MAX = __helpers.promoteIntLiteral(c_int, 65536, .decimal);
pub const MAX_CANON = @as(c_int, 255);
pub const MAX_INPUT = @as(c_int, 255);
pub const NAME_MAX = @as(c_int, 255);
pub const PATH_MAX = @as(c_int, 4096);
pub const PIPE_BUF = @as(c_int, 4096);
pub const XATTR_NAME_MAX = @as(c_int, 255);
pub const XATTR_SIZE_MAX = __helpers.promoteIntLiteral(c_int, 65536, .decimal);
pub const XATTR_LIST_MAX = __helpers.promoteIntLiteral(c_int, 65536, .decimal);
pub const RTSIG_MAX = @as(c_int, 32);
pub const _POSIX_THREAD_KEYS_MAX = @as(c_int, 128);
pub const PTHREAD_KEYS_MAX = @as(c_int, 1024);
pub const _POSIX_THREAD_DESTRUCTOR_ITERATIONS = @as(c_int, 4);
pub const PTHREAD_DESTRUCTOR_ITERATIONS = _POSIX_THREAD_DESTRUCTOR_ITERATIONS;
pub const _POSIX_THREAD_THREADS_MAX = @as(c_int, 64);
pub const AIO_PRIO_DELTA_MAX = @as(c_int, 20);
pub const PTHREAD_STACK_MIN = @as(c_int, 16384);
pub const DELAYTIMER_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const TTY_NAME_MAX = @as(c_int, 32);
pub const LOGIN_NAME_MAX = @as(c_int, 256);
pub const HOST_NAME_MAX = @as(c_int, 64);
pub const MQ_PRIO_MAX = __helpers.promoteIntLiteral(c_int, 32768, .decimal);
pub const SEM_VALUE_MAX = __helpers.promoteIntLiteral(c_int, 2147483647, .decimal);
pub const SSIZE_MAX = LONG_MAX;
pub const _BITS_POSIX2_LIM_H = @as(c_int, 1);
pub const _POSIX2_BC_BASE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_DIM_MAX = @as(c_int, 2048);
pub const _POSIX2_BC_SCALE_MAX = @as(c_int, 99);
pub const _POSIX2_BC_STRING_MAX = @as(c_int, 1000);
pub const _POSIX2_COLL_WEIGHTS_MAX = @as(c_int, 2);
pub const _POSIX2_EXPR_NEST_MAX = @as(c_int, 32);
pub const _POSIX2_LINE_MAX = @as(c_int, 2048);
pub const _POSIX2_RE_DUP_MAX = @as(c_int, 255);
pub const _POSIX2_CHARCLASS_NAME_MAX = @as(c_int, 14);
pub const BC_BASE_MAX = _POSIX2_BC_BASE_MAX;
pub const BC_DIM_MAX = _POSIX2_BC_DIM_MAX;
pub const BC_SCALE_MAX = _POSIX2_BC_SCALE_MAX;
pub const BC_STRING_MAX = _POSIX2_BC_STRING_MAX;
pub const COLL_WEIGHTS_MAX = @as(c_int, 255);
pub const EXPR_NEST_MAX = _POSIX2_EXPR_NEST_MAX;
pub const LINE_MAX = _POSIX2_LINE_MAX;
pub const CHARCLASS_NAME_MAX = @as(c_int, 2048);
pub const RE_DUP_MAX = @as(c_int, 0x7fff);
pub const SCHAR_MAX = __SCHAR_MAX__;
pub const SHRT_MAX = __SHRT_MAX__;
pub const INT_MAX = __INT_MAX__;
pub const LONG_MAX = __LONG_MAX__;
pub const SCHAR_MIN = -__SCHAR_MAX__ - @as(c_int, 1);
pub const SHRT_MIN = -__SHRT_MAX__ - @as(c_int, 1);
pub const INT_MIN = -__INT_MAX__ - @as(c_int, 1);
pub const LONG_MIN = -__LONG_MAX__ - @as(c_long, 1);
pub const UCHAR_MAX = (__SCHAR_MAX__ * @as(c_int, 2)) + @as(c_int, 1);
pub const USHRT_MAX = (__SHRT_MAX__ * @as(c_int, 2)) + @as(c_int, 1);
pub const UINT_MAX = (__INT_MAX__ * @as(c_uint, 2)) + @as(c_uint, 1);
pub const ULONG_MAX = (__LONG_MAX__ * @as(c_ulong, 2)) + @as(c_ulong, 1);
pub const CHAR_BIT = __CHAR_BIT__;
pub const CHAR_MIN = SCHAR_MIN;
pub const CHAR_MAX = __SCHAR_MAX__;
pub const LLONG_MIN = -__LONG_LONG_MAX__ - @as(c_longlong, 1);
pub const LLONG_MAX = __LONG_LONG_MAX__;
pub const ULLONG_MAX = (__LONG_LONG_MAX__ * @as(c_ulonglong, 2)) + @as(c_ulonglong, 1);
pub const NANOARROW_BUFFER_INLINE_H_INCLUDED = "";
pub const NANOARROW_BINARY_VIEW_FIXED_BUFFERS = @as(c_int, 2);
pub const NANOARROW_BINARY_VIEW_INLINE_SIZE = @as(c_int, 12);
pub const NANOARROW_BINARY_VIEW_PREFIX_SIZE = @as(c_int, 4);
pub const NANOARROW_BINARY_VIEW_BLOCK_SIZE = @as(c_int, 32) << @as(c_int, 10);
pub const _READLINE_H_ = "";
pub const _STDIO_H = @as(c_int, 1);
pub const __GLIBC_USE_LIB_EXT2 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_BFP_EXT_C23 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_FUNCS_EXT_C23 = @as(c_int, 0);
pub const __GLIBC_USE_IEC_60559_TYPES_EXT = @as(c_int, 0);
pub const __need___va_list = "";
pub const __STDC_VERSION_STDARG_H__ = @as(c_int, 0);
pub const va_start = @compileError("unable to translate macro: undefined identifier `__builtin_va_start`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stdarg.h:12:9
pub const va_end = @compileError("unable to translate macro: undefined identifier `__builtin_va_end`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stdarg.h:14:9
pub const va_arg = @compileError("unable to translate macro: undefined identifier `__builtin_va_arg`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stdarg.h:15:9
pub const __va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stdarg.h:18:9
pub const va_copy = @compileError("unable to translate macro: undefined identifier `__builtin_va_copy`"); // /home/harry/bin/.zig-x86_64-linux-0.16.0/lib/compiler/aro/include/stdarg.h:22:9
pub const __GNUC_VA_LIST = @as(c_int, 1);
pub const _____fpos_t_defined = @as(c_int, 1);
pub const ____mbstate_t_defined = @as(c_int, 1);
pub const _____fpos64_t_defined = @as(c_int, 1);
pub const ____FILE_defined = @as(c_int, 1);
pub const __FILE_defined = @as(c_int, 1);
pub const __struct_FILE_defined = @as(c_int, 1);
pub const __getc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h:105:9
pub const __putc_unlocked_body = @compileError("TODO postfix inc/dec expr"); // /usr/include/x86_64-linux-gnu/bits/types/struct_FILE.h:109:9
pub const _IO_EOF_SEEN = @as(c_int, 0x0010);
pub inline fn __feof_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_EOF_SEEN) != @as(c_int, 0);
}
pub const _IO_ERR_SEEN = @as(c_int, 0x0020);
pub inline fn __ferror_unlocked_body(_fp: anytype) @TypeOf((_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0)) {
    _ = &_fp;
    return (_fp.*._flags & _IO_ERR_SEEN) != @as(c_int, 0);
}
pub const _IO_USER_LOCK = __helpers.promoteIntLiteral(c_int, 0x8000, .hex);
pub const __cookie_io_functions_t_defined = @as(c_int, 1);
pub const _VA_LIST_DEFINED = "";
pub const _IOFBF = @as(c_int, 0);
pub const _IOLBF = @as(c_int, 1);
pub const _IONBF = @as(c_int, 2);
pub const BUFSIZ = @as(c_int, 8192);
pub const EOF = -@as(c_int, 1);
pub const SEEK_SET = @as(c_int, 0);
pub const SEEK_CUR = @as(c_int, 1);
pub const SEEK_END = @as(c_int, 2);
pub const P_tmpdir = "/tmp";
pub const L_tmpnam = @as(c_int, 20);
pub const TMP_MAX = __helpers.promoteIntLiteral(c_int, 238328, .decimal);
pub const _BITS_STDIO_LIM_H = @as(c_int, 1);
pub const FILENAME_MAX = @as(c_int, 4096);
pub const L_ctermid = @as(c_int, 9);
pub const FOPEN_MAX = @as(c_int, 16);
pub const __attr_dealloc_fclose = __attr_dealloc(fclose, @as(c_int, 1));
pub const _RL_STDC_H_ = "";
pub inline fn PARAMS(protos: anytype) @TypeOf(protos) {
    _ = &protos;
    return protos;
}
pub const __rl_attribute__ = @compileError("unable to translate C expr: unexpected token '__attribute__'"); // /usr/include/readline/rlstdc.h:40:11
pub const _RL_TYPEDEFS_H_ = "";
pub const _FUNCTION_DEF = "";
pub const _RL_FUNCTION_TYPEDEF = "";
pub const rl_ivoidfunc_t = rl_hook_func_t;
pub const _KEYMAPS_H_ = "";
pub const _CHARDEFS_H_ = "";
pub const _CTYPE_H = @as(c_int, 1);
pub inline fn _ISbit(bit: anytype) @TypeOf(if (__helpers.cast(bool, bit < @as(c_int, 8))) (@as(c_int, 1) << bit) << @as(c_int, 8) else (@as(c_int, 1) << bit) >> @as(c_int, 8)) {
    _ = &bit;
    return if (__helpers.cast(bool, bit < @as(c_int, 8))) (@as(c_int, 1) << bit) << @as(c_int, 8) else (@as(c_int, 1) << bit) >> @as(c_int, 8);
}
pub inline fn __isctype(c: anytype, @"type": anytype) @TypeOf(__ctype_b_loc().*[@as(usize, @intCast(__helpers.cast(c_int, c)))] & __helpers.cast(c_ushort, @"type")) {
    _ = &c;
    _ = &@"type";
    return __ctype_b_loc().*[@as(usize, @intCast(__helpers.cast(c_int, c)))] & __helpers.cast(c_ushort, @"type");
}
pub inline fn __isascii(c: anytype) @TypeOf((c & ~@as(c_int, 0x7f)) == @as(c_int, 0)) {
    _ = &c;
    return (c & ~@as(c_int, 0x7f)) == @as(c_int, 0);
}
pub inline fn __toascii(c: anytype) @TypeOf(c & @as(c_int, 0x7f)) {
    _ = &c;
    return c & @as(c_int, 0x7f);
}
pub const __exctype = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/ctype.h:102:9
pub const __tobody = @compileError("unable to translate macro: undefined identifier `__res`"); // /usr/include/ctype.h:155:9
pub inline fn __isctype_l(c: anytype, @"type": anytype, locale: anytype) @TypeOf(locale.*.__ctype_b[@as(usize, @intCast(__helpers.cast(c_int, c)))] & __helpers.cast(c_ushort, @"type")) {
    _ = &c;
    _ = &@"type";
    _ = &locale;
    return locale.*.__ctype_b[@as(usize, @intCast(__helpers.cast(c_int, c)))] & __helpers.cast(c_ushort, @"type");
}
pub const __exctype_l = @compileError("unable to translate C expr: unexpected token 'extern'"); // /usr/include/ctype.h:244:10
pub inline fn __isalnum_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISalnum, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISalnum, l);
}
pub inline fn __isalpha_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISalpha, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISalpha, l);
}
pub inline fn __iscntrl_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _IScntrl, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _IScntrl, l);
}
pub inline fn __isdigit_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISdigit, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISdigit, l);
}
pub inline fn __islower_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISlower, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISlower, l);
}
pub inline fn __isgraph_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISgraph, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISgraph, l);
}
pub inline fn __isprint_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISprint, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISprint, l);
}
pub inline fn __ispunct_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISpunct, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISpunct, l);
}
pub inline fn __isspace_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISspace, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISspace, l);
}
pub inline fn __isupper_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISupper, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISupper, l);
}
pub inline fn __isxdigit_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISxdigit, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISxdigit, l);
}
pub inline fn __isblank_l(c: anytype, l: anytype) @TypeOf(__isctype_l(c, _ISblank, l)) {
    _ = &c;
    _ = &l;
    return __isctype_l(c, _ISblank, l);
}
pub inline fn __isascii_l(c: anytype, l: anytype) @TypeOf(__isascii(c)) {
    _ = &c;
    _ = &l;
    return blk_1: {
        _ = &l;
        break :blk_1 __isascii(c);
    };
}
pub inline fn __toascii_l(c: anytype, l: anytype) @TypeOf(__toascii(c)) {
    _ = &c;
    _ = &l;
    return blk_1: {
        _ = &l;
        break :blk_1 __toascii(c);
    };
}
pub inline fn isascii_l(c: anytype, l: anytype) @TypeOf(__isascii_l(c, l)) {
    _ = &c;
    _ = &l;
    return __isascii_l(c, l);
}
pub inline fn toascii_l(c: anytype, l: anytype) @TypeOf(__toascii_l(c, l)) {
    _ = &c;
    _ = &l;
    return __toascii_l(c, l);
}
pub inline fn whitespace(c: anytype) @TypeOf((c == ' ') or (c == '\t')) {
    _ = &c;
    return (c == ' ') or (c == '\t');
}
pub const control_character_threshold = @as(c_int, 0x020);
pub const control_character_mask = @as(c_int, 0x1f);
pub const meta_character_threshold = @as(c_int, 0x07f);
pub const control_character_bit = @as(c_int, 0x40);
pub const meta_character_bit = @as(c_int, 0x080);
pub const largest_char = @as(c_int, 255);
pub inline fn CTRL_CHAR(c: anytype) @TypeOf((c < control_character_threshold) and ((c & @as(c_int, 0x80)) == @as(c_int, 0))) {
    _ = &c;
    return (c < control_character_threshold) and ((c & @as(c_int, 0x80)) == @as(c_int, 0));
}
pub inline fn META_CHAR(c: anytype) @TypeOf((c > meta_character_threshold) and (c <= largest_char)) {
    _ = &c;
    return (c > meta_character_threshold) and (c <= largest_char);
}
pub inline fn CTRL(c: anytype) @TypeOf(c & control_character_mask) {
    _ = &c;
    return c & control_character_mask;
}
pub inline fn META(c: anytype) @TypeOf(c | meta_character_bit) {
    _ = &c;
    return c | meta_character_bit;
}
pub inline fn UNMETA(c: anytype) @TypeOf(c & ~meta_character_bit) {
    _ = &c;
    return c & ~meta_character_bit;
}
pub inline fn UNCTRL(c: anytype) @TypeOf(_rl_to_upper(c | control_character_bit)) {
    _ = &c;
    return _rl_to_upper(c | control_character_bit);
}
pub inline fn IN_CTYPE_DOMAIN(c: anytype) @TypeOf((c >= @as(c_int, 0)) and (c <= CHAR_MAX)) {
    _ = &c;
    return (c >= @as(c_int, 0)) and (c <= CHAR_MAX);
}
pub inline fn NON_NEGATIVE(c: anytype) @TypeOf(__helpers.cast(u8, c) == c) {
    _ = &c;
    return __helpers.cast(u8, c) == c;
}
pub inline fn ISALNUM(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isalnum(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isalnum(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISALPHA(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isalpha(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isalpha(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISDIGIT(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isdigit(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isdigit(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISLOWER(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (islower(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (islower(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISPRINT(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isprint(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isprint(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISUPPER(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isupper(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isupper(__helpers.cast(u8, c)) != 0);
}
pub inline fn ISXDIGIT(c: anytype) @TypeOf((IN_CTYPE_DOMAIN(c) != 0) and (isxdigit(__helpers.cast(u8, c)) != 0)) {
    _ = &c;
    return (IN_CTYPE_DOMAIN(c) != 0) and (isxdigit(__helpers.cast(u8, c)) != 0);
}
pub inline fn _rl_lowercase_p(c: anytype) @TypeOf((NON_NEGATIVE(c) != 0) and (ISLOWER(c) != 0)) {
    _ = &c;
    return (NON_NEGATIVE(c) != 0) and (ISLOWER(c) != 0);
}
pub inline fn _rl_uppercase_p(c: anytype) @TypeOf((NON_NEGATIVE(c) != 0) and (ISUPPER(c) != 0)) {
    _ = &c;
    return (NON_NEGATIVE(c) != 0) and (ISUPPER(c) != 0);
}
pub inline fn _rl_digit_p(c: anytype) @TypeOf((c >= '0') and (c <= '9')) {
    _ = &c;
    return (c >= '0') and (c <= '9');
}
pub inline fn _rl_alphabetic_p(c: anytype) @TypeOf((NON_NEGATIVE(c) != 0) and (ISALNUM(c) != 0)) {
    _ = &c;
    return (NON_NEGATIVE(c) != 0) and (ISALNUM(c) != 0);
}
pub inline fn _rl_pure_alphabetic(c: anytype) @TypeOf((NON_NEGATIVE(c) != 0) and (ISALPHA(c) != 0)) {
    _ = &c;
    return (NON_NEGATIVE(c) != 0) and (ISALPHA(c) != 0);
}
pub inline fn _rl_to_upper(c: anytype) @TypeOf(if (__helpers.cast(bool, _rl_lowercase_p(c))) toupper(__helpers.cast(u8, c)) else c) {
    _ = &c;
    return if (__helpers.cast(bool, _rl_lowercase_p(c))) toupper(__helpers.cast(u8, c)) else c;
}
pub inline fn _rl_to_lower(c: anytype) @TypeOf(if (__helpers.cast(bool, _rl_uppercase_p(c))) tolower(__helpers.cast(u8, c)) else c) {
    _ = &c;
    return if (__helpers.cast(bool, _rl_uppercase_p(c))) tolower(__helpers.cast(u8, c)) else c;
}
pub inline fn _rl_digit_value(x: anytype) @TypeOf(x - '0') {
    _ = &x;
    return x - '0';
}
pub inline fn _rl_isident(c: anytype) @TypeOf((ISALNUM(c) != 0) or (c == '_')) {
    _ = &c;
    return (ISALNUM(c) != 0) or (c == '_');
}
pub inline fn ISOCTAL(c: anytype) @TypeOf((c >= '0') and (c <= '7')) {
    _ = &c;
    return (c >= '0') and (c <= '7');
}
pub inline fn OCTVALUE(c: anytype) @TypeOf(c - '0') {
    _ = &c;
    return c - '0';
}
pub inline fn HEXVALUE(c: anytype) @TypeOf(if (__helpers.cast(bool, (c >= 'a') and (c <= 'f'))) (c - 'a') + @as(c_int, 10) else if (__helpers.cast(bool, (c >= 'A') and (c <= 'F'))) (c - 'A') + @as(c_int, 10) else c - '0') {
    _ = &c;
    return if (__helpers.cast(bool, (c >= 'a') and (c <= 'f'))) (c - 'a') + @as(c_int, 10) else if (__helpers.cast(bool, (c >= 'A') and (c <= 'F'))) (c - 'A') + @as(c_int, 10) else c - '0';
}
pub const NEWLINE = '\n';
pub const RETURN = CTRL('M');
pub const RUBOUT = @as(c_int, 0x7f);
pub const TAB = '\t';
pub const ABORT_CHAR = CTRL('G');
pub const PAGE = CTRL('L');
pub const SPACE = ' ';
pub const ESC = CTRL('[');
pub const KEYMAP_SIZE = @as(c_int, 257);
pub const ANYOTHERKEY = KEYMAP_SIZE - @as(c_int, 1);
pub const ISFUNC = @as(c_int, 0);
pub const ISKMAP = @as(c_int, 1);
pub const ISMACR = @as(c_int, 2);
pub const _TILDE_H_ = "";
pub const RL_READLINE_VERSION = @as(c_int, 0x0802);
pub const RL_VERSION_MAJOR = @as(c_int, 8);
pub const RL_VERSION_MINOR = @as(c_int, 2);
pub inline fn rl_clear_timeout() @TypeOf(rl_set_timeout(@as(c_int, 0), @as(c_int, 0))) {
    return rl_set_timeout(@as(c_int, 0), @as(c_int, 0));
}
// /usr/include/readline/readline.h:775:9: warning: macro 'rl_symbolic_link_hook' contains a runtime value, translated to function
pub inline fn rl_symbolic_link_hook() @TypeOf(rl_directory_completion_hook) {
    return rl_directory_completion_hook;
}
pub const READERR = -@as(c_int, 2);
pub const RL_PROMPT_START_IGNORE = '\x01';
pub const RL_PROMPT_END_IGNORE = '\x02';
pub const NO_MATCH = @as(c_int, 0);
pub const SINGLE_MATCH = @as(c_int, 1);
pub const MULT_MATCH = @as(c_int, 2);
pub const RL_STATE_NONE = @as(c_int, 0x000000);
pub const RL_STATE_INITIALIZING = @as(c_int, 0x0000001);
pub const RL_STATE_INITIALIZED = @as(c_int, 0x0000002);
pub const RL_STATE_TERMPREPPED = @as(c_int, 0x0000004);
pub const RL_STATE_READCMD = @as(c_int, 0x0000008);
pub const RL_STATE_METANEXT = @as(c_int, 0x0000010);
pub const RL_STATE_DISPATCHING = @as(c_int, 0x0000020);
pub const RL_STATE_MOREINPUT = @as(c_int, 0x0000040);
pub const RL_STATE_ISEARCH = @as(c_int, 0x0000080);
pub const RL_STATE_NSEARCH = @as(c_int, 0x0000100);
pub const RL_STATE_SEARCH = @as(c_int, 0x0000200);
pub const RL_STATE_NUMERICARG = @as(c_int, 0x0000400);
pub const RL_STATE_MACROINPUT = @as(c_int, 0x0000800);
pub const RL_STATE_MACRODEF = @as(c_int, 0x0001000);
pub const RL_STATE_OVERWRITE = @as(c_int, 0x0002000);
pub const RL_STATE_COMPLETING = @as(c_int, 0x0004000);
pub const RL_STATE_SIGHANDLER = __helpers.promoteIntLiteral(c_int, 0x0008000, .hex);
pub const RL_STATE_UNDOING = __helpers.promoteIntLiteral(c_int, 0x0010000, .hex);
pub const RL_STATE_INPUTPENDING = __helpers.promoteIntLiteral(c_int, 0x0020000, .hex);
pub const RL_STATE_TTYCSAVED = __helpers.promoteIntLiteral(c_int, 0x0040000, .hex);
pub const RL_STATE_CALLBACK = __helpers.promoteIntLiteral(c_int, 0x0080000, .hex);
pub const RL_STATE_VIMOTION = __helpers.promoteIntLiteral(c_int, 0x0100000, .hex);
pub const RL_STATE_MULTIKEY = __helpers.promoteIntLiteral(c_int, 0x0200000, .hex);
pub const RL_STATE_VICMDONCE = __helpers.promoteIntLiteral(c_int, 0x0400000, .hex);
pub const RL_STATE_CHARSEARCH = __helpers.promoteIntLiteral(c_int, 0x0800000, .hex);
pub const RL_STATE_REDISPLAYING = __helpers.promoteIntLiteral(c_int, 0x1000000, .hex);
pub const RL_STATE_DONE = __helpers.promoteIntLiteral(c_int, 0x2000000, .hex);
pub const RL_STATE_TIMEOUT = __helpers.promoteIntLiteral(c_int, 0x4000000, .hex);
pub const RL_STATE_EOF = __helpers.promoteIntLiteral(c_int, 0x8000000, .hex);
pub const RL_SETSTATE = @compileError("unable to translate C expr: expected ')' instead got '|='"); // /usr/include/readline/readline.h:928:9
pub const RL_UNSETSTATE = @compileError("unable to translate C expr: expected ')' instead got '&='"); // /usr/include/readline/readline.h:929:9
pub inline fn RL_ISSTATE(x: anytype) @TypeOf(rl_readline_state & x) {
    _ = &x;
    return rl_readline_state & x;
}
pub const _HISTORY_H_ = "";
pub const _TIME_H = @as(c_int, 1);
pub const _BITS_TIME_H = @as(c_int, 1);
pub const CLOCKS_PER_SEC = __helpers.cast(__clock_t, __helpers.promoteIntLiteral(c_int, 1000000, .decimal));
pub const CLOCK_REALTIME = @as(c_int, 0);
pub const CLOCK_MONOTONIC = @as(c_int, 1);
pub const CLOCK_PROCESS_CPUTIME_ID = @as(c_int, 2);
pub const CLOCK_THREAD_CPUTIME_ID = @as(c_int, 3);
pub const CLOCK_MONOTONIC_RAW = @as(c_int, 4);
pub const CLOCK_REALTIME_COARSE = @as(c_int, 5);
pub const CLOCK_MONOTONIC_COARSE = @as(c_int, 6);
pub const CLOCK_BOOTTIME = @as(c_int, 7);
pub const CLOCK_REALTIME_ALARM = @as(c_int, 8);
pub const CLOCK_BOOTTIME_ALARM = @as(c_int, 9);
pub const CLOCK_TAI = @as(c_int, 11);
pub const TIMER_ABSTIME = @as(c_int, 1);
pub const __struct_tm_defined = @as(c_int, 1);
pub const __itimerspec_defined = @as(c_int, 1);
pub const TIME_UTC = @as(c_int, 1);
pub inline fn __isleap(year: anytype) @TypeOf((__helpers.rem(year, @as(c_int, 4)) == @as(c_int, 0)) and ((__helpers.rem(year, @as(c_int, 100)) != @as(c_int, 0)) or (__helpers.rem(year, @as(c_int, 400)) == @as(c_int, 0)))) {
    _ = &year;
    return (__helpers.rem(year, @as(c_int, 4)) == @as(c_int, 0)) and ((__helpers.rem(year, @as(c_int, 100)) != @as(c_int, 0)) or (__helpers.rem(year, @as(c_int, 400)) == @as(c_int, 0)));
}
pub const HS_HISTORY_VERSION = @as(c_int, 0x0802);
pub inline fn HISTENT_BYTES(hs: anytype) @TypeOf(strlen(hs.*.line) + strlen(hs.*.timestamp)) {
    _ = &hs;
    return strlen(hs.*.line) + strlen(hs.*.timestamp);
}
pub const HS_STIFLED = @as(c_int, 0x01);
pub const ArrowSchema = struct_ArrowSchema;
pub const ArrowArray = struct_ArrowArray;
pub const ArrowArrayStream = struct_ArrowArrayStream;
pub const AdbcDatabase = struct_AdbcDatabase;
pub const AdbcConnection = struct_AdbcConnection;
pub const AdbcStatement = struct_AdbcStatement;
pub const AdbcPartitions = struct_AdbcPartitions;
pub const AdbcErrorDetail = struct_AdbcErrorDetail;
pub const AdbcDriver = struct_AdbcDriver;
pub const AdbcError = struct_AdbcError;
pub const timeval = struct_timeval;
pub const timespec = struct_timespec;
pub const __pthread_internal_list = struct___pthread_internal_list;
pub const __pthread_internal_slist = struct___pthread_internal_slist;
pub const __pthread_mutex_s = struct___pthread_mutex_s;
pub const __pthread_rwlock_arch_t = struct___pthread_rwlock_arch_t;
pub const __pthread_cond_s = struct___pthread_cond_s;
pub const random_data = struct_random_data;
pub const drand48_data = struct_drand48_data;
pub const __locale_struct = struct___locale_struct;
pub const ArrowError = struct_ArrowError;
pub const ArrowType = enum_ArrowType;
pub const ArrowTimeUnit = enum_ArrowTimeUnit;
pub const ArrowValidationLevel = enum_ArrowValidationLevel;
pub const ArrowCompareLevel = enum_ArrowCompareLevel;
pub const ArrowBufferType = enum_ArrowBufferType;
pub const ArrowStringView = struct_ArrowStringView;
pub const ArrowBinaryViewInlined = struct_ArrowBinaryViewInlined;
pub const ArrowBinaryViewRef = struct_ArrowBinaryViewRef;
pub const ArrowBinaryView = union_ArrowBinaryView;
pub const ArrowBufferViewData = union_ArrowBufferViewData;
pub const ArrowBufferView = struct_ArrowBufferView;
pub const ArrowBufferAllocator = struct_ArrowBufferAllocator;
pub const ArrowBuffer = struct_ArrowBuffer;
pub const ArrowBitmap = struct_ArrowBitmap;
pub const ArrowLayout = struct_ArrowLayout;
pub const ArrowArrayView = struct_ArrowArrayView;
pub const ArrowArrayPrivateData = struct_ArrowArrayPrivateData;
pub const ArrowInterval = struct_ArrowInterval;
pub const ArrowDecimal = struct_ArrowDecimal;
pub const ArrowMetadataReader = struct_ArrowMetadataReader;
pub const ArrowSchemaView = struct_ArrowSchemaView;
pub const _G_fpos_t = struct__G_fpos_t;
pub const _G_fpos64_t = struct__G_fpos64_t;
pub const _IO_marker = struct__IO_marker;
pub const _IO_FILE = struct__IO_FILE;
pub const _IO_codecvt = struct__IO_codecvt;
pub const _IO_wide_data = struct__IO_wide_data;
pub const _IO_cookie_io_functions_t = struct__IO_cookie_io_functions_t;
pub const _keymap_entry = struct__keymap_entry;
pub const undo_code = enum_undo_code;
pub const undo_list = struct_undo_list;
pub const _funmap = struct__funmap;
pub const readline_state = struct_readline_state;
pub const tm = struct_tm;
pub const itimerspec = struct_itimerspec;
pub const sigevent = struct_sigevent;
pub const _hist_entry = struct__hist_entry;
pub const _hist_state = struct__hist_state;
