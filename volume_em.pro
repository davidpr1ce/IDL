PRO volume_em, save=save

;procedure to plot the N2 volume emission profile
;need to figure out which index is N2_6730

read_em, 'emissions.dat'

common emissions, em, br, alt, times, name_ems

if keyword_set(save) then set_plot, 'ps'

help, em

n2 = reform(em(*,3,*))

plot, n2(10,*), alt, yrange=[80,150], $
	XTITLE= 'N2 (673.0nm) Volume Emission Rate (photons m!E-3!N s!E-1!N)', YTITLE='Altitude (km)', $
	CHARSIZE=1.4, xrange=[1e7,6e8], /xlog, THICK=3.0, TICKLEN=0.03
	

help,n2

END
