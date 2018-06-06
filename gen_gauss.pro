PRO gen_gauss, X, centre=centre, Y, normalise=normalise, maxwellian=maxwellian, notail=notail, width=width

;Routine to generate a guassian distrabution about a peak energy with a given
;width and constant area!

;Inputs:
;   X = array input of energy range you want the guassian over
;   centre = set this keyword to choose which X value to centre the guassian around
;   normalise = set this keyword to ensure the integral is always 1
;   maxwellian = set this keyword to generate a maxwellian spectrum
;   notail = set this keyword to remove the low energy tail

;Output:
;   Y = array containing guassian distrubition same dimensions as X

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NEED TO CHANGE THIS SO IT GENERATES THE GAUSSIAN IN PARTICLE FLUX SPACE
; CONVERT TO mW/m2 NORMALISE
; DIVIDE PARTICLE FLUX BY NORMALISATION FACTOR
; THEN USE PARTICLE FLUX AS INPUT STILL
; DONE!!!

;Some short hand notation and keyword handling

if keyword_set(centre) then begin
    c = centre
endif

if keyword_set(width) then begin
    w = c*width
endif else w=c*0.05


;w = c*0.05
X = DOUBLE(X)

;Making the Gaussian
Y = EXP(-((X-c)^2/(2*(w^2))))
;Or the maxwellian
if keyword_set(maxwellian) then begin
    Y = SQRT(X) * ((1.0/c)^(3.0/2.0)) * EXP(-(1.0*X/c))
endif

;Low energy tail ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
A1_arr= []

;calculating area underneath Y
for n=1, (n_elements(X)-1) do begin
    NN = (X[n] - X[n-1]) * ((Y[n] + Y[n-1])/2.0)
    A1_arr = [A1_arr, NN]
endfor
A1 = TOTAL(A1_arr)
P=0.30  ;fraction of total flux I want in the guassian peak
A2 = A1*((1./P)-1)  ;area of the lowE tail needed in order to maintain above condition

;Generating the tail


Ylow =  EXP(-((2.*X)))


;normalising it so it contains the desired amount of the total flux
;seems to work but I dont trust int_tabulated as usual

A2_arr=[]

;calculating area underneat Ylow
for m=1, (n_elements(X)-1) do begin
    MM = (X[m] - X[m-1]) * ((Ylow[m] + Ylow[m-1])/2.0)
    A2_arr = [A2_arr, MM]
endfor

Aylow = TOTAL(A2_arr)
;adjusting area under A2 to account for this
Z = A2/Aylow ; difference in current area and desired area
Ylow = Ylow * Z

Y = Y/Z   ;PROBABLY NEED TO REMOVE THIS AS IT DOESNT MAKE PHYSICAL SENSE- I THINK IT WILL MAKE TOTAL FLUX TOO SMALL



;trying something new for the lowE tail of a maxwellian
if keyword_set(maxwellian) then begin
    Ylow = fltarr(n_elements(Y))
    pind = where(Y eq max(Y))
    Ylow[0:pind] = max(Y) - Y[0:pind]
endif

window,0
plot,Ylow
oplot,Y
oplot, Y + Ylow, PSYM=4

;Combining Y and Ylow
Y = Y + Ylow
Ym = (Y*X) / 6.242e11



A=[]
;normalising in mW/m2 so that the area underneath the curve is always equal to one!
;Once this normalisation factor has been found it is applied to the particle flux guassian!

if keyword_set(normalise) then begin
    integral = int_tabulated(X, Ym)
    ;print, 'tabulated :', integral
    
    ;Writing my own damn (shitty) integration becuase int_tabulated sucks
    for i=1, (n_elements(X)-1) do begin
    	AA = (X[i] - X[i-1]) * ((Ym[i] + Ym[i-1])/2.0)
	A = [A, AA]
    endfor
    
    ;This very simply integration method (above) proves much more consistant!!!
    
    tot = TOTAL(A)

    
    Y = Y/(tot)
endif

s = where(Y lt 1d-50,d)
if d gt 0 then Y[s] = 0 



;plot,X, Y, /ylog

;print,'Tail Height: ', max(Y[0:10])
;print,'Peak Height: ', max(Y[200:-1])

END
