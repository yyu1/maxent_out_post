PRO fill_flt, file1, file2, outfile
	;get file sizes
	file1_info = file_info(file1)
	file2_info = file_info(file2)

	;make sure sizes are the same
	file1_size = file1_info.size
	file2_size = file2_info.size

	if file1_size ne file2_size then begin
		print, 'File sizes do not match, exiting...'
		exit
	endif

	nblocks = file1_size/4/1000
	remainder = file1_size mod 4000LL

	block1 = fltarr(nblocks)
	block2 = fltarr(nblocks)

	openr, lun1, file1, /get_lun
	openr, lun2, file2, /get_lun
	openw, outlun, outfile, /get_lun

	for i=0ULL, 998 do begin
		print, i
		readu, lun1, block1
		readu, lun2, block2
		index = where((block1 eq 0) and (block2 gt 0), count)

		if (count gt 0) then block1[index] = block2[index]

		writeu, outlun, block1
	endfor

	if (remainder ne 0) then begin
		block1 = fltarr(remainder/4)
		block2 = fltarr(remainder/4)
		readu, lun1, block1
		readu, lun2, block2
		index = where((block1 eq 0) and (block2 gt 0), count)
		if (count gt 0) then block1[index] = block2[index]
		writeu, outlun, block1
	endif else begin
		print, i
		readu, lun1, block1
		readu, lun2, block2
		index = where((block1 eq 0) and (block2 gt 0), count)

		if (count gt 0) then block1[index] = block2[index]

		writeu, outlun, block1
	endelse
		

	free_lun, lun1
	free_lun, lun2
	close, outlun

End
