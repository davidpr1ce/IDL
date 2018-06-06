PRO read_syntdavid_n2, wl, file=file, force=force, PWV=PWV
;
; To read an IDL save file with N2 synthetic spectra produced by Olli.
; The wavelength is interpolated on to the HiTIES wavelength grid, which
; should be passed in the wl input, in Angstroms.
;
; Modified by JMC:
; 8 Dec 2017: corrected error in determining whether PWV_abs had been previously defined
;             (keyword_set was used instead of n_elements, resulting in incorrect behaviour when PWV_abs=0)
;
; NB/. currently trying to wrap my head around this so I cana adjust it for my needs, comments are so I don't
; lose my place overnight - djp3g13, 15/05/2017

common N2synth, N2_temps, N2_spectra, N2_wl, N2_file, PWV_abs

if not(keyword_set(PWV)) then PWV=0.
if n_elements(PWV_abs) eq 0 then PWV_abs=PWV

if (keyword_set(N2_file)) then if ((file eq N2_file) and array_equal(wl, N2_wl) and not(keyword_set(force)) and (PWV eq PWV_abs)) then return

restore,file=file



;I want N2spec to simply be 2-d array for each temperature profile -   Ie. N2spec = (n_elements(wl), n_elements(PWVarr)
;so that it is an array of spectra generated with the current temperature profile, but with differing PWV values.



if (n_elements(instru_grid) gt 1) then begin
 ; It's a new-style file
 lambda = instru_grid
 if keyword_set(lamint) then begin
 	conv_lines = transpose(lamint)
 	temps = temture
 endif else begin
 	temps = T
 	conv_lines = dblarr(n_elements(instru_grid),n_elements(T))
	for idxT=0,n_elements(T)-1 do begin
		for idxwl=0,n_elements(instru_grid)-1 do begin
			conv_lines[idxwl,idxT] = interpol(N2spec(*,idxT,idxwl),PWVarr,PWV)
			;conv_lines is a 2d spectra with wl in X and temperature in Y
			;these spectra have had the absorption factor applied in the above interpolation
			;spectra = conv_lines[*,#] where # is the temp index 
			;suggests that N2file includes the absorption coefficient? already calculated?
		endfor
	endfor
 endelse
endif

if (mean(lambda) lt 2000) then lambda*=10.0 ; Convert to A

N2_temps=temps

N2_spectra=dblarr(n_elements(wl),n_elements(N2_temps))

;NB. 'wl' is the input wavelength grid
;this just interpolates the wavelength onto the Hities grid
for i=0,n_elements(N2_temps)-1 do N2_spectra[*,i]=interpol(reform(conv_lines[*,i]),lambda,wl)

N2_file=file
N2_wl=wl

PWV_abs = PWV

end
