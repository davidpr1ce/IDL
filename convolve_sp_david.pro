pro convolve_sp_david, w_in,s_in,width,w_out,s_out, triangular=triangular
;
; does the convolution of a line spectrum with Gaussian profile - a better way
; 
;  Input:  
;      w_in     - wavelengths of the line spectrum to be convolved
;      s_in     - intensities of the lines
;      width    - half-width and half-maximum of the gaussian
;      w_out    - wavelength of the instrument grid to be convolved onto
;
;  Output:
;      s_out    - brightnesses (per unit wavelength) on the grid
;
; Keyword triangular makes it use a triangular function instead of a gaussian.
;
n=n_elements(w_out)-1
l1=0.5*(w_out+shift(w_out,1))
l2=0.5*(w_out+shift(w_out,-1))
l1(0) =1.5*w_out(0)-0.5*w_out(1)
l2(n) =1.5*w_out(n)-0.5*w_out(n-1)
s_out=dblarr(n_elements(w_out))
for i=0l,n_elements(w_out)-1 do begin
 if keyword_set(triangular) then begin
  ddd=where(abs(w_in - w_out(i)) lt 4.*width, count)
  if (count gt 0) then begin
   for j=0,count-1 do begin
    s_out(i)=s_out(i) + $
    s_in(ddd(j))*(triint( (l2(i)-w_in(ddd(j)))/width) - triint( (l1(i)-w_in(ddd(j)))/width))
   endfor
   s_out(i)=s_out(i)/(l2(i)-l1(i))
  endif
 endif else begin
  ddd=where(abs(w_in - w_out(i)) lt 4.*width, count)
  if (count gt 0) then begin
   ;for j=0,count-1 do begin
  s_out(i)=s_out(i) + total(s_in(ddd)*(gaussint( (l2(i)-w_in(ddd))/width) - gaussint( (l1(i)-w_in(ddd))/width)))
   ;endfor
  s_out(i)=s_out(i)/(l2(i)-l1(i))
  endif
 endelse
endfor
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
