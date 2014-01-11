# pave - Command line tools for Concrete5 websites

Authors: Jamon Holmgren (@jamonholmgren), Ryan Linton (@ryanlntn), and the rest at ClearSight Studio (@clrsightstudio).

Provides a set of command line tools for setting up and developing [Concrete5](http://www.concrete5.org/) websites.

*Requirements:* Designed for Ruby 2.0+ running on OS X Mavericks.

# Installation

    $ gem install pave

# Usage

## Create a new Concrete5 website

    $ pave new mywebsite

This:

1. Downloads Concrete 5.6.2.1 (once) into `~/.pave`
2. Unzips it into `mywebsite`
3. Removes extra folders and sets up folder permissions
4. Adds a `.gitignore` and `.keep`s
5. Attempts to create a virtual host `mywebsite.site`

## Deployments

    $ pave deploy:setup

This sets up a Git-based deployment script to the remote server and deploys an initial version. SSH access is required.

    $ pave deploy

Deploys the site using git. Files and databases are not deployed (see below for how to do that).

## Database

    $ pave db:create mydatabase

Creates a local MySQL database called `mydatabase`

    $ pave db:push

Copies the local Concrete5 database to the remote database. Useful for deploying to staging sites.

    $ pave db:pull

Copies the remote Concrete5 database into the local database. Useful for obtaining production data for testing.

    $ pave db:dump

Creates a database dump file and places it in `.db/YYYY-MM-DD_HH-MM-SS-<databasename>.sql.gz`.

## Files

    $ pave files:push

*WARNING: be careful with this command!* Pushes your local `files/*` to the remote server, completely replacing the remote server's version.

    $ pave files:pull

Pulls the remote `files/*` folder and replaces your local version.

    $ pave files:sync

*TODO:* Pulls newer remote files and pushes newer local files. Ignores cache and tmp files.

## Virtual host setup

    $ sudo pave vh:create myhost.site

Sets up an Apache virtual host in the current directory on `myhost.site`.

    $ sudo pave vh:remove myhost.site

Removes myhost.site virtual host.

    $ sudo pave vh:backup

Backs up your hosts file and vhost file.

    $ sudo pave vh:restore

Restores your previously backed up virtual host file.

    $ sudo pave vh:restart

Restarts Apache.

## Help

    $ pave help

Outputs common tasks that pave can do.

## Updating

    $ pave update

## Contributing

0. Create an issue explaining what you'd like to do and get feedback
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2013 Jamon Holmgren

Released under the MIT license.
