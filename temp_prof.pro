PRO temp_prof, alts, ranges,temps, prof, initial

;PROOF OF CONCEPT - testing an idea
;A process to generate a number of potential temperature profiles
;to be fitted to HiTIES spectra and model volume emissions profiles. 


;IMPORTING MSIS T PROFILE FROM 27/01/2017- 20:45 UT


;Inputs:
;   alts: (array) -  5 element array of the alt. you want to vary T at (WiP)
;   ranges: (array) - 5 element array of range of T respective to element in alts.

;Outputs:
;   prof: (2d array) - array of output profiles in X



initial = fltarr(2,n_elements(alts))


initial[0,*] = alts
initial[1,*] = temps


;array to store all the generated T profiles
prof = fltarr(100000000,5)

;nested loops seems like a pretty easy way to do this for now..... (god help me)

;arbitary dynamic range the temperature can vary over at each alitutde.
;might be a bit large - can be adjusted later

kmr_1 = ranges[0]
kmr_2 = ranges[1]
kmr_3 = ranges[2]
kmr_4 = ranges[3]
kmr_5 = ranges[4]

; profile number
N = 0.0



;DISCLAIMER - this is probably the dumbest way to make this work.... but it works.

for i=0, kmr_1, 10 do begin
 for j=0, kmr_2, 10 do begin
  for k=0, kmr_3, 50 do begin
   for l=0, kmr_4, 50 do begin
    for m=0, kmr_5, 100 do begin
    	prof[N,0] = (initial[1,0] - kmr_1/2.0) + i
	prof[N,1] = (initial[1,1] - kmr_2/2.0) + j
	prof[N,2] = (initial[1,2] - kmr_3/2.0) + k
	prof[N,3] = (initial[1,3] - kmr_4/2.0) + l
	prof[N,4] = (initial[1,4] - kmr_5/2.0) + m
    	N = N + 1.0
    endfor
   endfor
  endfor
 endfor

endfor



prof = prof(0:N-1,*)

;removing cases where temp at alt 200km is more than 200K less than temp at 150km
;and same again between 150 and 125km


index1 = where(prof[*,4] ge (prof[*,3] - 200.0), s)
prof = prof[index1,*]

;index2 = where(prof[*,3] ge (prof[*,2] - 200.0), d)
;prof = prof[index2,*]


;Duplicate checking code
;c=0
;
;for q=0, N-1, 1 do begin
;    for w=0, N-1,1 do begin
;    	if q ne w then begin
;    	    Check = prof(w,*)
;    	    Result = ARRAY_EQUAL(Check, prof(q,*))
;    	    if result eq 1 then c = c+1
;	endif
;    endfor
;    ;print, q
;endfor
;
;print, 'c: ', c

;plot, initial[1,*], initial[0,*], xran=[0,1200], yran=[alts[0] -5, alts[-1]+5], PSYM=4, SYMSIZE=10

;for p=0, N-1,1 do oplot, prof[p,*], initial[0,*]  ;, PSYM=2

END
