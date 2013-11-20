# pave - Command line tools for Concrete5 websites

Author: Jamon Holmgren (@jamonholmgren)

Provides a set of command line tools for Concrete5.

## Installation

    $ gem install pave

## Usage

Create a new Concrete5 website:

    $ pave new mywebsite

This:

1. Downloads Concrete 5.6.2.1
2. Unzips it into `mywebsite`
3. Removes extra folders
4. Builds an app folder of commonly used folders (symlinked into the root folder so Concrete5 can find them)
5. Initializes a Git repo and adds the first ("Initial") commit.

Other commands:

    $ pave --help
    
Outputs common tasks that pave can do.

## TODO

1. ? Create database (`pave database mydatabase`)
1. Tell user to go set up Concrete5 in-browser once virtual host and db is set up
1. Uninstall? `pave remove mywebsite` (including virtual host)
1. Do database dumps. `pave db dump`
1. Do live database download & replace local one. `pave db download` (confirmation first)
1. Do local database upload & replace remote one. `pave db upload` (confirmation first)


## Contributing

0. Create an issue explaining what you'd like to do and get feedback
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2013 Jamon Holmgren

Released under the MIT license.
