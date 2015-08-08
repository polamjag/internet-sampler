# INTERNET SAMPLER

## Up and running

1. install ruby, bundler and redis
1. clone repo and chdir into it
1. `bundle install --path vendor/bundle`
1. `bundle exec rackup`

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

## Credits

`/public/mp3/emoi.mp3` and `/public/mp3/saiko.mp3` are licensed under CC-BY: http://p1kachu.net/pmannet/

`/public/mp3/frontliner-fsharp-kick.mp3` is licensed under CC-BY: https://soundcloud.com/frontliner/frontliner-hardstyle-kick

`public/mp3/Gong-266566.mp3` is licensed under CC-BY: http://freesound.org/people/GowlerMusic/sounds/266566/ (note that i cut off margin)
