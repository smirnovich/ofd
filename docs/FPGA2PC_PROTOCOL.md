# The communication protocol between FPGA and PC

## Small identifies explanation

Debug IP core - the main OFD IP core which provides an interface between multiple independent debug controllers and a PC
Debug controller - small IP core that captures defined signals and sends them to the Debug IP core

## The information provided by FPGA

|Field|Width in bits|Description|
|-----|-------------|-----------|
|ProbedHASH         | 32| An unique 32 bit identifier generated from all probes names. MD5 For example. Will integrated into the debug IP core during generation |
|Status             |128| A register that contains 2 bit width fields with the status of each debug controller. Up to 64 independent debug controllers |
|Run                |128| A register which launched capturing of each independent debug controller. 1 - start capturing, 0 - stop capturing |
|ControllerConfig0  | 32| A register with global config for the debug controller #0|
|ControllerConfig1  | 32| A register with global config for the debug controller #1|
|...|...|...|
|ControllerConfig63 | 32| A register with global config for the debug controller #63|
|SignalConfig       | 32| An individual configuration for each signal into all debug controllers. From the first to the last signal into the first debug controller and from the first to the last debug controllers |

### Status register field description

|Bit state| Desctiption|
|---------|------------|
|00|Idle|
|01|Waiting for trigger|
|10|Capture|
|11|Reserved|

### Run register field description

|Bit state| Desctiption|
|---------|------------|
|00|Stop capturing|
|01|Start captirung|
|10|Upload results (only for the block mode working)|
|11|Reserved|

### Debug Controller configuration fields

|Bits|Name|Description|
|----|----|-----------|
|0|StreamingType| 0 - block mode (store the data into the block ram and upload ram content after it filling), 1 - continuous mode (captures and streaming always with small buffer into the FIFO)|
|3:1|CaptureType| 0 - continuous, 1 - transitional (capture only when allowed signals is changed), 2 .. 7 - reserve|
|31:4| Reserve| -|

### Signal configuration

|Buts|Name|Description|
|----|----|-----------|
|0|DisableCapture | 0 - enabled capture, 1 - disable capture. Each signal may be disabled for capture. This feature may save an interface throughput into the continuous streaming mode|
|1|DisableSwitching | 0 - enable capture the waveform when the signal is changed, 1 - disable capture |
|2|EnableTrigger | 1 - signal is included to the global trigger option (only for the global AND/OR triggers type), 0 - signal excluded from the trigger |
|31:3| Reserve | - |
