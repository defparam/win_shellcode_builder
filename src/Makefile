CC=clang-cl
LD=lld-link

CFLAGS= -Xclang -fno-jump-tables -fno-stack-protector -I"/xwin/sdk/include/um" \
-I"/xwin/sdk/include/shared" \
-I"/xwin/sdk/include/winrt" \
-I"/xwin/sdk/include/ucrt" \
-I"/xwin/crt/include"

LDFLAGS=/libpath:"/xwin/sdk/lib/um/x86_64/" \
/libpath:"/xwin/sdk/lib/ucrt/x86_64/" \
/libpath:"/xwin/crt/lib/x86_64/" \
/DYNAMICBASE:NO \
/MAP \
/MERGE:.SDATA=.SCODE

# Name of your executable
TARGET=test.exe

# List your source files here
SOURCES=test.c

# Generate object file names from source file names
OBJECTS=$(SOURCES:.c=.obj)

all: $(TARGET)
	/usr/bin/python3 /src/extract_shellcode.py $(TARGET)

$(TARGET): $(OBJECTS)
	$(LD) $(LDFLAGS) /out:$@ $(OBJECTS)

%.obj: %.c
	$(CC) $(CFLAGS) -c $< -Fo$@

clean:
	rm -f $(TARGET) $(OBJECTS)

.PHONY: all clean
