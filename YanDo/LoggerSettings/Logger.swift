//
//  Logger.swift
//  YanDo
//
//  Created by Александра Маслова on 01.07.2023.
//

import CocoaLumberjack

class LoggerFormatter: NSObject, DDLogFormatter {
    private let dateFormatter: DateFormatter
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        super.init()
    }
    func format(message logMessage: DDLogMessage) -> String? {
        let timestamp = dateFormatter.string(from: logMessage.timestamp)
        let logLevel = "\(logMessage.flag.rawValue)"
        let logMsg = logMessage.message
        return "\(timestamp) [\(logLevel)] \(logMsg)"
    }
}

class LoggerConfig {

    static func configureLogger() {
        // Настройка логгера
        DDLog.add(DDOSLogger.sharedInstance) // Вывод логов в консоль
        DDLog.add(DDFileLogger()) // Вывод логов в файл

        // Установка уровня журналирования
        #if DEBUG
            DDLog.setLevel(.debug, for: DDOSLogger.self)
            DDLog.setLevel(.debug, for: DDFileLogger.self)
        #else
            DDLog.setLevel(.warning, for: DDOSLogger.self)
            DDLog.setLevel(.warning, for: DDFileLogger.self)
        #endif

        // Конфигурация файлового логгера
        let fileLogger = DDFileLogger()
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24) // 24 часа
        fileLogger.logFileManager.maximumNumberOfLogFiles = 7 // Хранить до 7 файлов журнала

        // Установка формата вывода логов
        let formatter = LoggerFormatter()
        DDTTYLogger.sharedInstance?.logFormatter = formatter
        fileLogger.logFormatter = formatter
    }
}
