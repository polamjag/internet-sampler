require 'internet-sampler'

InternetSampler::Application.run_with_sampler_options!(
  {
    tracks: [
      { slug: 'エモい', path: '/mp3/emoi.mp3' },
      { slug: '最高', path: '/mp3/saiko.mp3' },
      { slug: '銅鑼', path: '/mp3/Gong-266566.mp3' },
      { slug: 'Frontliner', path: '/mp3/frontliner-fsharp-kick.mp3' },
    ]
  },
  { port: 9292, bind: 'localhost' }
)
