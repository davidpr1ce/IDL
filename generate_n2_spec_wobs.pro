PRO generate_n2_spec_wobs

;  .r read_H2O_transmission_spectrum
;  .r get_N2_spectrum_wH2Oabs
;  .r prog_n2_1p_v2_exp
;  .r read_table



tt_mjs, 2017, 01, 27, 20, 50, 00, 00, mjs
get_w, mjs, 2, wl_p

Trange = findgen(1270) + 50   ;integer steps of temp from 50 to 1319 - covering entire range of temp prof.
Trange = DOUBLE(Trange)

N_i = fltarr(n_elements(Trange), 37984)

for idt=0, n_elements(Trange)-1 do begin
    get_N2_spectrum_wH2Oabs, 0, Trange[idt], wl_p, convolved, wln2, int2_h2oabs, /noconvolve
    N_i[idt, *] =(int2_h2oabs)
print, idt
endfor



save, wln2, N_i, filename='N2spectra_wobs_zero_newranges.sav'

END

