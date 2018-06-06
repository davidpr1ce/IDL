PRO profile_plot, radardata=radardata, warmup=warmup

;A quick routine to compare model data to radar data
;Input:
;	radardata: string name of the .sav file containing the radar data
;	warmup: set this keyword (eg. 5.0) to remove warmup period (s) from the model data 



;Reading the model data from the current directory

icr, 'densities.dat'
common icr
model_data = dat

timestep = time[0]

;Restoring the radardata (must be saved first)

if keyword_set(radardata) then begin
    restore, radardata
endif else begin
    restore, '~/ion_chem/radar_data_halfsec.sav'
endelse

;restore, radardata
radar_data = data

h_ax = reform(dat(0,0,*))/1e5   ;sets the model height axis


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;MODEL;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

model_data = reform(model_data(1,*,*))

help, model_data
help, radar_data

print, 'Removing warmup period from model data'

model_data = model_data(warmup*2:-1,*)

help, model_data
help, radar_data

;;;;;;;;;;;;;;;;;;;;;;;;;;;;PLOTTING;;;;;;;;;;;;;;;;;;;;;;;;;;;

loadct, 39

!p.position=0

plots = n_elements(radar_data(*,0)) -1   ;the number of plots to cycle through
pos = 0  ;sets the initial position through the plots


window,1,xsi=800, ysi=800

WHILE pos le plots AND pos ge 0 DO BEGIN
    	mpos = (pos*2) + 1
	print,'Spectrum #: ', mpos, ' Time: ', mpos*(0.5), ' Frame #: ', mpos*16
	erase

	;Model data plot
	plot, model_data(mpos,*), h_ax, $
	 TITLE='Electron Density vs. Altitude', YTITLE='Altitude (km)',$
	  XTITLE= 'Electron Number Density (n/m^3)', YRANGE=[80,180], /ysty, $
	   XRANGE=[5e9,5e12], /xlog, /xsty
	    

	;Radar data plot
	oplot, radar_data(mpos,*), yaxis, PSYM=4
	;Smoothed radar data plot
	oplot, smooth(radar_data(mpos,*),16), yaxis, linestyle=2
	
	cursor, x, y, /DEVICE, WAIT=4, /up
	if x gt 400 then begin
		pos = pos + 1
	endif
	if x lt 400 then begin
		pos = pos -1 
	endif
	
	if x gt 790 then begin
	    	;click far right to end cycle early
	    	pos = plots+1
	endif
    	
	;pos = mpos   ; just so it ends the while neatly instead of error
ENDWHILE




END
