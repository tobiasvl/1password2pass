1Password Importer
==================

Script for importing [1Password](https://agilebits.com/onepassword) passwords to [`pass`](http://www.zx2c4.com/projects/password-store/).

Note: This script is now a [part](http://git.zx2c4.com/password-store/tree/contrib/importers/1password2pass.rb) of the `pass` package.

Reads files exported from 1Password and imports them into `pass`. Supports comma
and tab delimited text files, as well as logins (but not other items) stored
in the 1Password Interchange File (1PIF) format.

Supports using the title (default) or URL as `pass-name`, depending on your
preferred organization. Also supports importing metadata, adding them with
`pass insert --multiline`; the username and URL are compatible with
[passff](https://github.com/jvenant/passff).

Usage
-----
```bash
Usage: 1password2pass.rb [options] filename
    -f, --force                      Overwrite existing passwords
    -d, --default [FOLDER]           Place passwords into FOLDER
    -n, --name [PASS-NAME]           Select field to use as pass-name: title (default) or URL
    -m, --[no-]meta                  Import metadata and insert it below the password
    -h, --help                       Display this screen
```
