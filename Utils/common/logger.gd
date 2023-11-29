class_name Logger
# 日志级别枚举

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR,
	FATAL
}

var caller: String

func _init(_caller: String):
	self.caller = _caller

func _log(message, level):
	var level_string : String

	match level:
		LogLevel.DEBUG: 
			level_string = "DEBUG"
		LogLevel.INFO:
			level_string = "INFO"
		LogLevel.WARN:
			level_string = "WARN"
		LogLevel.ERROR:
			level_string = "ERROR"
		LogLevel.FATAL:
			level_string = "FATAL"
		_: 
			level_string = "UNKNOWN"
	
	var current_time = Time.get_datetime_dict_from_system()
	var timestamp = "%d-%02d-%02d %02d:%02d:%02d" % [current_time.year, current_time.month, current_time.day, current_time.hour, current_time.minute, current_time.second]

	print("[%s] [%s] [%s] %s" % [timestamp, level_string, caller, message])

func debug(message: String):
	_log(message, LogLevel.DEBUG)

func info(message: String):
	_log(message, LogLevel.INFO)

func warn(message: String):
	_log(message, LogLevel.WARN)

func error(message: String):
	_log(message, LogLevel.ERROR)

func fatal(message: String):
	_log(message, LogLevel.FATAL)




