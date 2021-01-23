from pathlib import Path
from vunit.verilog import VUnit

VU = VUnit.from_argv()
p = Path(__file__).parent
print(p)
lib = VU.add_library("lib")
lib.add_source_files(p / "example/*.sv", allow_empty=True)
lib.add_source_files(p / "hardware/buffer/srcs/*.sv", allow_empty=True)
lib.add_source_files(p / "hardware/core/*.sv", allow_empty=True)
lib.add_source_files(p / "hardware/interfaces/uart/srcs/*.sv", allow_empty=True)

VU.main()
