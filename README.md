# Grieg

A basic WordPress boilerplate for getting started with [Capistrano](http://capistranorb.com) & [Composer](https://getcomposer.org). The setup is heavily based on the excellent [wp-deploy](https://github.com/Mixd/wp-deploy), but uses Composer to manage dependencies (core/plugins) instead of git-submodules, which makes everything far easier to maintain.

This setup is *very* specific and opinionated. Many assumptions are made about the setup since it was created to server a very specific environment.

Core lives in `wordpress` with themes/plugins/uploads living in the top-level `wp-content`. Plugins are ignored (as they are managed by Composer) as are uploads, meaning the only files commited in `wp-content` are theme-related.

## Requirements

Assuming a UNIX-based system, this setup requires:
- [Composer](https://getcomposer.org)
- [Capistrano](http://capistranorb.com) (and Ruby)
- [Capistrano-Composer](https://github.com/capistrano/composer) (gem)

The assumption is that assets will be built on the server, and that [Gulp](http://gulpjs.com/) will handle the build process, meaning that Gulp and [Node](https://nodejs.org/en/) are also necessary for the full package.
