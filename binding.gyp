{
  "targets": [
    {
      "target_name": "addon",
      "sources": [ 'hello.mm' ],
    }
  ],
  'conditions': [
    ['OS=="mac"', {
        'xcode_settings': {
            'OTHER_CFLAGS': [
                '-ObjC++'
            ]
        }
    }]
  ]
}
