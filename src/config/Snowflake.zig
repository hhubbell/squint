/// The Snowflake URI should be of one of the following formats:
///  user[:password]@account/database/schema[?param1=value1&paramN=valueN]
///  user[:password]@account/database[?param1=value1&paramN=valueN]
///  user[:password]@host:port/database/schema?account=user_account[&param1=value1&paramN=valueN]
///  host:port/database/schema?account=user_account[&param1=value1&paramN=valueN]
///
/// Refer to the official Snowflake documentation to obtain a valid connection
/// URI or to the Snowflake Go driver documentation to build a URI manually.
///
/// Alternately, instead of providing a full URI, the configuration can be
/// entirely supplied using the other available options or some combination of
/// the URI and other options. If a URI is provided, it will be parsed first
/// and any explicit options provided will override anything parsed from the
/// URI.
uri: ?[]const u8 = null,


/// Client Options
///
/// The options used for creating a Snowflake Database connection can be
/// customized.
/// 
/// The user account username.
username: ?[]const u8 = null,

/// The database this session should default to using.
@"adbc.snowflake.sql.db": ?[]const u8 = null,

/// The schema this session should default to using.
@"adbc.snowflake.sql.schema": ?[]const u8 = null,

/// The warehouse this session should default to using.
@"adbc.snowflake.sql.warehouse": ?[]const u8 = null,

/// The role that should be used for authentication.
@"adbc.snowflake.sql.role": ?[]const u8 = null,

/// The Snowflake region to use for constructing the connection URI.
@"adbc.snowflake.sql.region": ?[]const u8 = null,

/// The Snowflake account that should be used for authentication and building
/// the connection URI.
@"adbc.snowflake.sql.account": ?[]const u8 = null,

/// This should be either http or https.
@"adbc.snowflake.sql.uri.protocol": ?[]const u8 = null,

/// The port to use for constructing the URI for connection.
@"adbc.snowflake.sql.uri.port": ?[]const u8 = null,

/// The explicit host to use for constructing the URL to connect to.
@"adbc.snowflake.sql.uri.host": ?[]const u8 = null,

/// Allows specifying alternate types of authentication, the allowed values are:
///  auth_snowflake: General username/password authentication (this is the default)
///  auth_oauth: Use OAuth authentication for the snowflake connection.
///  auth_ext_browser: Use an external browser to access a FED and perform SSO auth.
///  auth_okta: Use a native Okta URL to perform SSO authentication using Okta
///  auth_jwt: Use a provided JWT to perform authentication.
///  auth_mfa: Use a username and password with MFA.
///  auth_pat: Use a programmatic access token for authentication.
///  auth_wif: Use Workload Identity Federation for authentication.
@"adbc.snowflake.sql.auth_type": ?[]const u8 = null,

/// If using OAuth or another form of authentication, this option is how you
/// can explicitly specify the token to be used for connection.
@"adbc.snowflake.sql.client_option.auth_token": ?[]const u8 = null,

/// If using auth_okta, this option is required in order to specify the Okta URL
/// to connect to for SSO authentication.
@"adbc.snowflake.sql.client_option.okta_url": ?[]const u8 = null,

/// Specify login retry timeout excluding network roundtrip and reading http
/// responses. Value should be formatted as described here
/// <https://pkg.go.dev/time#ParseDuration>, such as 300ms, 1.5s or 1m30s. Even
/// though negative values are accepted, the absolute value of such a duration
/// will be used.
@"adbc.snowflake.sql.client_option.login_timeout": ?[]const u8 = null,

/// Specify request retry timeout excluding network roundtrip and reading http
/// responses. Value should be formatted as described here
/// <https://pkg.go.dev/time#ParseDuration>, such as 300ms, 1.5s or 1m30s. Even
/// though negative values are accepted, the absolute value of such a duration
/// will be used.
@"adbc.snowflake.sql.client_option.request_timeout": ?[]const u8 = null,

/// JWT expiration will occur after this timeout. Value should be formatted as
/// described here <https://pkg.go.dev/time#ParseDuration>, such as 300ms, 1.5s
/// or 1m30s. Even though negative values are accepted, the absolute value of
/// such a duration will be used.
@"adbc.snowflake.sql.client_option.jwt_expire_timeout": ?[]const u8 = null,

/// Specify timeout for network roundtrip and reading http responses. Value
/// should be formatted as described here
/// <https://pkg.go.dev/time#ParseDuration>, such as 300ms, 1.5s or 1m30s. Even
/// though negative values are accepted, the absolute value of such a duration
/// will be used.
@"adbc.snowflake.sql.client_option.client_timeout": ?[]const u8 = null,

/// Allows specifying the Application Name to Snowflake for the connection.
@"adbc.snowflake.sql.client_option.app_name": ?[]const u8 = null,

/// Disable verification of the server’s TLS certificate. Value should be true
/// or false.
@"adbc.snowflake.sql.client_option.tls_skip_verify": ?[]const u8 = null,

/// Control the fail open mode for OCSP. Default is true. Value should be
/// either true or false.
@"adbc.snowflake.sql.client_option.ocsp_fail_open_mode": ?[]const u8 = null,

/// Enable the session to persist even after the connection is closed. Value
/// should be either true or false.
@"adbc.snowflake.sql.client_option.keep_session_alive": ?[]const u8 = null,

/// Specify the RSA private key which should be used to sign the JWT for
/// authentication. This should be a path to a file containing a PKCS1 private
/// key to be read in and parsed. Commonly encoded in PEM blocks of type “RSA
/// PRIVATE KEY”.
@"adbc.snowflake.sql.client_option.jwt_private_key": ?[]const u8 = null,

/// Parses an encrypted or unencrypted PKCS #8 private key without having to
/// read it from the file system. If using encrypted, the
/// adbc.snowflake.sql.client_option.jwt_private_key_pkcs8_password value is
/// required and used to decrypt.
@"adbc.snowflake.sql.client_option.jwt_private_key_pkcs8_value": ?[]const u8 = null,

/// Passcode to use when passing an encrypted PKCS #8 value.
@"adbc.snowflake.sql.client_option.jwt_private_key_pkcs8_password": ?[]const u8 = null,

/// The Snowflake driver allows for telemetry information which can be disabled
/// by setting this to true. Value should be either true or false.
@"adbc.snowflake.sql.client_option.disable_telemetry": ?[]const u8 = null,

/// Specifies the location of the client configuration JSON file. See the
/// [Snowflake Go docs](https://github.com/snowflakedb/gosnowflake/blob/a26ac8a1b9a0dda854ac5db9c2c145f79d5ac4c0/doc.go#L130) for more details.
@"adbc.snowflake.sql.client_option.config_file": ?[]const u8 = null,

/// Set the logging level
@"adbc.snowflake.sql.client_option.tracing": ?[]const u8 = null,

/// When true, the MFA token is cached in the credential manager. Defaults to
/// true on Windows/OSX, false on Linux.
@"adbc.snowflake.sql.client_option.cache_mfa_token": ?[]const u8 = null,

/// When true, the ID token is cached in the credential manager. Defaults to
/// true on Windows/OSX, false on Linux.
@"adbc.snowflake.sql.client_option.store_temp_creds": ?[]const u8 = null,

/// When using auth_wif for workload identity federation authentication, this
/// must be set to the appropriate identity provider.
@"adbc.snowflake.sql.client_option.identity_provider": ?[]const u8 = null,

/// When true, fixed-point snowflake columns with the type NUMBER will be
/// returned as Decimal128 type Arrow columns using the precision and scale
/// of the NUMBER type. When false, NUMBER columns with a scale of 0 will be
/// returned as Int64 typed Arrow columns and non-zero scaled columns will be
/// returned as Float64 typed Arrow columns. The default is true.
@"adbc.snowflake.sql.client_option.use_high_precision": ?[]const u8 = null,

/// Controls the behavior of Timestamp values with Nanosecond precision. Native
/// Go behavior is these values will overflow to an unpredictable value when
/// the year is before year 1677 or after 2262. This option can control the
/// behavior of the timestamp_ltz, timestamp_ntz, and timestamp_tz types. Valid
/// values are
///  - nanoseconds: Use default behavior for nanoseconds.
///  - nanoseconds_error_on_overflow: Throws an error when the value will
///    overflow to enforce integrity of the data.
///  - microseconds: Limits the max Timestamp precision to microseconds, which
///    is safe for all values.
@"adbc.snowflake.sql.client_option.max_timestamp_precision": ?[]const u8 = null,

