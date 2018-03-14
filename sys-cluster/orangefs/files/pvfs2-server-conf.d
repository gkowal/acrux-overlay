# PVFS2 only uses one config file as of 2.7.0.  This is the path
# to that config file.
#PVFS2_CONF="/etc/pvfs2/fs.conf"

# Additional server options (-a is mandatory for multiserver setup)
#PVFS2_OPTIONS=""

# Automatically call pvfs2-server with --mkfs if the first call to
# start the daemon fails.
#PVFS2_AUTO_MKFS="no"

# How long to wait server for start up (in milliseconds)
#PVFS2_STARTUP_WAIT=1000

# By default on normal stop server will refuse to accept any new
# requests, but will not shutdown until all pending requests are
# completed.
# You may force shutdown after some timeout using this option.
# Set timeout to zero or empty value to disable forced shutdown.
# Value is in seconds.
#PVFS2_FORCED_UMOUNT_TIMEOUT=""

# Nice priority of the server
#PVFS2_NICE=""

# Ionice priority of the server (class[:data]).
#PVFS2_IONICE=""
