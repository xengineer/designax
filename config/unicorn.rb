$default_env   = "production" # デフォルトRailsEnv
$unicorn_user  = "nubee"        # slaveの実行ユーザ
$unicorn_group = "nubee"        # slaveの実行グループ

$dev_processes  = 4           # dev環境用子プロセス数
$prod_processes = 16          # 本番環境用子プロセス数

$timeout = 75                 # タイムアウト秒数。タイムアウトしたslaveは再起動される
$rootdir = '/opt/app/designax/current/'
$pidval = $rootdir + '/tmp/pids/unicorn.pid'


# String => UNIX domain socket / FixNum => TCP socket
# $listen = "/home/bps/tmp/unicorn.sock"
#listen '/tmp/test.sock'
$listen = 3000

# ---- end of config ----

# Main Config for Unicorn
rails_env = ENV['Rails.root'] || $default_env
worker_processes (rails_env == 'production' ? $prod_processes : $dev_processes)
preload_app true
timeout $timeout
listen $listen, :backlog => 2048
pid $pidval

stderr_path "./log/unicorn.stderr.log"
stdout_path "./log/unicorn.stderr.log"

# workerをフォークする前の処理
before_fork do |server, worker|
  ##
  # When sent a USR2, Unicorn will suffix its pidfile with .oldbin and
  # immediately start loading up a new version of itself (loaded with a new
  # version of our app). When this new Unicorn is completely loaded
  # it will begin spawning workers. The first worker spawned will check to
  # see if an .oldbin pidfile exists. If so, this means we've just booted up
  # a new Unicorn and need to tell the old one that it can now die. To do so
  # we send it a QUIT.
  #
  # Using this method we get 0 downtime deploys.

  #pid '/tmp/test.pid'
  old_pid = $rootdir + '/tmp/pids/unicorn.pid.oldbin'
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      # 古いマスターがいたら死んでもらう
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

# workerをフォークしたあとの処理
after_fork do |server, worker|
  ##
  # Unicorn master loads the app then forks off workers - because of the way
  # Unix forking works, we need to make sure we aren't using any of the parent's
  # sockets, e.g. db connection

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
  #CHIMNEY.client.connect_to_server
  # Redis and Memcached would go here but their connections are established
  # on demand, so the master never opens a socket

  ##
  # Unicorn master is started as root, which is fine, but let's
  # drop the workers to git:git

  begin
    uid, gid = Process.euid, Process.egid
    user, group = $unicorn_user, $unicorn_group
    target_uid = Etc.getpwnam(user).uid
    target_gid = Etc.getgrnam(group).gid
    worker.tmp.chown(target_uid, target_gid)
    if uid != target_uid || gid != target_gid
      Process.initgroups(user, target_gid)
      Process::GID.change_privilege(target_gid)
      Process::UID.change_privilege(target_uid)
    end
  rescue => e
    if Rails.root == 'development'
      STDERR.puts "couldn't change user, oh well"
    else
      raise e
    end
  end
end

