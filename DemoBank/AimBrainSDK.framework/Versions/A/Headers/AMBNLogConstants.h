
#ifndef AMBNLogConstants_h
#define AMBNLogConstants_h

/**
 * Represents the possible log levels.
 */
typedef NS_ENUM(NSInteger, AMBNLogLevel) {
    
    /**
     * No log messages.
     */
    AMBNLogLevelNone = 0,
    
    /**
     * Log fatal and unexpected errors.
     */
    AMBNLogLevelError = 1,
    
    /**
     * Log non fatal errors.
     */
    AMBNLogLevelWarn = 2,
    
    /**
     * Log only key operation (init, upload task start, etc.).
     */
    AMBNLogLevelInfo = 3,
    
    /**
     * Log detailed info excluding ‘very noisy’ verbose logging
     */
    AMBNLogLevelDebug = 4,
    
    /**
     * Log most detailed info including network requests, key method calls, etc.
     */
    AMBNLogLevelVerbose = 5
};

#define AMBN_LEVEL_LOG_THREAD(level, levelString, fmt, ...) \
do { \
if (ambnLoggingEnabled && ambnLogLevel >= level) { \
NSString *thread = ([[NSThread currentThread] isMainThread]) ? @"M" : @"B"; \
printf("%s\n", [[NSString stringWithFormat:(@"[%@] [%@] => %s [Line %d] " fmt), levelString, thread, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__] UTF8String]); \
} \
} while(0)

#define AMBN_LEVEL_LOG_NO_THREAD(level, levelString, fmt, ...) \
do { \
if (ambnLoggingEnabled && ambnLogLevel >= level) { \
printf("%s\n", [[NSString stringWithFormat:(@"[%@] %s [Line %d] " fmt), levelString, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__] UTF8String]); \
} \
} while(0)

//only log thread if #AMBN_LOG_THREAD is defined
#ifdef AMBN_LOG_THREAD
#define AMBN_LEVEL_LOG AMBN_LEVEL_LOG_THREAD
#else
#define AMBN_LEVEL_LOG AMBN_LEVEL_LOG_NO_THREAD
#endif

extern BOOL ambnLoggingEnabled; // Default is YES
extern AMBNLogLevel ambnLogLevel; // Default is AMBNLogLevelError
// TODO: analyse - ambnLogLevel is now public.

#define AMBN_LVERBOSE(fmt, ...) AMBN_LEVEL_LOG(AMBNLogLevelVerbose, @"VERBOSE", fmt, ##__VA_ARGS__)
#define AMBN_LDEBUG(fmt, ...) AMBN_LEVEL_LOG(AMBNLogLevelDebug, @"DEBUG", fmt, ##__VA_ARGS__)
#define AMBN_LINFO(fmt, ...) AMBN_LEVEL_LOG(AMBNLogLevelInfo, @"INFO", fmt, ##__VA_ARGS__)
#define AMBN_LWARN(fmt, ...) AMBN_LEVEL_LOG(AMBNLogLevelWarn, @"WARN", fmt, ##__VA_ARGS__)
#define AMBN_LERR(fmt, ...) AMBN_LEVEL_LOG(AMBNLogLevelError, @"ERROR", fmt, ##__VA_ARGS__)

#define AMBNLOG AMBN_LDEBUG

#define IS_AMBNLOG_LEVEL(logLevel) (ambnLoggingEnabled == YES && ambnLogLevel >= logLevel)
#define IS_AMBNLOG_VERBOSE() IS_AMBNLOG_LEVEL(AMBNLogLevelVerbose)


#endif /* AMBNLogConstants_h */
