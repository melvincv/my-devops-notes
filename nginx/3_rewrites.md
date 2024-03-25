# Return, Rewrite, try_files, named locations

The two directives used for rewrites are `rewrite` and `return`

[Code](conf/04+Rewrites+&+Redirects.conf)

## Redirect using return statement

When the status code is in the 200 series,

`return status_code "string";` \
Eg: `return 200 "Hello World";`

But when the status code is in the 300 series, return accepts a URI

`return status_code URI;` \
Eg: `return 307 /thumb.png;`

This will load `thumb.png` when the user goes to `/logo`:
```
location /logo {
    return 307 /thumb.png
}
```

The URL changes to `/thumb.png`.

## rewrite statement

Redirect tells nginx where to serve the request from. Client URI changes. \
Rewrite changes the URI internally. Client URI does not change. \
Rewrites are evaluated from top down again.

`rewrite regexp uri;`
`rewrite ^/user/\w+ /greet;`

- regex: starts with `/user/` , more than one word after `/user/`

`rewrite ^/user/(\w+) /greet/$1;`

- regex: capture groups:
    - Enclose the part to be captured in (). Reference it by $1, $2 etc.
    - 'last' flag: when there are more than one rewrite statements, evaluate it last

Code: Try loading `/user/john`

## try_files

[Code](nginx/conf/try_files.conf)

- this is used to check for a resource in any number of locations.
- if the first argument does not exist, try the next one...
- final argument results in a rewrite

`try_files $uri /cat.png /greet @friendly_404;`

## Named locations

`location @friendly_404 {`

- put an @ in front of the name