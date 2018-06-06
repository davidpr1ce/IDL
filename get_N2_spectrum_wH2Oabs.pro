pro get_N2_spectrum_wH2Oabs,PWV,TN2,instru_grid, $
    	    	IN2_H2Oabs_colv,wlN2,IN2_H2Oabs, $
		noconvolve=noconvolve
		
;pro get_N2_spectrum_wH2Oabs,PWV,TN2,wlair,transH2O,wlN2,IN2,all_N21P_w, all_N21P_i,instru_grid,IN2_colv,IN2_H2Oabs_colv


; Constants
c = 299792458D ; [m/s]
k = 1.380648d-23 ; [J/K]
amu = 1.660539d-27 ; atmoic mass unit [kg]
sqrtpi = sqrt(!pi)
M_N2 = 14.0067*2*amu ; mass of N2 molecule [kg]

; Load H2O transmission spectrum
;H2Ofile='$WKDIR/H2Otrans_vs_wlair_PWV10mm.dat'
;readcol,H2Ofile,wlair,transH2O,skipline=1

;H2Ospecfile='H2Otrans_vs_wlair_rangePWV0_10mm.dat'
;H2Ospecfile='H2OTransmission_OH9451wavelengths.dat'
H2Ospecfile='H2Otrans_vs_wlair.dat'

read_H2O_transmission_spectrum, file='~/Documents/H2Otrans_vs_wlair.dat'
common H2Otransspec, H2O_wl, PWVarr, H2O_transmission, H2O_file

nb_pwv = n_elements(H2O_transmission[*,0])
nb_wl = n_elements(H2O_transmission[0,*])

transH2O = dblarr(nb_wl)
for idx=0,nb_wl-1 do begin
	transH2O[idx] = interpol(H2O_transmission(*,idx),PWVarr,PWV)
endfor
wlair = transpose(H2O_wl)


wlair=reverse(wlair)
transH2O=reverse(transH2O)

wlair*=10 ;convert to A



; Load N2 lines
lines = 200.
minw = 7250.   ;7260(old values)   ;Plot range min  [A]
maxw = 7450.   ;7415	    	   ;Plot range max  [A]

prog_N2_1P_v2_exp, lines, TN2, all_N21P_i, all_N21P_w,minw,maxw

N_N2lines = n_elements(all_N21P_w)
all_i=dblarr(N_N2lines)
all_w=dblarr(N_N2lines)
all_i(0:N_N2lines-1) = all_N21P_i
all_w(0:N_N2lines-1) = all_N21P_w

wlN2 = wlair ;double(indgen(((maxw+10)-(minw-10))*500)/500.)+minw-10
N_N2 = n_elements(wlN2)
IN2 = dblarr(N_N2)

U = sqrt(2*k*TN2/M_N2)

for idxlines=0,N_N2lines-1 do begin
	
	;print,idxlines+1,'/',N_N2lines
	;nu0 = c/(all_w[idxlines]*1d-10)
	one_over_lam0 = 1./all_w[idxlines]
	;print,'lam0=',all_w[idxlines]

	fwhm = 7.16d-7*all_w[idxlines]*sqrt(TN2/28.)
	locmin = value_locate(wlN2,all_w[idxlines]-5*fwhm)
	locmax = value_locate(wlN2,all_w[idxlines]+5*fwhm)
	;print,'fwhm=',fwhm,'A'
	;print,'locmin-max',locmin,'-',locmax
	;print,'wl(locmin-locmax)',wlN2(locmin),'-',wlN2(locmax)
	;print,'IN2max=',all_i[idxlines]*all_w[idxlines]*1d-10/(U*sqrtpi)
	;print,' '

    	
	for idxwl=locmin,locmax do begin
		one_over_lam = 1./wlN2[idxwl]
		IN2[idxwl]+=all_i[idxlines]*all_w[idxlines]*1d-10/(U*sqrtpi)*exp(-c^2/U^2*((one_over_lam-one_over_lam0)/one_over_lam0)^2)
	endfor

endfor



IN2_H2Oabs = IN2*transH2O

; Convolve to instrument
instrument_function = 0.6 ;HWHM
grid = 0.1 ; [A]
instru_grid=minw+lindgen((maxw-minw)/grid)*grid   ;I commented this out to stop it redefining wl_p?


if ~(keyword_set(noconvolve)) then begin
    convolve_sp,wlN2,IN2,instrument_function,instru_grid,IN2_colv
    convolve_sp,wlN2,IN2_H2Oabs,instrument_function,instru_grid,IN2_H2Oabs_colv
endif

end
