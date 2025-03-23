.386
.model flat, stdcall
option casemap:none

; Include headers
include \masm32\include\windows.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc
include \masm32\include\gdi32.inc

; Include libraries
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib

; Constants
.DATA
hInstance dd 0                     ; Instance handle
hWnd dd 0                          ; Handle to the window
msg MSG <>                         ; Message structure
wc WINDCLASS <0>
className db "SimpleWindowClass", 0      ; Window class name
windowTitle db "Simple GUI Application", 0 ; Window title

.CODE

start:
    ; Get the instance handle
    invoke GetModuleHandle, NULL
    mov hInstance, eax

    ; Fill the WNDCLASS structure
    mov wc.style, CS_HREDRAW or CS_VREDRAW
    mov wc.lpfnWndProc, offset WndProc
    mov wc.cbClsExtra, 0
    mov wc.cbWndExtra, 0
    mov wc.hInstance, hInstance
    invoke LoadIcon, NULL, IDI_APPLICATION
    mov wc.hIcon, eax
    invoke LoadCursor, NULL, IDC_ARROW
    mov wc.hCursor, eax
    mov wc.hbrBackground, COLOR_WINDOW+1
    mov wc.lpszMenuName, NULL
    mov wc.lpszClassName, offset className

    ; Register the window class
    invoke RegisterClass, offset wc

    ; Create the window
    invoke CreateWindowEx, 0, offset className, offset windowTitle, WS_OVERLAPPEDWINDOW,
                            CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                            NULL, NULL, hInstance, NULL
    mov hWnd, eax

    ; Show and update the window
    invoke ShowWindow, hWnd, SW_SHOWNORMAL
    invoke UpdateWindow, hWnd

    ; Message loop
msg_loop:
    invoke GetMessage, offset msg, NULL, 0, 0
    test eax, eax
    jz end_program

    invoke TranslateMessage, offset msg
    invoke DispatchMessage, offset msg
    jmp msg_loop

end_program:
    invoke ExitProcess, 0

WndProc PROC hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
    .IF uMsg == WM_DESTROY
        invoke PostQuitMessage, 0
    .ELSE
        invoke DefWindowProc, hWnd, uMsg, wParam, lParam
        ret
    .ENDIF
    xor eax, eax
    ret
WndProc ENDP

END start
