#!/bin/env python3
import sys
import pefile
import io

def hexdump(data):
	f = io.BytesIO(data)
	n=0
	b = f.read(0x10)
	while b:
		s1 = " ".join([f"{i:02x}" for i in b])
		s1 = s1[0:23] + " " + s1[23:]
		s2 = "".join([chr(i) if 32 <= i <= 127 else "." for i in b]) 
		print(f"{n * 16:08x}  {s1:<48}  |{s2}|")
		n += 1
		b = f.read(0x10)

def extract_shellcode(exe):
    try:
        pe = pefile.PE(exe)
    except:
        print(f"[+] Error opening or parsing: {exe}")
        exit(1)

    data = b""
    data_size = 0
    basevaddr = 0
    found = False
    for section in pe.sections:
        if section.Name.strip(b"\x00").lower() == b".scode":
            data = section.get_data()
            basevaddr = section.VirtualAddress
            data_size = section.Misc_VirtualSize
            found = True
            break

    if not found:
        print(f"[+] .scode section not found in {exe}")
        exit(1)

    print(f"[+] Found .scode section at 0x{basevaddr:08x} with size 0x{data_size:08x}")
    print(f"[+] ")
    print(f"[+] Shellcode:")
    hexdump(data)
    print(f"[+] ")
    print(f"[+] Writing shellcode to shellcode.bin")
    with open("shellcode.bin", "wb") as f:
        f.write(data)
    print(f"[+] Done")



if __name__ == "__main__":
    exe = sys.argv[1]
    print(f"[+] ")
    print(f"[+] Extracting shellcode from {exe}")
    extract_shellcode(exe)