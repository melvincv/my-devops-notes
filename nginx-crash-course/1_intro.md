# NGINX Crash Course - YouTube

[Course](https://www.youtube.com/watch?v=7VAI73roXaY) \
[Channel](https://www.youtube.com/@laithacademy)

## Terminology

Context: Blocks of code containing directives. \
Directives: key value pairs \
MIME Types: tells nginx that a file is of a specific type, like so

```
text/css    css;
```

## Contexts (Blocks)

```
# NGINX server config
events {}

# HTTP block can contain many server blocks
http {
    server {
        listen 80;

        # Normal location block
        location /fruits {
            root /var/www/html;
            try_files /fruits/fruit.html /index.html =404;
        # /fruits will be appended to the URL and root. 
        # NGINX will try to load /var/www/html/fruits/fruit.html
        # If not found, it will try /var/www/html/index.html
        # If not found it will throw a 404 error.
        }

        # Regular expression location block
        location ~* /count/[0-9] {
            root /var/www/html;
            try_files /index.html =404;
        # Try to go to /count/0 /count/1 etc. It will redirect to index.html
        }
    }
}
```

## Rewrites and Redirects

Redirects send the response from another location. Here if the client went to /crops, it will load content from /fruits.
But it will change the URL on the client browser.

```
location /crops {
    return 307 /fruits;
}
```

Rewrites do not change the URL on the client browser.
It is a separate directive, using regex syntax.

```
rewrite ^/number/(\w+) /count/$1;
```

This will rewrite /number/anything to /count/anything

## NGINX as a load balancer

By default, it will forward requests in a round robin way.

Define an upstream block that contains the backend servers.

```
upstream backend {
    server 127.0.0.1:1111;
    server 127.0.0.1:2222;
    server 127.0.0.1:3333;
}

location / {
    proxy_pass http://backend/;
}
```