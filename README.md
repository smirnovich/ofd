# Open FPGA Debug

**Open FPGA Debug (OFD)** is a debug tool, which provides effective method to observe signal conditions inside FPGA.
Unlike proprietary analogs (SignalTap/ILA), OFD is a free open-souce IP-core and can be used with FPGA of any vendor.

## UPD 2023/08/27

To make OFD more real the initial idea would be shrinked to the capabilities of VIO/ISS&P mode: introducing **VBP** core!

Directories:

- **example** - first try of UART OFD (in progress)
- **hardware** - main code for FPGA part
  - **buffer** - simple FIFO fo OFD
    - *srcs* - sources
    - *tb* - testbench draft
  - **core** - OFD capture and process state-machine core
  - **interfaces** - the idea is to have different interfaces support
    - **uart** - the first and the simplest interface to use
      - *srcs* - sources
      - *tb* - testbench draft
    - **vbp_core** - *NEW* a virtual bus of pins (VBP) - VIO/ISSP open-source alternative
      - *srcs* - main handler for VBP inside
