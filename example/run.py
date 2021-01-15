from pathlib import Path
from vunit.verilog import VUnit

VU = VUnit.from_argv()
p = Path('..')

lib = VU.add_library("lib")
lib.add_source_files(p.resolve() / "example/*.sv", allow_empty=True)
lib.add_source_files(p.resolve() / "hardware/buffer/srcs/*.sv", allow_empty=True)
lib.add_source_files(p.resolve() / "hardware/core/*.sv", allow_empty=True)
lib.add_source_files(p / "hardware/buffer/tb/*.sv", allow_empty=True)
lib.add_source_files(p.resolve() / "hardware/interfaces/uart/srcs/*.sv", allow_empty=True)
#VU.add_library("uar_t").add_source_files(p.resolve() / "hardware/interfaces/uart/tb/*.sv")

VU.main()
