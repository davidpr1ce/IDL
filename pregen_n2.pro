PRO pregen_n2, Ts, minwl, maxwl, N2_i, N2_w
;
; Pre-calculates the N2 synthetic spectra for temperatures given in Ts, and
; puts these in a common block. Then returns N2_i and N2_w.
; If the pre-calculation has already been done, just returns N2_i and N2_w from
; the common block.
;

common pregen_n2_cmn, n2s_Ts, n2s_minwl, n2s_maxwl, n2s_N2_i, n2s_N2_w

if (n_elements(n2s_Ts) gt 0) then if (array_equal(Ts,n2s_Ts) and minwl eq n2s_minwl and maxwl eq n2s_maxwl) then begin
 N2_i=n2s_N2_i
 N2_w=n2s_N2_w
 return
endif

nT=n_elements(Ts)
print,"Generating N2 spectra for "+string(nT,form='(i0)')+" temperatures..."
N2_i=dblarr(nT,7000)*!values.F_NaN
N2_w=N2_i
mc=0
for i=0,nT-1 do begin
 prog_n2_1p_v2_exp,90d,Ts[i],_N2_i,_N2_w,minwl,maxwl
 s=where(_N2_w gt minwl and _N2_w lt maxwl,c)
 N2_i[i,0:c-1]=_N2_i[s]
 N2_w[i,0:c-1]=_N2_w[s]
 if c gt mc then mc=c
endfor
N2_i=N2_i[*,0:mc]
N2_w=N2_w[*,0:mc]
n2s_Ts=Ts
n2s_minwl=minwl
n2s_maxwl=maxwl
n2s_N2_i=N2_i
n2s_N2_w=N2_w
print,"...done."

end
