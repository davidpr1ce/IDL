PRO input_gauss, X, energy, flux, Y, filename, maxwellian=maxwellian, bin=bin, warmup=warmup, final=final, width=width

;Routine to generate guassian external input spectra for given energy/flux arrays.

;Inputs:
;   X: (array) - energy space you want the guassian to be defined over
;   energy: (array) - energies for the central peak of the guassians
;   flux: (array) - fluxes (i.e. the value of the integral of the guassian)
;   filename: (string) - name of the input.dat file you want to save the data to
;   maxwellian: (keyword) - set this to generate a maxwellian input
;   bin: (keyword) - set this to apply half-sec smoothing to the energy and flux data (to match radar)
;   final: (keyword) - set this to produce a final input for the 2017 event (hopefully)
;   warmup: (keyword) - set this to a float value of seconds to use as a warmup period in the model




if keyword_set(bin) then begin
    flux = smooth(flux,16, /edge_mirror)
    energy = smooth(energy,16, /edge_mirror)
    
    rebin_f = float(n_elements(energy)) / 16.   ;half second (16 frames) resolution
    print, rebin_f
    
    energy = rebin(energy, rebin_f)
    flux = rebin(flux, rebin_f)
endif




nn = n_elements(energy)
xx = n_elements(X)

;Y = fltarr(xx,nn)

X=DOUBLE(X) ; making the domain double precision

; open file for writing
openw, lun, filename, /get_lun

Zs = fltarr(300)

;printing top rows
printf, lun, xx, FORMAT='(I3)'
printf, lun, X, FORMAT='(300E11.3)'
;printf, lun, Zs, FORMAT='(300E11.3)'   ;prints a line of zeros - this is because the model starts at 0s and the 
    	    	    	    	       ;data starts at 0.5s


if keyword_set(warmup) then begin
    t = warmup
    ienergy = energy[0]/2.0	    	;was unchanged
    iflux = flux[0]/1.5 	    	    	;was /3.0
    tstep = 0.5
    nsteps = t/tstep
    estep = ienergy/nsteps
    wenergy = estep
    
    print, 'Printing warmup spectra:'
    print, 'Total time: ', t
    print, 'Time step: ', tstep
    print, 'Number of spectra: ', nsteps
    print, 'Energy Step: ', estep
    print, 'Final Energy: ', estep*(nsteps)
    print, 'Flux used: ', iflux
    
    for w=0, nsteps -1 , 1 do begin
    	;made the warmup spectrum maxwellian, see what this does
    	gen_gauss, X, centre=wenergy, Y, /normalise, /maxwellian, width=width
    	Yw = Y * iflux
	printf, lun, Yw, FORMAT='(300E11.3)'
	wenergy = wenergy + estep
    endfor
endif
    


;loop through the elements in energy and flux arrays

for i =0, nn-1 do begin
    c = energy[i]    ;defining the centre of the guassian to be drawn
    f = flux[i]   ;
    fi = f
    ci = c
    
    if	i le 10 then begin       ;this causes anomolous peaks if the condition is too high i- it should be during low E period only!!
    	    c = c/3.2	    	
	    f= f*1.0	    	 ;new attempt
    	    gen_gauss, X, centre=c, Y, /normalise, /maxwellian, width=width
    endif else begin
    
    c = energy[i]    ;defining the centre of the guassian to be drawn
    f = flux[i]   ;
    fi = f
    ci = c
    
    ;managing inidividual adjustments
    if keyword_set(final) AND i eq 20 then f=1.5*f 
    if keyword_set(final) AND i eq 21 then f=1.5*f 
    
    if keyword_set(final) AND i eq 22 then f=1.5*f 
    if keyword_set(final) AND i eq 23 then f=1.5*f 
    
    if keyword_set(final) AND i eq 24 then f=1.5*f
    if keyword_set(final) AND i eq 24 then c=0.8*c
    if keyword_set(final) AND i eq 25 then f=1.5*f 
    if keyword_set(final) AND i eq 25 then c=0.8*c
    
    
    if keyword_set(final) AND i eq 26 then f=1.2*f  
    if keyword_set(final) AND i eq 26 then c=0.8*c
    if keyword_set(final) AND i eq 27 then f=1.2*f 
    if keyword_set(final) AND i eq 27 then c=0.8*c


    if keyword_set(final) AND i eq 28 then f=1.2*f 
    if keyword_set(final) AND i eq 28 then c=0.8*c
    if keyword_set(final) AND i eq 29 then f=1.2*f 
    if keyword_set(final) AND i eq 29 then c=0.8*c
    
    ;gen gauss
    gen_gauss, X, centre=c, Y, /normalise, width=width    

   
    endelse
    
    
    print,'i: ', i, ' flux factor: ', f/fi, ' energy factor: ', c/ci

    YY = Y * f  
    printf, lun, YY, FORMAT='(300E11.3)'
    
endfor

close, lun

END



    

