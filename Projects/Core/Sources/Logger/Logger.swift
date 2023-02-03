import Foundation

enum LogLevel {
    case error
    case warning
    case info
    case debug
    case verbose
}

extension LogLevel {
    public var prefix: String {
        switch self {
            case .error: return "⛔️ ERROR"
            case .warning: return "⚠️ WARNING"
            case .info: return "ℹ️ INFO"
            case .debug: return "🐛 DEBUG"
            case .verbose: return "🔎 VERBOSE"
        }
    }
}

/// A shared instance of `Logger`.
public let logger = Logger()

public final class Logger {
    
    // MARK: Initialize
    
    init() { }
    
    private func debugPrint(
        _ message: @autoclosure () -> Any,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line,
        context: Any? = nil,
        level: LogLevel = .debug
    ) {
        #if DEBUG
        print("\(self.timeStamp())\(level.prefix) \(self.fileInformation(file, function, line)) - \(message())")
        #endif
    }
    
    // MARK: Logging
    
    public func error(
        _ items: Any...,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        debugPrint(message, file: file, function: function, line: line, level: .error)
    }
    
    public func warning(
        _ items: Any...,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        debugPrint(message, file: file, function: function, line: line, level: .warning)
    }
    
    public func info(
        _ items: Any...,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        debugPrint(message, file: file, function: function, line: line, level: .info)
    }
    
    public func debug(
        _ items: Any...,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        debugPrint(message, file: file, function: function, line: line, level: .debug)
    }
    
    public func verbose(
        _ items: Any...,
        file: String = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) {
        let message = self.message(from: items)
        debugPrint(message, file: file, function: function, line: line, level: .verbose)
    }
    
    
    private func timeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS "
        
        return dateFormatter.string(from: Date())
    }
    
    private func fileInformation(_ file: String, _ function: StaticString, _ line: UInt) -> String {
        guard let lastFile = file.components(separatedBy: "/").last,
              !lastFile.isEmpty else { return "No File" }
        return lastFile.replacingOccurrences(of: ".swift", with: "") + ".\(function)" + ":\(line)"
    }
    
    private func message(from items: [Any]) -> String {
        return items
            .map { String(describing: $0) }
            .joined(separator: " ")
    }
}
