const std = @import("std");

/// A filename or URI filename specifying the sqlite database. See
/// https://www.sqlite.org/c3ref/open.html#urifilenamesinsqlite3open
/// for more details about URI filenames.
uri: []const u8,

/// Whether to enable (“true”) or disable (“false”) extension loading. The
/// default is disabled.
@"adbc.sqlite.load_extension.enabled": ?[]const u8 = null,

/// To load an extension, first set this option to the path to the extension
/// to load. This will not load the extension yet.
@"adbc.sqlite.load_extension.path": ?[]const u8 = null,

/// After setting the path, set the option to the entrypoint in the extension
/// (or NULL) to actually load the extension.
@"adbc.sqlite.load_extension.entrypoint": ?[]const u8 = null,

/// The size of batches to read. Hence, this also controls how many rows are
/// read to infer the Arrow type.
@"adbc.sqlite.query.batch_rows": ?[]const u8 = null,
