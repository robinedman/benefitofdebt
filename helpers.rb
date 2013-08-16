# Require all files in a given subdirectory
def require_from_directory(directory)
  Dir[File.join(File.dirname(__FILE__), directory, '*')].each do |file|
    require file unless File.directory?(file)
  end
end

# Call this method like this:
# log.info(msg)
# log.warn(msg)
# log.error(msg)
def log
  env['rack.logger']
end

def log_exception(e)
  LOG.error e
  LOG.error e.message
  LOG.error e.backtrace.join("\n")
end