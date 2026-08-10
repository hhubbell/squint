# Squint

Look at the data. Look at it!

Squint is a simple CLI for executing SQL queries using [Arrow Database
Connectivity (ADBC)](https://arrow.apache.org/adbc/current/index.html).

1. [Prerequisites](#prerequisites)
2. [Dependencies](#dependencies)
3. [Motivation](#motivation)
4. [Usage](#usage)
5. [Drivers](#drivers)
6. [To Do/Known Issues](#to-do)

## Prerequisites

Squint is written in Zig, version 0.17. The development version which currently builds is 
`0.17.0-dev.1464+6aff551f1`. Squint has Arrow dependencies. Squint also depends
on `linenoise` for reading user input. All dependencies are vendored.
Therefore, building is as simple as cloning this repo and running:

```bash
zig build
```

## Dependencies

Zig seeks to minimize the number of external dependencies it relies on. However,
the following libraries are required. All dependencies are vendored in
[`vendor/`](vendor/)

- [`arrow-adbc`](https://github.com/apache/arrow-adbc)
- [`arrow-nanoarrow`](https://github.com/apache/arrow-nanoarrow)
- [`linenoise`](https://github.com/antirez/linenoise)

## Motivation

The motivation behind squint was to develop a small SQL CLI as an educational
exercise. Along the way, I also wanted to address some mild annoyances I had
with existing vendor-specific alternatives. I'm not sure squint is
better, even marginally, but what defines marginally better anyway? 

- Paging Results: Squint sends large result sets through a pager. Paging
  large results is a nice UI when you accidentally return a massively long
  or wide result set. This behavior is inspired by [psql](https://www.postgresql.org/docs/current/app-psql.html)
- Cancellation: Specifically, being able to cancel execution without killing
  the session.
- Tab-Completion: Provide both keyword completion and database object
  completion, with some context awareness to help suggest a meaningful
  completion.

Squint aims to be relatively cross-platform. However, this application uses
POSIX signals, and so only supports systems that provide this facility. As a
result, Windows is supported through [WSL](https://learn.microsoft.com/en-us/windows/wsl/),
but not natively. It is unlikely that Windows will be supported natively.

## Usage

```
squint 0.0.0-dev.r5

Usage: squint [DRIVER] [ARGS]

  driver	Any driver supported by adbc_driver_manager

  --uri		Database connection string parameters
  --profile	Connection profile config name
```

## Drivers

Squint uses ADBC. [ADBC is a columnar, minimal-overhead alternative to JDBC/ODBC for analytical applications.](https://arrow.apache.org/blog/2023/01/05/introducing-arrow-adbc/).
ADBC was selected over JDBC/ODBC specifically because squint targets
exploratory analytic workflows. ADBC is a relatively new technology, and new
technology is *always cool*. Because squint is cool, it has to use ADBC.

A positive side effect of using ADBC is that squint supports a large number of
database vendors automatically. You just need to [install a driver](https://adbc-drivers.org/).

Squint does not bundle any drivers. The easiest way to install a driver is
using [`dbc`](https://columnar.tech/dbc), but you can also
[compile your own](https://arrow.apache.org/adbc/main/driver/installation.html).


## To Do

Squint is far from perfect. Here are some things that need to be addressed to
get there.

- Set a consistent row limit for all drivers. Currently this behavior is
  driver-specific, based on how the driver batches row sets.
- Data type presentation. Not all data types are confirmed to be displaying
  correctly - e.g. `DATETIME`.
- Truncate wide columns. Do something like `|Really long res...|` instead of
  printing the whole column. This should be configurable.
- Nice-to-have dotcommands: .source, .catalog, and others
