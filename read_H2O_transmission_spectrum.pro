PRO read_H2O_transmission_spectrum, file=file
;
; Reads an ascii table with the full H2O transmission spectrum
;

common H2Otransspec, H2O_wl, PWV, H2O_transmission, H2O_file

if (keyword_set(H2O_file)) then if (file eq H2O_file) then return

; Creates following waviables: PWV (grid of precipitable water vapour [mm])
;                            H2O_wl (wavelengths of the emission lines at which transmission is given [nm]) 
;                            H2O_transmission (2D array of transmissions as a function of (PWV,H2O_wl))

data = read_table(file,head=1,/double)
H2O_wl = data[0,*]
nb_pwv = n_elements(data[*,0])
nb_wl = n_elements(data[0,*])
H2O_transmission = data[1:nb_pwv-1,*]
;cols=indgen(101)+2
cols=indgen(21)+2
;cols=indgen(11)+2
PWV = float(read_table(file,columns=cols,nrows=1,/text))
H2O_file=file

end
