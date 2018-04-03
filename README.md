# Tomcat Native on Alpine Linux

This repo shows how one would go about building Tomcat's [native bindings](http://tomcat.apache.org/native-doc/) inside of Alpine for use either in Tomcat or [Tomcat Embedded](https://tomcat.apache.org/download-80.cgi)

## Usage

* Just pull the prebuilt image

```shell
$ docker pull craigrueda/tcnative:latest
```

`OR`

* Build the image yourself

```shell
$ docker build -t my-image .
```

Once you have your image, you can extend it for your own purposes (i.e. running a Tomcat-based Spring Boot app, or a standard Tomcat server)

## Usage (Java)

In order to take advantage of the provided Tomcat native libs, you'll need to run Java with the appropriate library path set

*Standard Java*
```shell
$ java <your_args_here> -Djava.library.path=/usr/local/apr/lib <your_binary_location>
```

*Running Tomcat*
```shell
$ export JAVA_OPTS="...  -Djava.library.path=/usr/local/apr/lib ..."

$ catalina.sh run
```
