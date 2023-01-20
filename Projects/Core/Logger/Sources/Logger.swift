import Foundation

import CocoaLumberjack
import CocoaLumberjackSwift

extension DDLogFlag {
    public var level: String {
        switch self {
        case DDLogFlag.error: return "⛔️ ERROR"
        case DDLogFlag.warning: return "⚠️ WARNING"
        case DDLogFlag.info: return "ℹ️ INFO"
        case DDLogFlag.debug: return "🐛 DEBUG"
        case DDLogFlag.verbose: return "🔎 VERBOSE"
        default: return "☠️ UNKNOWN"
        }
    }
}

private class LogFormatter: NSObject, DDLogFormatter {
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return dateFormatter
    }()
    
    public func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = LogFormatter.dateFormatter.string(from: logMessage.timestamp)
        let level = logMessage.flag.level
        let filename = logMessage.fileName
        let function = logMessage.function ?? ""
        let line = logMessage.line
        let message = logMessage.message.components(separatedBy: "\n").joined(separator: "\n    ")
        return "\(timestamp) \(level) \(filename).\(function):\(line) - \(message)"
    }
    
    private func formattedDate(from date: Date) -> String {
        return LogFormatter.dateFormatter.string(from: date)
    }
    
}

/// A shared instance of `Logger`.
public let logger = Logger()

public final class Logger {
    
    // MARK: Initialize
    
    init() {
        setenv("XcodeColors", "YES", 0)
        
        // TTY = Xcode console
        if let sharedInstance = DDTTYLogger.sharedInstance {
            sharedInstance.logFormatter = LogFormatter()
            sharedInstance.colorsEnabled = false /* true */ // Note: doesn't work in Xcode 8
            sharedInstance.setForegroundColor(
                DDMakeColor(30, 121, 214),
                backgroundColor: nil, for: .info
            )
            sharedInstance.setForegroundColor(
                DDMakeColor(50, 143, 72),
                backgroundColor: nil, for: .debug
            )
            DDLog.add(sharedInstance)
        }
        
        // File logger
        let fileLogger: DDFileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24) // 24 hours
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7
        DDLog.add(fileLogger)
    }
    
    // MARK: Logging
    
    public func error(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        DDLogError(message, file: file, function: function, line: line)
    }
    
    public func warning(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        DDLogWarn(message, file: file, function: function, line: line)
    }
    
    public func info(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        DDLogInfo(message, file: file, function: function, line: line)
    }
    
    public func debug(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        DDLogDebug(message, file: file, function: function, line: line)
    }
    
    public func verbose(
        _ items: Any...,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        DDLogVerbose(message, file: file, function: function, line: line)
    }

    // MARK: Utils
    private func logPrefix(file: String,
                           function: String,
                           line: UInt) -> String {
        
        let filename = file.components(separatedBy: "/").last?.split(separator: ".").first ?? ""
        let format = "\(filename).\(function):\(line)"
        
        return format
    }
    
    private func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }
}
