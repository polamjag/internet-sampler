# INTERNET SAMPLER

Internet Sampler is:

- A Sampler as a Service
- Realtive Collaborative Sampler Imprementation

## Up and running

1. install ruby, bundler and redis
1. clone repo and chdir into it
1. `bundle install --path vendor/bundle`
1. `bundle exec rackup`

OR

```
$ gem install internet-sampler
$ internet-sampler -t SLUG_OF_SAMPLE:/path/to/sample.mp3 -t SLUG_FOR_ANOTHER_SMAPLE:/path/2/sound.mp3
```

Note that path to sample is URL, not the filepath in your machine.

You know there is `--help` like this:

```
Usage: internet-sampler [options]
    -p, --port port                  port to listen (default is 9292)
    -b, --bind host                  host to bind (default is localhost)
    -e, --environment env            environment to run (production, test or development; default is development)
    -t, --track slug:url             sample sound to serve (note that `url' is not path to file but URL to serve)
```

[see blog post about this app (in Japanese)](http://polamjag.hatenablog.jp/entry/2015/05/15/044314)

## REST API

### GET `/api/v1/tracks`

parameters: none

Sample responce:

```json
[
  {
    "slug": "エモい",
    "path": "/mp3/emoi.mp3",
    "description": "",
    "count": "747"
  },
  {
    "slug": "最高",
    "path": "/mp3/saiko.mp3",
    "description": "",
    "count": "1180"
  },
  {
    "slug": "銅鑼",
    "path": "/mp3/Gong-266566.mp3",
    "description": "",
    "count": "61"
  },
  {
    "slug": "Frontliner",
    "path": "/mp3/frontliner-fsharp-kick.mp3",
    "description": "",
    "count": "201"
  }
]
```

### GET `/api/v1/tracks/:slug/play`

parameters: none

Sample responce:

```json
{
  "slug": "Frontliner",
  "path": "/mp3/frontliner-fsharp-kick.mp3",
  "description": "",
  "count": "202"
}
```

## License

The MIT License (MIT)

Copyright (c) 2015 polamjag

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

### Credits

`/public/mp3/emoi.mp3` and `/public/mp3/saiko.mp3` are licensed under CC-BY: http://p1kachu.net/pmannet/

`/public/mp3/frontliner-fsharp-kick.mp3` is licensed under CC-BY: https://soundcloud.com/frontliner/frontliner-hardstyle-kick

`public/mp3/Gong-266566.mp3` is licensed under CC-BY: http://freesound.org/people/GowlerMusic/sounds/266566/ (note that i cut off margin)
