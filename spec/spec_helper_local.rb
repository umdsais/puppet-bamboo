# if these environment variables are set, pass them as class parameters for
# our tests (e.g. use a locally hosted bamboo tarball)
BAMBOO_DOWNLOAD_URL = ENV['BAMBOO_DOWNLOAD_URL'] || nil
BAMBOO_VERSION = ENV['BAMBOO_VERSION'] || '9.6.7'
