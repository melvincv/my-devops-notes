# Return, Rewrite, try_files, named locations

## return statement

[Code](nginx/conf/rewrites.conf)

`return status_code string;`

But when the status code is in the 300 series, return accepts a URI

`return 307 /thumb.png;`

## Rewrite statement

Redirect tells nginx where to serve the request from.
Rewrite changes the URI internally. Client URI does not change

`rewrite regexp uri;`
`rewrite ^/user/\w+ /greet;`

- regex: more than one word after /user/
- rewrites are evaluated from the top again.
- regex: capture groups
    - `rewrite ^/user/(\w+) /greet/$1;`

        Enclose the part to be captured in (). Reference it by $1, $2 etc.
- 'last' flag
    - when there are more than one rewrite statements, evaluate it last

## try_files

[Code](nginx/conf/try_files.conf)

- this is used to check for a resource in any number of locations.
- if the first argument does not exist, try the next one...
- final argument results in a rewrite

`try_files $uri /cat.png /greet @friendly_404;`

## Named locations

`location @friendly_404 {`

- put an @ in front of the name