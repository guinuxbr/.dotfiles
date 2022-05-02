" Enable line numbers
set number

" Display bottom status line
set laststatus=2

" Configure the information for status line
set statusline=
set statusline=%f\ -\ Type:\ %y " File name and format
set statusline+=\%=     " Switch to right side
set statusline+=\ Line:\%l\ Column:\%c " Line number:Column number
set statusline+=\ %p%%  " Percentage through file
set statusline+=\ TL:\%L      " Total lines
set statusline+=\ %{&fileencoding?&fileencoding:&encoding} " File encoding
set statusline+=\[%{&fileformat}\] " File encoding
set statusline+=\ 