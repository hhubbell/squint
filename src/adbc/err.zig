//! Wrap Arrow ADBC function calls in error handling
const std = @import("std");
const c = @import("c");


/// Elevate a non-zero return code from an arrow-adbc function to an error
pub fn checkAdbc(rcode: c_int) !void {
    if (rcode != c.ADBC_STATUS_OK) {
        return error.AdbcError;
    }
}


/// Elevate a non-zero return code from a nanoarrow function to an error
pub fn checkNanoArrow(rcode: c_int) !void {
    if (rcode != c.NANOARROW_OK) {
        return error.NanoArrowError;
    }
}

/// Elevate a non-zero return code from a nanoarrow function to an error. The
/// key difference between `checkNanoArrowStream` and `checkNanoArrow` is that
/// errors that occur in stream operations carry a detailed error message, and
/// the caller can unpack this message using `onNanoArrowStreamErrMsg`. To
/// facilitate this, the error code is different.
pub fn checkNanoArrowStream(rcode: c_int) !void {
    if (rcode != c.NANOARROW_OK) {
        return error.NanoArrowStreamError;
    }
}

/// Given a stream with an error message, route the message through any object
/// and a callback that accepts this object as the first parameter, and the
/// error message as the second parameter. As a result, this supports a
/// roundabout way of adding an error to some other container. For example:
///
///     ...preamble to unpack error...
///     obj.doSomething(message)
///
/// Is instead
///
///     onNanoArrowStreamErrMsg(&stream, @TypeOf(obj), obj, Object.doSomething)
///
/// There is presumably an even more zig-style way of doing this, but this
/// works well enough even if there are a lot of arguments.
pub fn onNanoArrowStreamErrMsg(
    stream: *c.ArrowArrayStream,
    comptime T: type,
    tgt: *T,
    cb: fn (*T, comptime []const u8, anytype) void
) void {
    if (stream.get_last_error) |callable| {
        const msg: [*c]const u8 = callable(stream);

        if (msg != null) {
            cb(tgt, "{s}", .{ std.mem.span(msg) });
        }
    }
}
