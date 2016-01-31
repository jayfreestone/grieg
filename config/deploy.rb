# config valid only for current version of Capistrano
lock '3.4.0'

set :application, ''
set :repo_url, ''

set :wp_localurl, ''

set :linked_dirs, %w{wp-content/uploads}
set :linked_files, %w{wp-config.php}

namespace :deploy do

  desc "create WordPress files for symlinking"
  task :create_wp_files do
    on roles(:app) do
      execute :touch, "#{shared_path}/wp-config.php"
    end
  end

  after 'check:make_linked_dirs', :create_wp_files

  desc "Creates robots.txt for non-production envs"
  task :create_robots do
    on roles(:app) do
      if fetch(:stage) != :production then

        io = StringIO.new('User-agent: *
Disallow: /')
        upload! io, File.join(release_path, "robots.txt")
        execute :chmod, "644 #{release_path}/robots.txt"
      end
    end
  end

  desc "Install node modules non-globally"
  task :npm_install do
    on roles(:app) do
      execute "\\mkdir -p #{shared_path}/wp-content/themes/themename && cp #{release_path}/wp-content/themes/themename/package.json #{shared_path}/wp-content/themes/themename"
      execute "cd #{shared_path}/wp-content/themes/themename && npm install"
      execute "ln -s #{shared_path}/wp-content/themes/themename/node_modules #{release_path}/wp-content/themes/themename/"
    end
  end

  desc "Build assets"
  task :gulp do
    on roles(:app) do
      execute "cd #{release_path}/wp-content/themes/themename && gulp build --production"
    end
  end

  desc "Purge cache"
  task :purge do
    on roles(:app) do
      wp_siteurl = fetch(:stage_url)
      execute "curl –silent #{wp_siteurl}/purge/"
    end
  end

  desc "Brute force permissions"
  task :setup_group do
    on roles(:app) do
      execute "chown -R deploy:www-data #{release_path} && chmod -R g+s #{release_path}"
      execute "sudo chown -R deploy:www-data #{shared_path}/wp-content/uploads && find #{shared_path}/wp-content/uploads -type d -exec chmod 2775 {} + && find #{shared_path}/wp-content/uploads -type f -exec chmod 664 {} + "
    end
  end

  after :updated, :npm_install
  after :npm_install, :gulp
  after :finished, :setup_group
  after :finished, :create_robots
  after :finished, :purge
  after :finishing, "deploy:cleanup"

end

