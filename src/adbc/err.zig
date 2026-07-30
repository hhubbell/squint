//! Wrap Arrow ADBC function calls in error handling
const std = @import("std");
const c = @import("c");


pub fn checkAdbc(rcode: c_int) !void {
    if (rcode != c.ADBC_STATUS_OK) {
        return error.AdbcError;
    }
}

pub fn checkArrowStream(rcode: c_int) !void {
    if (rcode != 0) {
        return error.ArrowStreamError;
    }
}

pub fn checkNanoArrow(rcode: c_int) !void {
    if (rcode != c.NANOARROW_OK) {
        return error.NanoArrowError;
    }
}

pub fn onArrowStreamErrMsg(
    stream: *c.ArrowArrayStream,
    cb: *const fn ([]const u8) void
) void {
    if (stream.get_last_error) |callable| {
        const msg: [*c]const u8 = callable(stream);

        if (msg != null) {
            cb(std.mem.span(msg));
        }
    }
}
