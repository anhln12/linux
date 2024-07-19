Kiểm tra kết nối mạng với IP & DNS

```
#!/usr/bin/env bash
if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo "The network is up"
else
    echo "The network is down"
fi
```

Kiểm tra kết nối mạng với HTTP
```
#!/usr/bin/env bash
case "$(curl -s --max-time 2 -I https://vinasupport.com | sed 's/^[^ ]* *\([0-9]\).*/\1/; 1q')" in
    [23]) echo "HTTP connectivity is up";;
    5) echo "The web proxy won't let us through";;
    *) echo "The network is down or very slow";;
esac
```
