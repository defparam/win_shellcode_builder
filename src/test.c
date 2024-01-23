#include <Windows.h>

typedef HMODULE (__stdcall *t_LoadLibraryA)(LPCSTR);
typedef FARPROC (__stdcall *t_GetProcAddress)(HMODULE, LPCSTR);
typedef int (__stdcall *t_MessageBoxA)(void*, const char*, const char*, int);
typedef DWORD (__stdcall *t_GetTicketCount)(void);

#pragma data_seg(".SDATA")

// These will be invalid. Figure out a way to obtain the correct pointers (i.e IAT, etc)
t_LoadLibraryA oLoadLibraryA = (t_LoadLibraryA)0x7FFF1FE28B30;
t_GetProcAddress oGetProcAddress = (t_GetProcAddress)0x7FFF20E7AEC0;

char szCaption0[] = "An Important Message!";
char szText0[] = "Hello, world!";
char szCaption1[] = "Urgent!";
char szText1[] = "Greetings!";
char kernBase[] = "kernelbase.dll";
char user32[] = "user32.dll";
char getTick[] = "GetTickCount";
char msgBox[] = "MessageBoxA";

#pragma code_seg(".SCODE")

void shellcode()
{
    t_GetTicketCount oGetTicketCount = (t_GetTicketCount)oGetProcAddress(oLoadLibraryA(kernBase), getTick);
    t_MessageBoxA oMessageBoxA = (t_MessageBoxA)oGetProcAddress(oLoadLibraryA(user32), msgBox);

    if (oGetTicketCount() % 2 == 0)
        oMessageBoxA(0, szText0, szCaption0, 0);
    else
        oMessageBoxA(0, szText1, szCaption1, 0);
}

#pragma code_seg(".text")
void main(void){ shellcode(); }