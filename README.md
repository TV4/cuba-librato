# CubaLibrato

## Usage

```
$ mix copy_space
Generated cuba_librato app
Welcome to CubaLibrato.

Librato source username: app1@heroku.com
Librato source token: password
Librato source space: old space

Librato destination username: app2@heroku.com
Librato destination token: hunter2
Librato destination space: new space

Download from Librato account: app1@heroku.com, space: old space
Upload to Librato accont: app2@heroku.com, space: new space

Download completed

122 charts to upload
17 metrics to upload

'yes' to continue: yes

Upload completed
$
```

You can also set the following environment variables:

- LIBRATO_USERNAME_SRC
- LIBRATO_TOKEN_SRC
- LIBRATO_SPACE_SRC
- LIBRATO_USERNAME_DEST
- LIBRATO_TOKEN_DEST
- LIBRATO_SPACE_DEST

## Notes

The destination space has to exist.

Charts will be added if the destination space already has charts.

Metrics will be overwritten if they already exist in the destination.

Have fun in the sun 🍹

## LICENSE

Copyright (c) 2019 Bonnier Broadcasting / TV4

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
