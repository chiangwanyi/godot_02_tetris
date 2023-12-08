class_name Logger
# 日志级别枚举

enum LogLevel {
	DEBUG,
	INFO,
	WARN,
	ERROR,
	FATAL
}

static func _format_message(message: String, args: Array) -> String:
	return message.format(args, "{}")


static func _log(caller:String, message, level):
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
	
static func debug(caller, message: String, args: Array = []):
	_log(caller.get_class_name(), _format_message(message, args), LogLevel.DEBUG)

static func info(caller, message: String, args: Array = []):
	_log(caller.get_class_name(), _format_message(message, args), LogLevel.INFO)

static func warn(caller, message: String, args: Array = []):
	_log(caller.get_class_name(), _format_message(message, args), LogLevel.WARN)

static func error(caller, message: String, args: Array = []):
	_log(caller.get_class_name(), _format_message(message, args), LogLevel.ERROR)

static func fatal(caller, message: String, args: Array = []):
	_log(caller.get_class_name(), _format_message(message, args), LogLevel.FATAL)
