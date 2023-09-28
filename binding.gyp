{
  "targets": [
    {
      "target_name": "addon",

      "cflags_cc!": [
        "-fno-rtti",
        "-fno-exceptions"
      ],

      "xcode_settings": {
        "GCC_ENABLE_CPP_RTTI": "YES",
        "GCC_ENABLE_CPP_EXCEPTIONS": "YES",
        "OTHER_CFLAGS": [
            "-ObjC++"
        ]
      },

      "sources": [
        "src/hello.mm",
      ],
    }
  ],
}
