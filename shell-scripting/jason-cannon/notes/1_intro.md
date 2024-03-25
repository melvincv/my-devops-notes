# Introducion

Check if a command is a shell builtin or not
```
type -a COMMAND
```

## Conditionals

If statement: test operators

```
help test
```

String Operators: =, !=, <, > \
File Operators: -e, -f, -d \
Arithmetic Operators: -eq, -ne, -le, lt, -ge, -gt \

## Variables

UID - User ID
EUID - Effective UID

Check if run as root
```
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run as root." >&2
    exit 1
fi
```

## Exit Status

0 = OK \
1-255 = Error

Get username

```
USER_NAME=$(id -un)
if [ "$?" -ne 0 ]; then
    echo "The id command failed"
    exit 1
fi
```

## Reading input from user

```
read -p 'Type Name: ' NAME
help read | less
```
---

[Project 2](../projects/add-local-user.sh)

---
