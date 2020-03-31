# webhook

It's a posix compliant shell script for toggling on and off smart devices via IFTTT webhooks, to use it you need to configure some webhooks in your IFTTT
account using this scheme:

For every device create two Webhooks, one for turning on

``` python
IF:
    webhooks.receiveWebRequest
        EventName: turn_on_{{DEVICE}}
THEN:
    yourSmartDeviceManager
        TurnOn: {{DEVICE}}
```

and one for turning off

``` python
IF:
    webhooks.receiveWebRequest
        EventName: turn_off_{{DEVICE}}
THEN:
    yourSmartDeviceManager
        TurnOff: {{DEVICE}}
```

then launch the script with these args:

``` sh
./webhook.sh [0/1] [DEVICE] optional[DELAY]
```

## Configuration

### Key

You need to configure a 'KEY' variable inside your webhook config file.
This variable should contain your Webhook Authentication Key, in order to allow the script to make request the the IFTTT servers, eg:

``` sh
KEY=a68f0060404741799713db2f95e5f3c554488d86fe0
```

### Config file location

The name of the config file should be `config` and the default config folder it's `~/.config/webhook`.
You can change the default folder setting the variable `WEBHOOK_FOLDER` to the path you want to use

## bash-completion

You can also enable some bash completion for your devices sourcing the `webhook-completion.bash` file in your `.bashrc`. Notice that you should source the completion file only AFTER setting the `WEBHOOK_FOLDER` if you don't use the default one.

Write your devices in a `DEVICES` variable as a shell array, eg:

``` sh
DEVICES="smartDevice smartLamp smartPlug"
```
