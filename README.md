# webhook
It's a bash script for toggling on and off smart devices via IFTTT webhooks, to use it you need to configure some webhooks in your IFTTT
account using this scheme:

For every device create two Webhooks, one for turning on
```
IF:
    webhooks.receiveWebRequest
        EventName: turn_on_{{DEVICE}}
THEN:
    yourSmartDeviceManager
        TurnOn: {{DEVICE}}
```
and one for turning off
```
IF:
    webhooks.receiveWebRequest
        EventName: turn_off_{{DEVICE}}
THEN:
    yourSmartDeviceManager
        TurnOff: {{DEVICE}}
```

then launch the script with these args:
``` bash
./webhook.sh [0/1] [DEVICE] optional[DELAY]
```