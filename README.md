# pave - Command line tools for Concrete5 websites

Author: Jamon Holmgren (@jamonholmgren)

Provides a set of command line tools for Concrete5.

## Installation

    $ gem install pave

## Usage

    $ pave new mywebsite

This will download Concrete 5.6.2.1, unzip it into the `mywebsite`
folder, remove extra folders, and build an app folder of commonly
used folders (symlinked into the root folder so Concrete5 can find them).

It also initializes a Git repo and adds the first ("Initial") commit.

## Contributing

0. Create an issue explaining what you'd like to do and get feedback
1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright (c) 2013 Jamon Holmgren

Released under the MIT license.
