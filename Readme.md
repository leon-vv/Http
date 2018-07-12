HTTP
============================

An Idris package to create HTTP servers. This package is a very small wrapper around the Node `http` library. Only the functions that I needed to write the [Todo](https://github.com/leon-vv/Todo) program are implemented.

Usage
-----------------------------
Make sure to install the latest version of the Idris compiler. This package has a dependency on the [Record](https://github.com/leon-vv/Record), [FerryJS](https://github.com/leon-vv/FerryJS) and [Event](https://github.com/leon-vv/Event) packages. So please install these first. Then run:
```idris --install http.ipkg```
To use the library in another file use:
```idris -p record_ -p ferryjs -p event -p http Main.idr```

Documentation
----------------------------
```idris --mkdoc ./http.ipkg```

License
----------------------------
Mozilla Public License, v. 2.0
