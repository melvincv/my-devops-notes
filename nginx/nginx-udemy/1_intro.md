# Configuration Terms

- Context: Sections
- Directive: Name and Value

## Context

- Main context: Global directives to the master process
- http {}
- server {}
- location /uri {}

## Virtual Host

Main config file: /etc/nginx/nginx.conf

Basic Server context

[Code](conf/01+Creating+a+Virtual+Host.conf)

- mime.types file: file types and extensions
- listen on port 80
- document root

## Location Blocks

Used to intercept and process a path request.

[Code](conf/02+Location+Blocks.conf)

### Modifiers

- Prefix

    /greet

    This matches greet and anything after it. Lowest priority.

- REGEX match - case sensitive

    `location ~ /greet[0-9]`

    2nd priority. 

- REGEX match - case insensitive

    `location ~* /greet[0-9]`

    3rd priority.

- Preferential Prefix match

    `location ^~ /Greet2`

    4th priority, more priority than the prefix match.

- Exact match

    `location = /greet`

    Matches the exact path only. Top priority.

