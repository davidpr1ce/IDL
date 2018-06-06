Forward_Function alter,nuva2leai,Pi3F1,Pi3F2,Pi3F3,Sigma3F1,Sigma3F2,Sigma3F3,njp

pro prog_N2_1P_v2_exp,lines,temp,all_N2_i,all_N2_w,minw,maxw

;MAIN INPUTS

                 v1_1 = 0.      ;V'  First vibrational level [ v' = 0...12]
                 v1_2 = 12.     ;V'   Last vibrational level [ v' = 0...12]
                 v2_1 = 0.      ;V'' First vibrational level [ v''= 0...12]
                 v2_2 = 12.     ;V''  Last vibrational level [ v''= 0...12]

;READ DATA OF VIBRATIONAL LEVELS
N2_vib1, N21P_vib_ints 

;MODEL OUTPUT FILE
all_N2_w=dblarr(lines*27,13,13)
all_N2_i=dblarr(lines*27,13,13)

;if (v1_2-v1_1+1. gt 2) or (v2_2-v2_1+1. gt 2) then $
; print, string((v1_2-v1_1+1.)*(v2_2-v2_1+1.), form='("   Calculating ",i3.0," N2  1P bands...")')

;DEFINE  V' AND V'' LOOP [v' = 0...12] [ v''= 0...12]
for v1= v1_1,v1_2 do begin  ;Upper B-State vibrational band
for v2= v2_1,v2_2 do begin  ;Lower A-State vibrational band

;WORK OUT SPECTRA
N2_1Pd,v1,v2,lines,temp,P1,P2,P3,R1,R2,R3,Q1,Q2,Q3,OP12,QR12,PQ12,PR13,OQ13,NP13,SR21,RQ21,QP21,QR23,PQ23,OP23,TR31,SQ31,RP31,SR32,RQ32,QP32,P1_i,P2_i,P3_i,R1_i,R2_i,R3_i,Q1_i,Q2_i,Q3_i,OP12_i,QR12_i,PQ12_i,PR13_i,OQ13_i,NP13_i,SR21_i,RQ21_i,QP21_i,QR23_i,PQ23_i,OP23_i,TR31_i,SQ31_i,RP31_i,SR32_i,RQ32_i,QP32_i

;minw=minw2;7360
;maxw=maxw2;7430
;max_int=max(Q1_i)*1.1
;re=50
;rf=250 ;2nd set of satellites
;rg=150

;GROUPING==============================
group_all4,lines,P1,P2,P3,R1,R2,R3,Q1,Q2,Q3,OP12,QR12,PQ12,PR13,OQ13,NP13,SR21,RQ21,QP21,QR23,PQ23,OP23,TR31,SQ31,RP31,SR32,RQ32,QP32,P1_i,P2_i,P3_i,R1_i,R2_i,R3_i,Q1_i,Q2_i,Q3_i,OP12_i,QR12_i,PQ12_i,PR13_i,OQ13_i,NP13_i,SR21_i,RQ21_i,QP21_i,QR23_i,PQ23_i,OP23_i,TR31_i,SQ31_i,RP31_i,SR32_i,RQ32_i,QP32_i, group_w, group_i

all_N2_w(*,v1,v2)=group_w
all_N2_i(*,v1,v2)=group_i*N21P_vib_ints(v2,v1)

endfor     ;end of lower state v''
endfor     ;end of higher state v'

;window, 5,xsize=1200,ysize=800
;a_max=where(instru_grid ge minw2 and instru_grid le maxw2)

;                                               USE 127. for individual branch plots, 7 locations instead of max(int_colv)
;                                                      max(int_colv)*1.05
;plot,fltarr(2),xstyle=1,xrange=[minw,maxw],yrange=[0,105],ystyle=1
;oplot,instru_grid,int_colv
;wcurves,  max(int_colv)
;Dieke,dS32,dT31,dS21,dR3,dR32,dS31,dR31,dR2,dR1,dR21,dQ3,dQ32,dQ2,dQ21,dQ23,dQ12,dQ1,dP3,dP23,dP2,dO23,dP1,dP12,dP13,dO12,dO13,dN13,unknown, instrument_function, instru_grid

end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro wcurves, scaling   ;PLOT FILTER CURVES and MEASURED SPECTRA

  bkg=8.

  ;VALLANCE SPECTRA
   rd,3,'/net/stpraid1/workdir/opj/put_back_idl/30052006/vallance_N21P.txt', data
   mult=(scaling/max(data(1,*)))*.95
   oplot, data(0,*), data(1,*)*mult, thick = 2,linestyle=2

  ;ASK FILTER CURVES
   array1=[6625 ,6637.5,6650,6662.5,6675,6687.5,6700,6712.5,6725,6737.5,6750, $
           6762.5,6775,6787.5,6800,6812.5,6825,6837.5,6850,6862.5,6875]
   array2=[0.003,0.01  ,0.05,0.20  ,0.56,0.86  ,0.81,0.79  ,0.80,0.84  ,0.86, $
           0.865 ,0.86,0.84  ,0.83,0.76  ,0.37,0.10  ,0.04,0.01  ,0.003]
   mult=(scaling/max(array2))*.95
   oplot,array1,array2*mult, thick=5,color=255,linestyle=1

   array3=[7300,7302.5,7305,7307.5,7310,7312.5,7315,7317.5,7320,7322.5, $
           7325,7327.5,7330,7332.5,7335,7337.5,7340]
   array4=[0.000,0.005,0.01,0.03,0.065,0.185,0.34,0.71,0.78,0.635,0.38,0.125,$
           0.055,0.025,0.01,0.01,0.000]
   mult=(scaling/max(array4))*.95
   oplot,array3,array4*mult, thick=5,color=255,linestyle=1
  ;OTHERS
   ;----------------------------------------------------------------------------
   restore, "for_olli.dat" ;Pre-saved HITIES PROFILE
                           ; Spectrum - intensities [205]
                           ; WL - wavelength [205]
   mult=(scaling/(max(spectrum)-bkg))*.95
   oplot, wl,spectrum*mult-bkg,linestyle=0,color=200

   ;----------------------------------------------------------------------------
   restore, "Convolved_lines.idl"  ; SYNTHETIC PROFILES:
                                   ; conv_lines - (intensities,temperature)
                                   ; temps - temperature [K]
                                   ; lambda - wavelength grid
     ;oplot,lambda*10.,conv_lines(*,1)*5000./10.,linestyle=1    
     ;seems to be calibrated to observed profile with wrong wl-calibration
   ;----------------------------------------------------------------------------
 ;  restore, "nitrogen_obs.idl"   ;JOHN'S SPECTRA
 ;  mult=(scaling/max(spectrum))*.95
 ;  color=50
 ;  thick=3

   ;CALIBRATE O+ EVENT:
 ;  center=60
 ;  wl2=wl
 ;  for o=0,60 do wl2(o)=wl(o)   -(o-center)*0.02   -(o-center)^3.*0.00002

   ;CALIBRATE 5 N2 events:
 ;  center=125
 ;  for o=0,n_elements(wl)-1. do wl(o)=wl(o) -1.2   -(o-center)*0.01   -(o-center)^3.*0.0000005
 ;  center=60
 ;  for o=0,60 do wl(o)=wl(o)   -(o-center)*0.04   -(o-center)^3.*0.00001

 ;  oplot, wl2, spectra*6-7.,thick=thick ; O+
     ;;oplot, wl, (spectrae+spectrad+spectrac+spectrab+spectraa-40.)/2., color=color,thick=thick
 ;  oplot, wl, spectraa*9-10., color=color,thick=thick
 ;  oplot, wl, spectrab*1.4-15., color=color,thick=thick
 ;  oplot, wl, spectrac*2.5-15., color=color,thick=thick
 ;  oplot, wl, spectrad*1.5-8., color=color,thick=thick
 ;  oplot, wl, spectrae*3.-5., color=color,thick=thick
 ;   plots, [wl(0),wl(n_elements(wl)-10)],[10,10],thick=thick
    ;;   save,wl,wl2,spectra,spectraa,spectrab,spectrac,spectrad,spectrae,filename='John_event_new_wave_cal.dat'
   ;---------------------------------------------------------------------------
 ;  plots,[7319.2,7319.2],[0,scaling],linestyle=1 ;O+
 ;  plots,[7320.2,7320.2],[0,scaling],linestyle=1 ;O+
 ;  plots,[7329.7,7329.7],[0,scaling],linestyle=1 ;O+
 ;  plots,[7330.7,7330.7],[0,scaling],linestyle=1 ;O+
 ;  ls=5
 ;  cl=150
 ;  plots,[7238.8,7238.8],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7240.2,7240.2],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7241.2,7241.2],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7245.0,7245.0],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7246.6,7246.6],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7253.2,7253.2],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7275.1,7275.1],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7276.4,7276.4],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7284.5,7284.5],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7295.9,7295.9],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7303.8,7303.8],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7316.3,7316.3],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7329.2,7329.2],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7340.9,7340.9],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7358.7,7358.7],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7369.4,7369.4],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7392.2,7392.2],[0,scaling],linestyle=ls,color=cl
 ;  plots,[7401.9,7401.9],[0,scaling],linestyle=ls,color=cl
   ;plots,[7255.8,7255.8],[0,scaling],linestyle=ls,color=cl+100 ;BKG
   ;plots,[7281.6,7281.6],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7292.2,7292.2],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7306.9,7306.9],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7311.1,7311.1],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7344.9,7344.9],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7374.1,7374.1],[0,scaling],linestyle=ls,color=cl+100
   ;plots,[7390.1,7390.1],[0,scaling],linestyle=ls,color=cl+100

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro group_all4,lines,P1,P2,P3,R1,R2,R3,Q1,Q2,Q3,OP12,QR12,PQ12,PR13,OQ13,NP13,SR21,RQ21, $
          QP21,QR23,PQ23,OP23,TR31,SQ31,RP31,SR32,RQ32,QP32,P1_i,P2_i,P3_i,$
          R1_i,R2_i,R3_i,Q1_i,Q2_i,Q3_i,OP12_i,QR12_i,PQ12_i,PR13_i,OQ13_i,$
          NP13_i,SR21_i,RQ21_i,QP21_i,QR23_i,PQ23_i,OP23_i,TR31_i,SQ31_i,  $
          RP31_i,SR32_i,RQ32_i,QP32_i, group_w, group_i
          ;COMBINING ALL BRANCHES TOGETHER
group_w=dblarr(27.*lines)
group_w(0:(1*lines)-1)          =P1
group_w((1*lines):(2*lines)-1)  =P2
group_w((2*lines):(3*lines)-1)  =P3
group_w((3*lines):(4*lines)-1)  =R1
group_w((4*lines):(5*lines)-1)  =R2
group_w((5*lines):(6*lines)-1)  =R3
group_w((6*lines):(7*lines)-1)  =Q1
group_w((7*lines):(8*lines)-1)  =Q2
group_w((8*lines):(9*lines)-1)  =Q3
group_w((9*lines):(10*lines)-1) =OP12
group_w((10*lines):(11*lines)-1)=QR12
group_w((11*lines):(12*lines)-1)=PQ12
group_w((12*lines):(13*lines)-1)=PR13
group_w((13*lines):(14*lines)-1)=OQ13
group_w((14*lines):(15*lines)-1)=NP13
group_w((15*lines):(16*lines)-1)=SR21
group_w((16*lines):(17*lines)-1)=RQ21
group_w((17*lines):(18*lines)-1)=QP21
group_w((18*lines):(19*lines)-1)=QR23
group_w((19*lines):(20*lines)-1)=PQ23
group_w((20*lines):(21*lines)-1)=OP23
group_w((21*lines):(22*lines)-1)=TR31
group_w((22*lines):(23*lines)-1)=SQ31
group_w((23*lines):(24*lines)-1)=RP31
group_w((24*lines):(25*lines)-1)=SR32
group_w((25*lines):(26*lines)-1)=RQ32
group_w((26*lines):(27*lines)-1)=QP32

group_i=dblarr(27.*lines)
group_i(0:(1*lines)-1)          =P1_i
group_i((1*lines):(2*lines)-1)  =P2_i
group_i((2*lines):(3*lines)-1)  =P3_i
group_i((3*lines):(4*lines)-1)  =R1_i
group_i((4*lines):(5*lines)-1)  =R2_i
group_i((5*lines):(6*lines)-1)  =R3_i
group_i((6*lines):(7*lines)-1)  =Q1_i
group_i((7*lines):(8*lines)-1)  =Q2_i
group_i((8*lines):(9*lines)-1)  =Q3_i
group_i((9*lines):(10*lines)-1) =OP12_i
group_i((10*lines):(11*lines)-1)=QR12_i
group_i((11*lines):(12*lines)-1)=PQ12_i
group_i((12*lines):(13*lines)-1)=PR13_i
group_i((13*lines):(14*lines)-1)=OQ13_i
group_i((14*lines):(15*lines)-1)=NP13_i
group_i((15*lines):(16*lines)-1)=SR21_i
group_i((16*lines):(17*lines)-1)=RQ21_i
group_i((17*lines):(18*lines)-1)=QP21_i
group_i((18*lines):(19*lines)-1)=QR23_i
group_i((19*lines):(20*lines)-1)=PQ23_i
group_i((20*lines):(21*lines)-1)=OP23_i
group_i((21*lines):(22*lines)-1)=TR31_i
group_i((22*lines):(23*lines)-1)=SQ31_i
group_i((23*lines):(24*lines)-1)=RP31_i
group_i((24*lines):(25*lines)-1)=SR32_i
group_i((25*lines):(26*lines)-1)=RQ32_i
group_i((26*lines):(27*lines)-1)=QP32_i

sr=sort(group_w)
group_w=group_w(sr)
group_i=group_i(sr)

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro N2_vib1, N21P_vib_ints   ;THESE ARE THE VIBRATIONAL BAND INTENSITIES
                                ;Vallance Jones 1974, can be modelled with T_vib
; v''0      1      2      3      4      5      6      7      8       9      10     11     12
N21P_vib_ints=$                                                                                  ;v'
[[ 96.36, 54.88, 17.27,  3.81,  0.61,  0.07,  0.00,  0.00,  0.00,   0.00,  0.00,  0.00,  0.00],$ ;0
 [124.50,  0.59, 26.41, 21.13,  8.12,  2.00,  0.32,  0.00,  0.00,   0.00,  0.00,  0.00,  0.00],$ ;1
 [ 53.61, 74.50, 15.09,  3.24, 12.68,  8.80,  3.27,  0.77,  0.11,   0.00,  0.00,  0.00,  0.00],$ ;2
 [  8.80, 63.56, 17.84, 23.43,  0.66,  3.19,  5.20,  3.03,  1.02,   0.21,  0.02,  0.00,  0.00],$ ;3
 [  0.75, 17.59, 48.70,  0.90, 17.13,  4.57,  0.11,  0.89,  2.18,   1.07,  0.32,  0.05,  0.00],$ ;4
 [  0.03,  1.76, 18.20, 23.74,  1.04,  6.61,  5.26,  0.38,  0.35,   0.97,  0.74,  0.31,  0.08],$ ;5
 [  0.00,  0.07,  2.27, 13.53,  8.36,  3.01,  1.35,  3.36,  0.97,   0.00,  0.12,  0.03,  0.14],$ ;6
 [  0.00,  0.00,  0.12,  2.36,  8.93,  2.24,  3.17,  0.06,  1.58,   1.03,  0.00,  0.00,  0.00],$ ;7
 [  0.00,  0.00,  0.00,  0.13,  1.80,  4.52,  0.27,  1.94,  0.08,   0.45,  0.64,  0.21,  0.01],$ ;8
 [  0.00,  0.00,  0.00,  0.00,  0.13,  1.28,  2.14,  0.00,  0.96,   0.21,  0.07,  0.30,  0.19],$ ;9
 [  0.00,  0.00,  0.00,  0.00,  0.00,  0.10,  0.75,  0.81,  0.06,   0.34,  0.21,  0.00,  0.10],$;10
 [  0.00,  0.00,  0.00,  0.00,  0.00,  0.00,  0.07,  0.43,  0.29,   0.09,  0.10,  0.15,  0.01],$;11
 [  0.00,  0.00,  0.00,  0.00,  0.00,  0.00,  0.00,  0.04,  0.21,   0.08,  0.08,  0.02,  0.07]] ;12
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro Dieke,dS32,dT31,dS21,dR3,dR32,dS31,dR31,dR2,dR1,dR21,dQ3,dQ32,dQ2,dQ21,dQ23,dQ12,dQ1,dP3,dP23,dP2,dO23,dP1,dP12,dP13,dO12,dO13,dN13,unknown, instrument_function, instru_grid
;     0        1        2        3        4        5        6        7        8        9        10       11       12       13       14       15       16       17       18   
dS32=[[0       ,0       ,7338.988,7336.314,7333.358,7330.178,7326.730,7323.056,7319.153,7315.038,7310.710,7306.201,7301.482,0       ,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,9       ,10      ,5       ,10      ,6       ,8       ,3       ,4       ,1       ,2       ,1       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dT31=[[7340.259,7336.488,7332.377,7327.567,7323.318,7318.389,7313.229,7307.866,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ],$
      [8       ,9       ,3       ,8       ,2       ,3       ,1       ,1       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dS21=[[7359.640,7356.283,7352.765,7349.083,7345.243,7341.245,7337.090,7332.778,7328.307,7323.684,7318.908,7313.965,0       ,0       ,0       ,0       ,0       ,0       ,0       ],$
      [7.1     ,10      ,8       ,10       ,7       ,10      ,6       ,6       ,3       ,6       ,1       ,1      ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dR3 =[[0       ,0       ,7345.404,7344.391,7343.164,7341.683,7339.955,7337.980,7335.774,7333.358,7330.693,7327.832,7324.770,7321.514,0       ,7314.427,0       ,0       ,0       ],$
      [0       ,0       ,5       ,10      ,8       ,10      ,8       ,10      ,5       ,5       ,3       ,6       ,2       ,2       ,0       ,1       ,0       ,0       ,0       ]]
dR32=[[0       ,0       ,7344.981,7343.486,7342.306,7340.856,7339.148,7337.188,7334.986,7332.567,7329.922,7327.064,7323.995,7320.762,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,6       ,10       ,9       ,10      ,8       ,10     ,4       ,6       ,3       ,3       ,1       ,2       ,0       ,0       ,0       ,0       ,0       ]]
dS31=[[0       ,7341.877,7339.543,7336.898,7333.975,7330.788,7327.356,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ], $
      [0       ,7       ,4       ,8       ,3       ,4       ,1       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dR31=[[0       ,0       ,0       ,7344.066,7342.914,7341.497,7339.768,7337.832,7335.628,7333.230,7330.555,7327.716,0       ,0       ,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,0       ,2       ,1       ,1       ,1       ,1       ,2       ,1       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dR2 =[[0       ,7360.743,7358.835,7356.791,7354.610,7352.272,7349.795,7347.378,7344.334,7341.377,7338.267,7334.986,7331.530,7327.567,0       ,0       ,0       ,0       ,0       ],$
      [0       ,1       ,2       ,7.1     ,3       ,9       ,5       ,10      ,6       ,10      ,2       ,4       ,1       ,1       ,0       ,0       ,0       ,0       ,0       ]]
dR1 =[[7382.444,7379.433,7376.301,7373.096,7369.830,7366.488,7363.078,7359.585,7356.003,7352.332,7348.557,7344.677,7340.700,7336.595,7332.377,7328.041,0       ,0       ,0       ],$
      [8       ,10      ,9       ,10      ,10      ,10      ,9       ,10      ,8       ,10      ,6       ,6       ,3       ,2       ,2       ,1       ,0       ,0       ,0       ]]
dR21=[[7362.877,7361.242,7359.392,7357.378,7355.212,7352.893,7350.416,7347.777,7344.981,7342.026,7338.918,7335.628,7332.189,7328.591,0       ,0       ,0       ,0       ,0       ],$
      [10.1    ,10      ,9       ,10      ,10      ,10      ,10      ,10      ,3       ,7       ,3       ,2       ,1       ,1       ,0       ,0       ,0       ,0       ,0       ]]
dQ3 =[[0       ,0       ,0       ,7349.795,7350.349,7350.622,7350.683,7350.459,7349.977,7349.274,7348.336,7347.165,7345.805,7344.235,7342.460,7340.488,7338.335,7335.988,7333.472],$
      [0       ,0       ,0       ,10.1    ,8       ,10      ,10      ,10      ,9       ,10      ,8       ,10      ,5       ,7       ,2       ,3       ,1       ,1       ,3       ]]
dQ32=[[0       ,0       ,0       ,7348.884,7349.489,7349.850,7349.850,7349.653,7349.199,7348.497,7347.558,7346.409,0       ,7343.431,0       ,7339.768,0       ,0       ,0       ],$
      [0       ,0       ,0       ,4       ,4       ,5.1     ,5.1     ,7       ,3       ,6       ,2       ,2       ,0       ,2       ,0       ,1       ,0       ,0       ,0       ]]
dQ2= [[0       ,7364.036,7363.750,7363.308,7362.749,7362.049,7361.177,7360.161,7358.988,7357.649,7356.148,7354.485,7352.661,7350.683,0       ,0       ,0       ,0       ,0       ],$
      [0       ,1       ,1       ,6       ,5       ,9       ,10.1    ,10      ,7       ,10      ,7       ,9       ,4       ,1       ,0       ,0       ,0       ,0       ,0       ]]
dQ21=[[0       ,7364.502,7364.290,7363.900,7363.366,7362.663,7361.813,7360.801,7359.640,7358.292,7356.791,7355.142,7353.269,7351.305,0       ,0       ,0       ,0       ,0       ],$
      [0       ,3       ,8.1     ,8       ,6       ,8       ,7       ,8       ,2.1     ,6       ,1.1     ,2       ,1       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dQ23=[[0       ,7365.422,7364.736,7364.226,7363.609,7362.877,7361.991,7360.961,7359.770,7358.422,7356.916,7355.257,7353.435,7351.451,0       ,0       ,0       ,0       ,0       ],$
      [0       ,10      ,9       ,10      ,9       ,10.1    ,8       ,9       ,5       ,7.1     ,2       ,6       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dQ12=[[0       ,7384.811,7383.163,7381.468,7379.713,7377.897,7376.016,7374.059,7372.008,7369.897,7367.679,7365.354,0       ,7360.400,0       ,7354.990,0       ,0       ,0       ],$
      [0       ,8.1     ,7       ,10      ,8       ,10      ,8       ,9       ,10.1    ,7       ,2       ,4       ,0       ,1       ,0       ,1       ,0       ,0       ,0       ]]
dQ1 =[[7386.800,7385.333,7383.723,7382.054,7380.320,7378.517,7376.647,7374.713,7372.664,7370.543,7368.325,7366.009,7363.573,7361.051,7358.422,7355.626,0       ,0       ,0       ],$
      [10      ,10      ,10      ,10      ,10      ,10      ,10      ,10      ,10.1    ,10      ,10      ,10      ,4       ,8       ,7.1     ,4       ,0       ,0       ,0       ]]
dP3 =[[0       ,0       ,0       ,0       ,7355.762,7357.837,7359.640,7361.177,7362.476,7363.506,7364.290,7364.858,7365.195,7365.314,7365.241,7364.939,7364.415,0       ,0       ], $
      [0       ,0       ,0       ,0       ,2       ,6       ,8.1     ,10.1    ,6       ,8       ,8.1     ,7       ,4       ,5       ,3       ,2       ,1       ,0       ,0       ]]
dP23=[[0       ,0       ,7368.067,7369.191,7370.251,7371.210,7372.008,7372.664,7373.178,7373.531,7373.737,7373.737,7373.610,7373.310,7372.935,0       ,0       ,0       ,0       ],$
      [0       ,0       ,10      ,10      ,10      ,10.1    ,10.1    ,10.1    ,9       ,10      ,9.1     ,9.1     ,4       ,4       ,4       ,0       ,0       ,0       ,0       ]]
dP2 =[[0       ,0       ,0       ,7368.278,7369.387,7370.365,7371.210,7371.871,7372.395,7372.742,7372.973,7372.973,7372.844,7372.543,7372.122,7371.437,0       ,0       ,0       ],$
      [0       ,0       ,0       ,2       ,1       ,4       ,10.1    ,7       ,5       ,7       ,7.1     ,7.1     ,4       ,3       ,1       ,2       ,0       ,0       ,0       ]]
dO23=[[0       ,0       ,0       ,7372.474,7375.163,7377.744,7380.191,7382.491,7384.627,7386.618,7388.476,7390.156,7391.671,7393.015,7394.190,7395.207,0       ,0       ,0       ],$
      [0       ,0       ,0       ,8       ,8       ,10      ,9.1     ,10      ,10.1    ,10.1    ,6       ,8       ,3       ,4       ,1       ,1.1     ,0       ,0       ,0       ]]
dP1 =[[0       ,7387.191,7387.191,7387.090,7386.957,7386.756,7386.505,7386.189,7385.770,7385.263,7384.700,7384.023,7383.238,7382.341,7381.334,7380.191,7378.952,7377.568,0       ],$
      [0       ,10.1    ,10.1    ,10      ,10.1    ,10      ,10.1    ,10      ,9       ,10      ,9       ,10.1    ,6       ,7       ,3       ,9.1     ,1       ,2       ,0       ]]
dP12=[[0       ,7386.687,7386.618,7386.505,7386.290,7386.126,7385.871,7385.540,7385.127,7384.627,7384.023,7383.365,7382.577,7381.685,7380.666,7379.545,0       ,0       ,0       ],$
      [0       ,10.1    ,10.1    ,10.1    ,10.1    ,10      ,10.1    ,10      ,10      ,10.1    ,10.1    ,9       ,3       ,5       ,1       ,1       ,0       ,0       ,0       ]]
dP13=[[0       ,0       ,0       ,7387.419,7387.191,7386.957,7386.687,7386.351,7385.871,7385.451,7384.811,7384.181,0       ,0       ,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,0       ,0       ,10.1    ,10.1    ,10.1    ,10.1    ,10.1    ,3       ,1.1       ,0     ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dO12=[[0       ,7389.496,7390.971,7392.402,7393.793,7395.126,7396.408,7397.628,7398.778,7399.848,7400.834,7401.732,7402.524,7403.225,7403.816,7404.281,7404.631,0       ,0       ],$
      [0       ,10      ,10      ,10      ,10      ,10      ,10      ,10      ,9       ,10      ,7       ,8       ,5.1     ,5       ,1       ,2       ,1       ,0       ,0       ]]
dO13=[[0       ,0       ,7392.012,7393.328,7394.658,7395.965,7397.225,7398.434,7399.572,7400.636,7401.612,7402.524,7403.650,0       ,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,2       ,7       ,5       ,8       ,5       ,7       ,2       ,4       ,1       ,5.1     ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
dN13=[[0       ,0       ,7392.332,7395.207,7398.126,7401.026,7403.895,7406.722,7409.490,7412.196,7414.836,7417.382,0       ,0       ,0       ,0       ,0       ,0       ,0       ],$
      [0       ,0       ,3       ,8.1     ,4       ,7       ,5       ,7       ,3       ,5       ,1       ,2       ,0       ,0       ,0       ,0       ,0       ,0       ,0       ]]
;      0        1        2        3        4        5        6        7        8        9        10       11       12       13       14       15       16

unknown=[[7323.146,7324.837,7326.891,7328.185,7331.124,7332.660,7336.258,7336.402,7337.007,7337.525,7340.115,7340.808,7341.114,7341.198,$
          7341.568,7341.795,7341.958,7342.155,7343.104,7343.272,7343.366,7344.554,7344.823,7345.103,7346.214,7346.998,7347.378,7347.945,$
          7348.101,7348.216,7348.427,7348.755,7348.964,7349.032,7349.398,7349.565,7349.727,7350.208,7350.545,7350.887,7352.562,7352.837,$
          7354.281,7354.410,7354.552,7355.379,7355.516,7355.891,7356.078,7356.221,7356.581,7357.155,7157.253,7357.327,7357.514,7357.599,$
          7357.749,7358.124,7358.377,7358.571,7358.923,7359.191,7359.337,7359.464,7359.528,7359.944,7360.067,7360.895,7361.119,7361.630,$
          7361.907,7361.225,7362.555,7362.823,7362.997,7363.213,7363.433,7364.171,7364.605,7364.698,7365.077,7365.704,7365.956,7366.113,$
          7366.306,7366.430,7367.878,7368.013,7368.172,7369.679,7370.020,7370.130,7370.200,7370.434,7370.487,7370.983,7371.156,7371.803,$
          7371.956,7372.220,7372.315,7373.049,7373.402,7373.477,7373.919,7374.403,7374.564,7374.658,7375.429,7375.732,7376.125,7376.233,$
          7376.426,7376.511,7376.592,7377.690,7377.820,7378.073,7378.308,7379.387,7379.645,7379.998,7380.127,7380.261,7381.408,7381.549,$
          7381.615,7381.819,7381.914,7381.981,7382.217,7383.040,7383.573,7383.664,7383.850,7383.956,7384.388,7384.576,7384.942,7385.002,$
          7385.071,7385.184,7385.194,7385.225,7385.414,7385.494,7385.609,7385.647,7385.715,7385.926,7386.013,7386.072,7386.290,7386.411,$
          7386.553,7386.877,7387.028,7389.350,7389.446,7390.918,7391.499,7391.809,7392.176,7392.787,7392.910,7393.190,7393.743,7395.075,$
          7396.359,7397.573,7397.805,7398.243,7398.337,7398.598,7399.704,7399.798,7400.549,7400.736,7400.950,7401.891,7402.928,7405.630,$
          7406.659,7411.973,7413.522,7415.551,7417.458,7417.788,7417.916],$
         [1       ,1       ,1       ,1       ,1       ,1       ,2       ,1       ,1       ,1       ,1       ,2       ,1       ,1       ,$
          1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,3       ,1       ,1       ,1       ,$
          1       ,1       ,1       ,1       ,1       ,2       ,1       ,1       ,2       ,1       ,1       ,1       ,1       ,3       ,$
          1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,2       ,1       ,1       ,$
          1       ,1       ,2       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,$
          1       ,1       ,1       ,2       ,1       ,1       ,1       ,2       ,1       ,1       ,1       ,1       ,2       ,1       ,$
          1       ,3       ,1       ,1       ,1       ,1       ,1       ,1       ,2       ,1       ,4       ,1       ,10      ,1       ,$
          2       ,1       ,1       ,3       ,1       ,2       ,1       ,1       ,1       ,10      ,1       ,1       ,1       ,1       ,$
          1       ,1       ,3       ,2       ,1       ,1       ,1       ,2       ,1       ,1       ,1       ,2       ,2       ,1       ,$
          1       ,1       ,1       ,2       ,1       ,1       ,1       ,2       ,1       ,1       ,1       ,3       ,1       ,3       ,$
          2       ,1       ,3       ,3       ,1       ,9       ,3       ,1       ,2       ,1       ,2       ,2       ,2       ,2       ,$
          3       ,1       ,2       ,1       ,2       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,1       ,4       ,$
          1       ,4       ,1       ,1       ,1       ,1       ,1       ,2       ,1       ,1       ,1       ,1       ,1       ,1       ,$
          1       ,1       ,1       ,1       ,3       ,1       ,1        ]]


;for J= 0 ,(n_elements(dt31)/2)-1 do plots,[dt31(J,0),dt31(J,0)],[0,dt31(J,1)]
;for J= 0 ,(n_elements(ds32)/2)-1 do plots,[ds32(J,0),ds32(J,0)],[0,ds32(J,1)]
;for J= 0 ,(n_elements(ds21)/2)-1 do plots,[ds21(J,0),ds21(J,0)],[0,ds21(J,1)]
;for J= 0 ,(n_elements(dr3) /2)-1 do plots,[ dr3(J,0), dr3(J,0)],[0, dr3(J,1)]
;for J= 0 ,(n_elements(dr32)/2)-1 do plots,[dr32(J,0),dr32(J,0)],[0,dr32(J,1)]
;for J= 0 ,(n_elements(ds31)/2)-1 do plots,[ds31(J,0),ds31(J,0)],[0,ds31(J,1)]
;for J= 0 ,(n_elements(dr31)/2)-1 do plots,[dr31(J,0),dr31(J,0)],[0,dr31(J,1)]
;for J= 0 ,(n_elements(dr2) /2)-1 do plots,[ dr2(J,0), dr2(J,0)],[0, dr2(J,1)]
;for J= 0 ,(n_elements(dr1) /2)-1 do plots,[ dr1(J,0), dr1(J,0)],[0, dr1(J,1)]
;for J= 0 ,(n_elements(dr21)/2)-1 do plots,[dr21(J,0),dr21(J,0)],[0,dr21(J,1)]
;for J= 0 ,(n_elements(dq3) /2)-1 do plots,[ dq3(J,0), dq3(J,0)],[0, dq3(J,1)]
;for J= 0 ,(n_elements(dq32)/2)-1 do plots,[dq32(J,0),dq32(J,0)],[0,dq32(J,1)]
;for J= 0 ,(n_elements(dQ2 )/2)-1 do plots,[dQ2 (J,0),dq2 (J,0)],[0,dq2 (J,1)]
;for J= 0 ,(n_elements(dQ21)/2)-1 do plots,[dq21(J,0),dq21(J,0)],[0,dq21(J,1)]
;for J= 0 ,(n_elements(dQ23)/2)-1 do plots,[dq23(J,0),dq23(J,0)],[0,dq23(J,1)]
;for J= 0 ,(n_elements(dQ12)/2)-1 do plots,[dq12(J,0),dq12(J,0)],[0,dq12(J,1)]
;for J= 0 ,(n_elements(dQ1 )/2)-1 do plots,[dq1 (J,0),dq1 (J,0)],[0,dq1 (J,1)]
;for J= 0 ,(n_elements(dP3 )/2)-1 do plots,[dp3 (J,0),dp3 (J,0)],[0,dp3 (J,1)]
;for J= 0 ,(n_elements(dP23)/2)-1 do plots,[dp23(J,0),dp23(J,0)],[0,dp23(J,1)]
;for J= 0 ,(n_elements(dP2 )/2)-1 do plots,[dp2 (J,0),dp2 (J,0)],[0,dp2 (J,1)]
;for J= 0 ,(n_elements(dO23)/2)-1 do plots,[do23(J,0),do23(J,0)],[0,do23(J,1)]
;for J= 0 ,(n_elements(dP1) /2)-1 do plots,[dp1 (J,0),dp1 (J,0)],[0,dp1 (J,1)]
;for J= 0 ,(n_elements(dP12)/2)-1 do plots,[dp12(J,0),dp12(J,0)],[0,dp12(J,1)]
;for J= 0 ,(n_elements(dP13)/2)-1 do plots,[dp13(J,0),dp13(J,0)],[0,dp13(J,1)]
;for J= 0 ,(n_elements(dO12)/2)-1 do plots,[dO12(J,0),dO12(J,0)],[0,dO12(J,1)]
;for J= 0 ,(n_elements(dO13)/2)-1 do plots,[dO13(J,0),dO13(J,0)],[0,dO13(J,1)]
;for J= 0 ,(n_elements(dN13)/2)-1 do plots,[dN13(J,0),dN13(J,0)],[0,dN13(J,1)]
;for J= 0 ,(n_elements(unknown)/2)-1 do plots,[unknown(J,0),unknown(J,0)],[0,unknown(J,1)], color=50

all_N2d_w=dblarr(27.*19+n_elements(unknown(*,0)))
all_N2d_i=dblarr(27.*19+n_elements(unknown(*,0)))

all_N2d_w( 0*19.:( 1*19.)-1)=dt31(*,0)
all_N2d_w( 1*19.:( 2*19.)-1)=ds32(*,0)
all_N2d_w( 2*19.:( 3*19.)-1)=ds21(*,0)
all_N2d_w( 3*19.:( 4*19.)-1)=dr3 (*,0)
all_N2d_w( 4*19.:( 5*19.)-1)=dr32(*,0)
all_N2d_w( 5*19.:( 6*19.)-1)=ds31(*,0)
all_N2d_w( 6*19.:( 7*19.)-1)=dr31(*,0)
all_N2d_w( 7*19.:( 8*19.)-1)=dr2 (*,0)
all_N2d_w( 8*19.:( 9*19.)-1)=dr1 (*,0)
all_N2d_w( 9*19.:(10*19.)-1)=dr21(*,0)
all_N2d_w(10*19.:(11*19.)-1)=dq3 (*,0)
all_N2d_w(11*19.:(12*19.)-1)=dq32(*,0)
all_N2d_w(12*19.:(13*19.)-1)=dq2 (*,0)
all_N2d_w(13*19.:(14*19.)-1)=dq21(*,0)
all_N2d_w(14*19.:(15*19.)-1)=dq23(*,0)
all_N2d_w(15*19.:(16*19.)-1)=dq12(*,0)
all_N2d_w(16*19.:(17*19.)-1)=dq1 (*,0)
all_N2d_w(17*19.:(18*19.)-1)=dp3 (*,0)
all_N2d_w(18*19.:(19*19.)-1)=dp23(*,0)
all_N2d_w(19*19.:(20*19.)-1)=dp2 (*,0)
all_N2d_w(20*19.:(21*19.)-1)=do23(*,0)
all_N2d_w(21*19.:(22*19.)-1)=dp1 (*,0)
all_N2d_w(22*19.:(23*19.)-1)=dp12(*,0)
all_N2d_w(23*19.:(24*19.)-1)=dp13(*,0)
all_N2d_w(24*19.:(25*19.)-1)=do12(*,0)
all_N2d_w(25*19.:(26*19.)-1)=do13(*,0)
all_N2d_w(26*19.:(27*19.)-1)=dn13(*,0)
all_N2d_w(27*19.:n_elements(all_N2d_w)-1)=unknown(*,0)

all_N2d_i( 0*19.:( 1*19.)-1)= dt31(*,1)
all_N2d_i( 1*19.:( 2*19.)-1)= ds32(*,1)
all_N2d_i( 2*19.:( 3*19.)-1)= ds21(*,1)
all_N2d_i( 3*19.:( 4*19.)-1)= dr3 (*,1)
all_N2d_i( 4*19.:( 5*19.)-1)= dr32(*,1)
all_N2d_i( 5*19.:( 6*19.)-1)= ds31(*,1)
all_N2d_i( 6*19.:( 7*19.)-1)= dr31(*,1)
all_N2d_i( 7*19.:( 8*19.)-1)=dr2 (*,1)
all_N2d_i( 8*19.:( 9*19.)-1)=dr1 (*,1)
all_N2d_i( 9*19.:(10*19.)-1)=dr21(*,1)
all_N2d_i(10*19.:(11*19.)-1)=dq3 (*,1)
all_N2d_i(11*19.:(12*19.)-1)=dq32(*,1)
all_N2d_i(12*19.:(13*19.)-1)=dq2 (*,1)
all_N2d_i(13*19.:(14*19.)-1)=dq21(*,1)
all_N2d_i(14*19.:(15*19.)-1)=dq23(*,1)
all_N2d_i(15*19.:(16*19.)-1)=dq12(*,1)
all_N2d_i(16*19.:(17*19.)-1)=dq1 (*,1)
all_N2d_i(17*19.:(18*19.)-1)=dp3 (*,1)
all_N2d_i(18*19.:(19*19.)-1)=dp23(*,1)
all_N2d_i(19*19.:(20*19.)-1)=dp2 (*,1)
all_N2d_i(20*19.:(21*19.)-1)=do23(*,1)
all_N2d_i(21*19.:(22*19.)-1)=dp1 (*,1)
all_N2d_i(22*19.:(23*19.)-1)=dp12(*,1)
all_N2d_i(23*19.:(24*19.)-1)=dp13(*,1)
all_N2d_i(24*19.:(25*19.)-1)=do12(*,1)
all_N2d_i(25*19.:(26*19.)-1)=do13(*,1)
all_N2d_i(26*19.:(27*19.)-1)=dn13(*,1)
all_N2d_i(27*19.:n_elements(all_N2d_w)-1)=0.;unknown(*,1) EXTRA LINES ARE SWITCHED OFF

convolve_sp, all_N2d_w, all_N2d_i, instrument_function, instru_grid, int_colv2
;mult=(scaling/max(int_colv2))*.95
oplot,instru_grid,int_colv2, linestyle=1,color=250

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;""""""""""""""""""""""""""""""""""""""
;#############################################################################################
;#############################################################################################
;#############################################################################################
;#############################################################################################
;#############################################################################################

pro N2_1Pd,v1,v2,lines,temp,P1,P2,P3,R1,R2,R3,Q1,Q2,Q3,OP12,QR12,PQ12,PR13,OQ13,NP13,SR21,RQ21,QP21,QR23,PQ23,OP23,TR31,SQ31,RP31,SR32,RQ32,QP32,P1_i,P2_i,P3_i,R1_i,R2_i,R3_i,Q1_i,Q2_i,Q3_i,OP12_i,QR12_i,PQ12_i,PR13_i,OQ13_i,NP13_i,SR21_i,RQ21_i,QP21_i,QR23_i,PQ23_i,OP23_i,TR31_i,SQ31_i,RP31_i,SR32_i,RQ32_i,QP32_i

;Molecular Coefficients [cm-1] Huber & Herzberg (1979) online catalog, various sources
;----------------------------------------------VIBRATIONAL CONSTANTS
                                ;DIEKE         ;Roux
B_T_e  = 59619.3d                ; 
B_w_e  = 1733.985d      ;1733.39  ;1735.42       ;1734.025 ##
B_wexe = 14.35d       ;14.122   ;15.198        ;14.412   ## 
B_yexe = 0.d                     ;0.178         ;-0.0033
B_zexe = 0.d                     ;0.0158        ;-0.00079
A_T_e  = 50203.6d                ;
A_w_e  = 1460.60d      ;1460.64  ;1460.60       ;1460.941 ##
A_wexe = 13.851d       ;13.87    ;13.851        ;13.980   ##
A_yexe = 0.d                     ;0.00625       ;0.024
A_zexe = 0.d                     ;0.00172       ;-0.00256
;----------------------------------------------ROTATIONAL CONSTANTS
B_B_e    = 1.63748d              ;1.63748       ;1.63772  ##
B_alpha_e= 0.01794d              ;0.01794       ;0.01793  ##
B_beta_e = 0.d                   ;-7.38e-5      ;-0.00010
 B_D_e   = 5.52d-6               ;
 B_SS_e  = 9d-8                  ;
A_B_e    = 1.4545d    ;1.4546    ;1.4545        ;1.4539   ##
A_alpha_e= 0.01798d   ;0.0180    ;0.01798       ;0.0175   ##
A_beta_e = 0.d                   ;-8.44e-5      ;-0.00014
 A_D_e   = 5.46d-6               ;
 A_SS_e  = 1.1d-7                ;

A_w    = 0.443d
A_gamma= 3d-3
C_T_e  = 89136.88d
C_w_e  = 2047.17d
C_wexe = 28.445d
C_B_e  = 1.8247d
C_a_e  = 0.01868d
    h  = 6.6606876d-34       ;[J][s]
    c  = (2.99792458d8)*1e2  ;[cm][s-2]
    k  = 1.3806503d-23       ;[J][K-1]
Bu     = 1.98954d            ;+/- .00003 N2 X ground state rotational constant


;Electronic & vibronic energy-------------------------------------------------
deltaE=  B_T_e-A_T_e
deltaG=  B_w_e*(v1+0.5)-B_wexe*(v1+0.5)^2.-A_w_e*(v2+0.5)+A_wexe*(v2+0.5)^2.
;stop
;Upper 3Pi State vibrational settings ----------------------------------------
   A_v = 42.286d -  0.068d*(v1+0.5)    $
                - (2.5d-3)*(v1+0.5)^2. $
                - (2.6d-4)*(v1+0.5)^3.
 B_B_v = B_B_e-B_alpha_e *(v1+0.5)
     Y = A_v/B_B_v
 B_D_v = B_D_e-B_SS_e*(v1+0.5)  

;Lower 3Sigma State vibrational settings--------------------------------------
 A_B_v = A_B_e-A_alpha_e *(v2+0.5)
 A_D_v = A_D_e-A_SS_e*(v2+0.5)

;print, B_B_v, A_B_v
;B_B_v=1.53676
;A_B_v=1.3907


;stop
;##############################################################################################
;              MODEL J numbers correspond to *upper state* --> not anymore
;                REMEMBER      Pi3F1 no R-branch line when J=0
;                              Pi3F2 J=0 doesn't exist
;                              Pi3F3 J=0,1 don't exist
;################################################################################################
;P-branch F1-F1 levels (deltaJ = +1)                                                           ;#
P1  =dblarr(lines)                                                                             ;#
                                                                          ;#
J_lim=1.                                                                                        ;#
for J=J_lim,lines-1. do P1  (J)=Pi3F1(B_B_v, B_D_v, Y, J-1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
          ;#
P1(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+P1(J_lim:lines-1.))                                   ;#
;R-branch F1-F1 levels (deltaJ = -1)                                                           ;#
R1  =dblarr(lines)                                                                             ;#
                                                                           ;# 
J_lim=1.                                                                                        ;#
for J=J_lim,lines-1. do R1  (J)=Pi3F1(B_B_v, B_D_v, Y, J+1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
                ;#
R1(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+R1(J_lim:lines-1.))                                   ;#
;Q-branch F1-F1 levels (deltaJ = 0)                                                            ;#
Q1  =dblarr(lines)                                                                             ;#
                                                                          ;#
J_lim=1.                                                                                        ;#
for J=J_lim,lines-1. do Q1  (J)=Pi3F1(B_B_v, B_D_v, Y, J)-Sigma3F1(A_B_v, A_D_v, A_w,A_gamma,J) ;#
                ;#
Q1(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+Q1(J_lim:lines-1.))                                   ;#
;################################################################################################
;P-branch F2-F2 levels (deltaJ = +1)                                                           ;#
P2  =dblarr(lines)                                                                             ;#
                                                                          ;#
J_lim=2                                                                                        ;#
for J=J_lim,lines-1. do P2  (J)=Pi3F2(B_B_v, B_D_v, Y, J-1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
               ;#
P2(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+P2(J_lim:lines-1.))                                   ;#
;R-branch F2-F2 levels (deltaJ = -1)                                                           ;#
R2  =dblarr(lines)                                                                             ;#
                                                                          ;#
J_lim=1                                                                                        ;#
for J=J_lim,lines-1. do R2  (J)=Pi3F2(B_B_v, B_D_v, Y, J+1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
               ;#
R2(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+R2(J_lim:lines-1.))                                   ;#
;Q-branch F2-F2 levels (deltaJ = 0)                                                            ;#
Q2  =dblarr(lines)                                                                             ;#
                                                                           ;#
J_lim=1                                                                                        ;#
for J=J_lim,lines-1. do Q2  (J)=Pi3F2(B_B_v, B_D_v, Y, J)-Sigma3F2(A_B_v, A_D_v, A_w,A_gamma,J) ;#
            ;#
Q2(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+Q2(J_lim:lines-1.))                                   ;#
;################################################################################################
;P-branch F3-F3 levels (deltaJ = +1)                                                           ;#
P3  =dblarr(lines)                                                                             ;#
                                                                           ;#
J_lim=3                                                                                        ;#
for J=J_lim,lines-1. do P3  (J)=Pi3F3(B_B_v, B_D_v, Y, J-1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
P3(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+P3(J_lim:lines-1.))                                   ;#
;R-branch F3-F3 levels (deltaJ = -1)                                                           ;#
R3  =dblarr(lines)                                                                             ;#
                                                                            ;# 
J_lim=1                                                                                        ;#
for J=J_lim,lines-1. do R3  (J)=Pi3F3(B_B_v, B_D_v, Y, J+1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
              ;#
R3(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+R3(J_lim:lines-1.))                                   ;#
;Q-branch F3-F3 levels (deltaJ = 0)                                                            ;#
Q3  =dblarr(lines)                                                                             ;#
                                                                             ;#
J_lim=2                                                                                        ;#
for J=J_lim,lines-1. do Q3  (J)=Pi3F3(B_B_v, B_D_v, Y, J)-Sigma3F3(A_B_v, A_D_v, A_w,A_gamma,J) ;#
              ;#
Q3(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+Q3(J_lim:lines-1.))                                   ;#
;################################################################################################
;OP-branch F1-F2 levels (deltaJ = +1)                                                          ;#
OP12  =dblarr(lines)                                                                           ;#
                                                                         ;#
J_lim=1
for J=J_lim,lines-1. do OP12  (J)=Pi3F1(B_B_v, B_D_v, Y, J-1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
              ;#
OP12(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+OP12(J_lim:lines-1.))                                                             ;#
;QR-branch F1-F2 levels (deltaJ = -1)                                                          ;#
QR12  =dblarr(lines)                                                                           ;#
                                                                         ;#
J_lim=1
for J=J_lim,lines-1. do QR12  (J)=Pi3F1(B_B_v, B_D_v, Y, J+1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
              ;#
QR12(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+QR12(J_lim:lines-1.))                                       ;#
;PQ-branch F1-F2 levels (deltaJ = 0)                                                           ;#
PQ12  =dblarr(lines)                                                                           ;#
                                                                         ;#
J_lim=1
for J=J_lim,lines-1. do PQ12  (J)=Pi3F1(B_B_v, B_D_v, Y, J)-Sigma3F2(A_B_v, A_D_v, A_w,A_gamma,J) ;#
             ;#
PQ12(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+PQ12(J_lim:lines-1.))                                                             ;#
;################################################################################################
;NP-branch F1-F3 levels (deltaJ = +1)                                                          ;#
NP13  =dblarr(lines)                                                                           ;#
                                                                        ;#
J_lim=1
for J=J_lim,lines-1. do NP13  (J)=Pi3F1(B_B_v, B_D_v, Y, J-1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
              ;#
NP13(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+NP13(J_lim:lines-1.))                                                             ;#
;PR-branch F1-F3 levels (deltaJ = -1)                                                          ;#
PR13  =dblarr(lines)                                                                           ;#
                                                                          ;#
J_lim=0
for J=J_lim,lines-1. do PR13  (J)=Pi3F1(B_B_v, B_D_v, Y, J+1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
PR13(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+PR13(J_lim:lines-1.))                                       ;#
;OQ-branch F1-F3 levels (deltaJ = 0)                                                           ;#
OQ13  =dblarr(lines)                                                                           ;#
                                                                           ;#
J_lim=1
for J=J_lim,lines-1. do OQ13  (J)=Pi3F1(B_B_v, B_D_v, Y, J)-Sigma3F3(A_B_v, A_D_v, A_w,A_gamma,J) ;#
               ;#
OQ13(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+OQ13(J_lim:lines-1.))                                       ;#
;##################################################################################################
;QP-branch F2-F1 levels (deltaJ = +1)                                                            ;#
QP21  =dblarr(lines)                                                                               ;#
                                                                            ;#
J_lim=2
for J=J_lim,lines-1. do QP21  (J)=Pi3F2(B_B_v, B_D_v, Y, J-1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
QP21(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+QP21(J_lim:lines-1.))                                 ;#
;SR-branch F2-F1 levels (deltaJ = -1)                                                            ;#
SR21  =dblarr(lines)                                                                               ;#
                                                                           ;#
J_lim=1
for J=J_lim,lines-1. do SR21  (J)=Pi3F2(B_B_v, B_D_v, Y, J+1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
SR21(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+SR21(J_lim:lines-1.))                                 ;#
;RQ-branch F2-F1 levels (deltaJ =  0)                                                            ;#
RQ21  =dblarr(lines)                                                                               ;#
                                                                           ;#
J_lim=1
for J=J_lim,lines-1. do RQ21  (J)=Pi3F2(B_B_v, B_D_v, Y, J)-Sigma3F1(A_B_v, A_D_v, A_w,A_gamma,J) ;#
             ;#
RQ21(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+RQ21(J_lim:lines-1.))                                 ;#
;################################################################################################
;OP-branch F2-F3 levels (deltaJ = +1)                                                            ;#
OP23  =dblarr(lines)                                                                               ;#
                                                                        ;#
J_lim=2
for J=J_lim,lines-1. do OP23  (J)=Pi3F2(B_B_v, B_D_v, Y, J-1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
               ;#
OP23(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+OP23(J_lim:lines-1.))                                 ;#
;QR-branch F2-F3 levels (deltaJ = -1)                                                            ;#
QR23  =dblarr(lines)                                                                               ;#
                                                                            ;#
J_lim=0
for J=J_lim,lines-1. do QR23  (J)=Pi3F2(B_B_v, B_D_v, Y, J+1.)-Sigma3F3(A_B_v,A_D_v,A_w,A_gamma,J);#
            ;#
QR23(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+QR23(J_lim:lines-1.))                                 ;#
;PQ-branch F2-F3 levels (deltaJ =  0)                                                            ;#
PQ23  =dblarr(lines)                                                                               ;#
                                                                             ;#
J_lim=1
for J=J_lim,lines-1. do PQ23  (J)=Pi3F2(B_B_v, B_D_v, Y, J)-Sigma3F3(A_B_v, A_D_v, A_w,A_gamma,J) ;#
            ;#
PQ23(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+PQ23(J_lim:lines-1.))                                 ;#
;##################################################################################################
;RP-branch F3-F1 levels (deltaJ = +1)                                                            ;#
RP31  =dblarr(lines)                                                                               ;#
                                                                          ;#
J_lim=3
for J=J_lim,lines-1. do RP31  (J)=Pi3F3(B_B_v, B_D_v, Y, J-1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
RP31(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+RP31(J_lim:lines-1.))                                 ;#
;TR-branch F3-F1 levels (deltaJ = -1)                                                            ;#
TR31  =dblarr(lines)                                                                               ;#
                                                                            ;#
J_lim=1
for J=J_lim,lines-1. do TR31  (J)=Pi3F3(B_B_v, B_D_v, Y, J+1.)-Sigma3F1(A_B_v,A_D_v,A_w,A_gamma,J);#
            ;#
TR31(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+TR31(J_lim:lines-1.))                                 ;#
;SQ-branch F3-F1 levels (deltaJ =  0)                                                            ;#
SQ31  =dblarr(lines)                                                                               ;#
                                                                           ;#
J_lim=2
for J=J_lim,lines-1. do SQ31  (J)=Pi3F3(B_B_v, B_D_v, Y, J)-Sigma3F1(A_B_v, A_D_v,A_w,A_gamma,J)  ;#
            ;#
SQ31(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+SQ31(J_lim:lines-1.))                                 ;#
;##################################################################################################
;QP-branch F3-F2 levels (deltaJ = +1)                                                            ;#
QP32  =dblarr(lines)                                                                               ;#
                                                                            ;# 
J_lim=3
for J=J_lim,lines-1. do QP32  (J)=Pi3F3(B_B_v, B_D_v, Y, J-1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
             ;#
QP32(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+QP32(J_lim:lines-1.))                                 ;#
;SR-branch F3-F2 levels (deltaJ = -1)                                                            ;#
SR32  =dblarr(lines)                                                                               ;#
                                                                            ;#
J_lim=1
for J=J_lim,lines-1. do SR32  (J)=Pi3F3(B_B_v, B_D_v, Y, J+1.)-Sigma3F2(A_B_v,A_D_v,A_w,A_gamma,J);#
              ;# 
SR32(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+SR32(J_lim:lines-1.))                                 ;#
;RQ-branch F3-F2 levels (deltaJ =  0)                                                            ;#
RQ32  =dblarr(lines)                                                                               ;#
                                                                           ;#
J_lim=2
for J=J_lim,lines-1. do RQ32  (J)=Pi3F3(B_B_v, B_D_v, Y, J)-Sigma3F2(A_B_v, A_D_v,A_w, A_gamma, J);#
            ;#
RQ32(J_lim:lines-1.)=nuva2leai(deltaE+deltaG+RQ32(J_lim:lines-1.))                                 ;#
;##################################################################################################

;INTENSITIES-----------------------------
HL_trial2,lines,Y,temp,new_P11_bud,new_Q11_bud,new_R11_bud,new_P22_bud,new_Q22_bud,new_R22_bud,new_P33_bud,new_Q33_bud,new_R33_bud,new_P31_bud,new_Q31_bud,new_R31_bud,new_P32_bud,new_Q32_bud,new_R32_bud,new_P21_bud,new_Q21_bud,new_R21_bud,new_P23_bud,new_Q23_bud,new_R23_bud,new_P12_bud,new_Q12_bud,new_R12_bud,new_P13_bud,new_Q13_bud,new_R13_bud

P1_i  =new_P11_bud
R1_i  =new_R11_bud
Q1_i  =new_Q11_bud
P2_i  =new_P22_bud
R2_i  =new_R22_bud
Q2_i  =new_Q22_bud
P3_i  =new_P33_bud
R3_i  =new_R33_bud
Q3_i  =new_Q33_bud
OP12_i=new_P12_bud
QR12_i=new_R12_bud
PQ12_i=new_Q12_bud
NP13_i=new_P13_bud
PR13_i=new_R13_bud
OQ13_i=new_Q13_bud
QP21_i=new_P21_bud
SR21_i=new_R21_bud
RQ21_i=new_Q21_bud
OP23_i=new_P23_bud 
QR23_i=new_R23_bud
PQ23_i=new_Q23_bud
RP31_i=new_P31_bud
TR31_i=new_R31_bud
SQ31_i=new_Q31_bud
QP32_i=new_P32_bud
SR32_i=new_R32_bud
RQ32_i=new_Q32_bud

;P  *alter(J-1.)
;Q  *alter(J)
;R  *alter(J+1.)

for J=1.,lines-1. do                   P1_i(J)=P1_i(J)*alter(J)
for J=1.,lines-1. do                   R1_i(J)=R1_i(J)*alter(J+1)
for J=1.,lines-1. do                   Q1_i(J)=Q1_i(J)*alter(J+1)
for J=1.,lines-1. do                   P2_i(J)=P2_i(J)*alter(J)
for J=1.,lines-1. do                   R2_i(J)=R2_i(J)*alter(J+1)
for J=1.,lines-1. do                   Q2_i(J)=Q2_i(J)*alter(J+1)
for J=1.,lines-1. do                   P3_i(J)=P3_i(J)*alter(J+1)
for J=1.,lines-1. do                   R3_i(J)=R3_i(J)*alter(J+1)
for J=1.,lines-1. do                   Q3_i(J)=Q3_i(J)*alter(J)
for J=1.,lines-1. do                        OP12_i(J)=OP12_i(J)*alter(J+1)
for J=1.,lines-1. do                   QR12_i(J)=QR12_i(J)*alter(J)
for J=1.,lines-1. do                   PQ12_i(J)=PQ12_i(J)*alter(J)
for J=1.,lines-1. do                        NP13_i(J)=NP13_i(J)*alter(J+1)
for J=1.,lines-1. do                   PR13_i(J)=PR13_i(J)*alter(J)
for J=1.,lines-1. do                        OQ13_i(J)=OQ13_i(J)*alter(J+1)
for J=1.,lines-1. do                   QP21_i(J)=QP21_i(J)*alter(J)
for J=1.,lines-1. do                   SR21_i(J)=SR21_i(J)*alter(J+1)
for J=1.,lines-1. do                   RQ21_i(J)=RQ21_i(J)*alter(J+1)
for J=1.,lines-1. do                   OP23_i(J)=OP23_i(J)*alter(J+1)
for J=1.,lines-1. do                   QR23_i(J)=QR23_i(J)*alter(J)
for J=1.,lines-1. do                   PQ23_i(J)=PQ23_i(J)*alter(J)
for J=1.,lines-1. do RP31_i(J)=RP31_i(J)*alter(J)
for J=1.,lines-1. do TR31_i(J)=TR31_i(J)*alter(J+1)
for J=1.,lines-1. do SQ31_i(J)=SQ31_i(J)*alter(J)
for J=1.,lines-1. do QP32_i(J)=QP32_i(J)*alter(J)
for J=1.,lines-1. do SR32_i(J)=SR32_i(J)*alter(J)
for J=1.,lines-1. do                   RQ32_i(J)=RQ32_i(J)*alter(J)

;print,'###################################'
;print,'# Band N2 1P',fix(v1),fix(v2),'       done #'
;print,'###################################'

;;PLOT STATES - Triplet spin levels for Pi and Sigma states
;plot_states,lines,A_B_v, A_D_v, A_w, A_gamma,B_B_v, B_D_v, Y

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function njp,B_B_v,B_D_v,h,c,k,temp,J,Bu
;      ;  val = exp(-((B_B_v*J*(J+1.)-B_D_v*J^2.*(J+1.)^2.)*h*c)/(k*temp))
;  val = exp(-( (Bu*J*(J+1.))*h*c)/(k*temp))
;return,val
;end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function alter, J
  val = 1.+(j mod 2.)      ;ODD  J are strong
;  val = 1.+((j+1) mod 2.)  ;EVEN J are strong
return,val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function S_Q, J
;     ;  val =   ((J-1.)*(J+2.)*((2*J)+1.)) / (4*J*(J+1.))
;  val = 1.
;return, val
;end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function S_P, J
;     ;  val =  ((J+2.)*(J+3.))/(4*(J+1.)) 
;  val = 1.
;return, val
;end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;function S_R, J
;     ;  val =   ((J-1.)*(J-2.))/(4*J)
;  val = 1.
;return, val
;end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function nuva2leai, wavenumber_vacuum ;Wavenumber in vacuum to wavelength in air
                                      ;Lambda_vacuum=1/wavenumber_vacuum
  ;wavenumber_vacuum(where(wavenumber_vacuum eq 0.)) = !Values.F_NAN
  val =      (1/wavenumber_vacuum)   /          (1.+(643.28d-7)+ $
                    (294981d-7)/((146.d)-(wavenumber_vacuum)^2. )+ $
                      (2554d-7)/(( 41.d)-(wavenumber_vacuum)^2. )) $
                                               *1d8                ;[Angstroms]
;   val =(1/wavenumber_vacuum)*1e8 ; SIMPLISTIC
  
return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Pi3F1, B_B_v, B_D_v, Y, J1

    Z1 =  Y*(Y-4.)+(4/3.)+(4.*J1*(J1+1.))
    Z2 = (Y*(Y-1.)-(4/9.)-(2.*J1*(J1+1.)))/(3.*Z1)
;print, z1,z2,(J1*(J1+1.)) - sqrt(Z1)  - 2.*Z2,B_D_v*(J1-0.5)^4.
   val =  B_B_v*(  (J1*(J1+1.)) - sqrt(Z1)  - 2.*Z2) - B_D_v*(J1-0.5)^4.  ; -J1^2.*.022 -J1*0.15 -2.58
;val =  B_B_v*(J1*(J1+1.))

return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Pi3F2, B_B_v, B_D_v, Y, J1

    Z1 =  Y*(Y-4.)+(4/3.)+(4.*J1*(J1+1.))
    Z2 = (Y*(Y-1.)-(4/9.)-(2.*J1*(J1+1.)))/(3.*Z1)
   val =  B_B_v*(  (J1*(J1+1.))             + 4.*Z2) - B_D_v*(J1+0.5)^4.  ; -J1^2.*.022-J1*0.15 -3.5
;val =      B_B_v*(  J1*(J1+1.))

return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Pi3F3, B_B_v, B_D_v, Y, J1

    Z1 =  Y*(Y-4.)+(4/3.)+(4.*J1*(J1+1.))
    Z2 = (Y*(Y-1.)-(4/9.)-(2.*J1*(J1+1.)))/(3.*Z1)
   val =  B_B_v*(  (J1*(J1+1.)) + sqrt(Z1)    - 2.*Z2) - B_D_v*(J1+1.5)^4. ; +J1^2.*.00-J1*1.00 -1.5
;val =  B_B_v*(J1*(J1+1.))

return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Sigma3F1, A_B_v, A_D_v, A_w, A_gamma, J2

 val = A_B_v*J2*(J2-1.)      - A_D_v*J2^2.*(J2-1.)^2.     + $
                                      ((6.*A_w*J2)/(2.*(J2-1.)+3.)) - A_gamma*J2
;val = A_B_v*J2*(J2-1.)
return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Sigma3F2, A_B_v, A_D_v, A_w, A_gamma, J2

 val = A_B_v*J2*(J2+1.)      - A_D_v*J2^2.*(J2+1.)^2.
;val = A_B_v*J2*(J2+1.) 

return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
function Sigma3F3, A_B_v, A_D_v, A_w, A_gamma, J2

 val = A_B_v*(J2+1.)*(J2+2.) - A_D_v*(J2+1)^2.*(J2+2.)^2. + $
                                     ((6.*A_w*(J2+2.))/(2.*J2+1.)) - A_gamma*(J2+1)
;val = A_B_v*(J2+1.)*(J2+2.)
return, val
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
pro plot_states,lines,A_B_v, A_D_v, A_w, A_gamma,B_B_v, B_D_v, Y

window, 15,xsize=500,ysize=500
lim=(Pi3F3(B_B_v, B_D_v,Y, max(indgen(lines)+2)))
plot,fltarr(1),xstyle=1,ystyle=1,xrange=[0,lines+1],                  $
      yrange=[-50,1.05*lim],$
      title='Electron Spin Multiplet Energy', charsize=2.,            $
      xtitle='J', ytitle='Energy splitting [cm-1]', ticklen=.01

oplot, indgen(lines+1.)+1.,Sigma3F1 (A_B_v, A_D_v, A_w, A_gamma, indgen(lines+1.)+1.),thick=2
oplot, indgen(lines+1.)+1.,Sigma3F2 (A_B_v, A_D_v, A_w, A_gamma, indgen(lines+1.)+1.),thick=2
oplot, indgen(lines+1.)+1.,Sigma3F3 (A_B_v, A_D_v, A_w, A_gamma, indgen(lines+1.)+1.),thick=2
oplot, indgen(lines+2.)   ,Pi3F1    (B_B_v, B_D_v, Y, indgen(lines+2.))   ,linestyle=2,thick=2
oplot, indgen(lines+1.)+1.,Pi3F2    (B_B_v, B_D_v, Y, indgen(lines+1.)+1.),linestyle=2,thick=2
oplot, indgen(lines)+2.   ,Pi3F3    (B_B_v, B_D_v, Y, indgen(lines)+2.)   ,linestyle=2,thick=2

xyouts,lines*0.05,.9 *lim, '!E3!N!7P!I0!X',charsize=3
xyouts,lines*0.20,.9 *lim, '!E3!N!7P!I1!X',charsize=3
xyouts,lines*0.35,.9 *lim, '!E3!N!7P!I2!X',charsize=3
xyouts,lines*0.05,.75*lim, '!E3!N!7R!I0!X',charsize=3
xyouts,lines*0.20,.75*lim, '!E3!N!7R!I1!X',charsize=3
xyouts,lines*0.35,.75*lim, '!E3!N!7R!I2!X',charsize=3
plots,[lines*0.5, lines*.7],[ .77*lim, .77*lim],thick=2
plots,[lines*0.5, lines*.7],[ .92 *lim, .92 *lim],linestyle=2,thick=2

;plots,[0.,lines+1.],[0.,0.]

end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;#############################################################################################
;#############################################################################################
;#############################################################################################
;#############################################################################################
;#############################################################################################

pro HL_trial2,lines,Y,t,new_P11_bud,new_Q11_bud,new_R11_bud,new_P22_bud,new_Q22_bud,new_R22_bud,new_P33_bud,new_Q33_bud,new_R33_bud,new_P31_bud,new_Q31_bud,new_R31_bud,new_P32_bud,new_Q32_bud,new_R32_bud,new_P21_bud,new_Q21_bud,new_R21_bud,new_P23_bud,new_Q23_bud,new_R23_bud,new_P12_bud,new_Q12_bud,new_R12_bud,new_P13_bud,new_Q13_bud,new_R13_bud

div=6.
di=1.  ;1.5
mi=0
miQ=0.
mi2=1.

lines_recover=lines  ;to recover old value later...
lines=round((lines+1)*di+0.49)    ;80
;xrang_=12               ;had to y/6 and x/1.5 to make match, also -1 on J and 0,1,2 on start J numbers
;yrang1_=6 
;           B_alpha_e = 0.01793
;               B_B_e = 1.63772
;                  v1 = 5.
;A_v = 42.286    -    0.068*(v1+0.5)    $
;                - (2.5e-3)*(v1+0.5)^2. $
;                - (2.6e-4)*(v1+0.5)^3.
;  B_B_v = B_B_e-B_alpha_e *(v1+0.5)
;                   Y = A_v/B_B_v
     C3 =fltarr(lines+1)
     C2 =fltarr(lines+1)
     C1 =fltarr(lines+1)
     U1 =fltarr(lines+1)
     U3 =fltarr(lines+1)
P22_sch =fltarr(lines)
P22_bud =fltarr(lines)
P22_oma =fltarr(lines)
Q22_sch =fltarr(lines)
Q22_bud =fltarr(lines)
R22_sch =fltarr(lines)
R22_bud =fltarr(lines)
P22_her =fltarr(lines)
Q22_her =fltarr(lines)
R22_her =fltarr(lines)
P22_her2=fltarr(lines)
Q22_her2=fltarr(lines)
R22_her2=fltarr(lines)
P11_bud =fltarr(lines)
Q11_bud =fltarr(lines)
R11_bud =fltarr(lines)
P33_bud =fltarr(lines)
Q33_bud =fltarr(lines)
R33_bud =fltarr(lines)
P31_bud =fltarr(lines)
Q31_bud =fltarr(lines)
R31_bud =fltarr(lines)
P32_bud =fltarr(lines)
Q32_bud =fltarr(lines)
R32_bud =fltarr(lines)
P21_bud =fltarr(lines)
Q21_bud =fltarr(lines)
R21_bud =fltarr(lines)
P23_bud =fltarr(lines)
Q23_bud =fltarr(lines)
R23_bud =fltarr(lines)
P12_bud =fltarr(lines)
Q12_bud =fltarr(lines)
R12_bud =fltarr(lines)
P13_bud =fltarr(lines)
Q13_bud =fltarr(lines)
R13_bud =fltarr(lines)

for J=0,lines   do U1(J) = sqrt(Y*(Y-4.)+4.*J^2.)
for J=0,lines   do U3(J) = sqrt(Y*(Y-4.)+4.*(J+1.)^2.)
for J=0,lines   do C1(J) = Y*(Y-4.)*J*(J+1.)+2*(2*J+1.)*(J-1.)*J*(J+1.)+(Y-2.)*sqrt((Y-2.)^2.+4.*(J-1.)*(J+1.))-Y*(Y-4.)+4.*J
for J=0,lines   do C2(J) = Y*(Y-4.)+4.*J*(J+1.)
for J=0,lines   do C3(J) = (J-1.)*(J+2.)*Y*(Y-4.)+2.*(2.*J+1.)*J*(J+1.)*(J+2.)
for J=0,lines-1 do P22_sch(J)=     (4.*(J-1.)^3.*(J+1.))        /(   J  *C2(J-1.))
for J=0,lines-1 do Q22_sch(J)=     (4.*(2.*J+1.)*(J^2.+J-1.)^2.)/(J*(J+1.)*C2(J))
for J=0,lines-1 do R22_sch(J)=     (4.*J*(J+2.)^3.)             /((J+1.)*C2(J+1.))
for J=0,lines-1 do P22_her(J)=     ((J+2.)*(J+3.))/(4.*(J+1.))
for J=0,lines-1 do Q22_her(J)=     ((J-1.)*(J+2.)*(2.*J+1.))/(4.*J*(J+1.))
for J=0,lines-1 do R22_her(J)=     ((J-1.)*(J-2.))/(4.*J)
for J=0,lines-1 do P22_her2(J)=    ((J+2.)*(J+3.))/(4.*(J+1.))
for J=0,lines-1 do Q22_her2(J)=    ((J-1.)*(J+2.)*(2.*J+1))/(4.*J*(J+1.))
for J=0,lines-1 do R22_her2(J)=    ((J+2.)*(J+3.))/(4.*(J+1.))
for J=0,lines-1 do R11_bud(J)=     ( (J^2.-1)*  ((J+1.)*U1(J)-Y+2.*J^2.)^2.               ) /   (       (2.*J-1.)*C1(J))
for J=0,lines-1 do Q11_bud(J)=     (( (J^2.+J-1.) * U1(J) + (Y-2.) + 2.*J*(J^2.-1))       ^2.) /   (           J    *C1(J))
for J=0,lines-1 do   P33_bud(J)=   ( J*(J*(J+2.) *U1(J)+(J+2.)*(Y-2.)+2.*(J-1.)*(J+1.)^2.)^2.) /   ((J+1.)*(2.*J+3.)*C1(J))
for J=0,lines-1 do R33_bud(J)=     ( (J+1.) * ((J^2.-1.)  *U3(J)+(J-1.)*(Y-2.)+2.*J^2.    *(J+2.))^2.)    /  (J*(2.*J-1)*C3(J))
for J=0,lines-1 do Q33_bud(J)=     (          ((J^2.+J-1.)*U3(J)-(Y-2.)       +2.*J*(J+1.)*(J+2.))^2.)    /  ((J+1.)    *C3(J))
for J=0,lines-1 do   P11_bud(J)=   (J*(J+2.)* (      J    *U3(J)-(Y-2.)       +2.*J*(J+2.)       )^2.)    /  ((2.*J+3.) *C3(J))
for J=0,lines-1 do P22_bud(J)=     (8.*J^3.*(J+2.))        /(   (J+1.)  *C2(J))
for J=0,lines-1 do Q22_bud(J)=     (8.*(2.*J+1.)*(J^2.+J-1.)^2.)/(J*(J+1.)*C2(J))
for J=0,lines-1 do R22_bud(J)=     (8.*(J-1.)*(J+1.)^3.)        /((J)*C2(J))
for J=0,lines-1 do R31_bud(J)=     ((J^2.-1.)*((J+1.)*U3(J)+(Y-2.)-2.*J*(J+2.))^2.)  / (       (2.*J-1.)*C3(J))
for J=0,lines-1 do Q31_bud(J)=     ((J^2.+J-1.)*U3(J)-(Y-2.)-2*J^2.*(J+2.))^2.    / (           J    *C3(J))
for J=0,lines-1 do P31_bud(J)=     (J*(J+2.)^2.*  (J*U3(J)-(Y-2.)-2.*J*(J+1.))^2.)   / ((J+1.)*(2.*J+3.)*C3(J))
for J=0,lines-1 do R32_bud(J)=     ((J^2.-1.)* (U3(J)+(J+1.)*(Y-2.)      )^2.)  / (           J    *C3(J))
for J=0,lines-1 do  Q32_bud(J)=    ((2.*J+1.)* ((J^2.+J-1.) *(Y-2.)-U3(J))^2.)  / (        J*(J+1.)*C3(J))
for J=0,lines-1 do P32_bud(J)=     ( J*(J+2.)* (      J     *(Y-2.)-U3(J))^2.)  / (          (J+1.)*C3(J))
for J=0,lines-1 do R21_bud(J)=     (2.*(J^2.-1.)*Y^2.)                 / (      (2.*J-1.)*C2(J))
for J=0,lines-1 do Q21_bud(J)=     (   2.*((J*(Y-2.))-2.       )^2.)   / (          J    *C2(J))
for J=0,lines-1 do P21_bud(J)=     (2.*J*((J+1.)*Y-2.*(2.*J+3.))^2.)   / ((J+1.)*(2*J+3.)*C2(J))
for J=0,lines-1 do R23_bud(J)=     (2.*(J+1.)*(J*(Y-4.)+2.)^2.)  / (J*(2.*J-1.)*C2(J))
for J=0,lines-1 do Q23_bud(J)=     (2.*((J+1.)*Y-2.*J)^2.)       / (     (J+1.)*C2(J))
for J=0,lines-1 do P23_bud(J)=     (2.*J*(J+2.)*Y^2.)            / (  (2.*J+3.)*C2(J))
for J=0,lines-1 do R12_bud(J)=     ( (J^2.-1.)* ((J+1.)     *(Y-2.)-U1(J))^2.)  /  (      J    *C1(J))
for J=0,lines-1 do  Q12_bud(J)=     ( (2.*J+1.)* ((J^2.+J-1.)*(Y-2.)+U1(J))^2.)  /  (J*   (J+1.)*C1(J))
for J=0,lines-1 do P12_bud(J)=     (  J*(J+2.)* (        J  *(Y-2.)+U1(J))^2.)  /  (     (J+1.)*C1(J))
for J=0,lines-1 do R13_bud(J)=    ( (J-1.)^2.*(J+1.)*((J+1.)*U1(J)-(Y-2.)-2.*     J*(J+1.)   )^2.)  /  (J*(2.*J-1.)*C1(J))
for J=0,lines-1 do Q13_bud(J)=    (             ((J^2.+J-1.)*U1(J)+(Y-2.)-2.*(J-1.)*(J+1.)^2.)^2.)  /  (     (J+1.)*C1(J))
for J=0,lines-1 do P13_bud(J)=    (  J*(J+2.)*(            J*U1(J)+ Y    -2.*J^2.            )^2.)  /  (  (2.*J+3.)*C1(J))

;;NEW THINGS

P22_bud=P22_bud/div
Q22_bud=Q22_bud/div
R22_bud=R22_bud/div
P11_bud=P11_bud/div
Q11_bud=Q11_bud/div
R11_bud=R11_bud/div
P33_bud=P33_bud/div
Q33_bud=Q33_bud/div
R33_bud=R33_bud/div
P31_bud=P31_bud/div
Q31_bud=Q31_bud/div
R31_bud=R31_bud/div
P32_bud=P32_bud/div
Q32_bud=Q32_bud/div
R32_bud=R32_bud/div
P21_bud=P21_bud/div
Q21_bud=Q21_bud/div
R21_bud=R21_bud/div
P23_bud=P23_bud/div
Q23_bud=Q23_bud/div
R23_bud=R23_bud/div
P12_bud=P12_bud/div
Q12_bud=Q12_bud/div
R12_bud=R12_bud/div
P13_bud=P13_bud/div
Q13_bud=Q13_bud/div
R13_bud=R13_bud/div
line_num=indgen(lines)/di-miQ-mi2

;!p.multi=[0,2,2]
;!p.charsize=1.5
;window,4,xsize=1200,ysize=800
  ;print, lines,di,miQ,mi2
new_lines=indgen(max(lines/di-miQ-mi2))
  ;print, new_lines
  ;stop
;for te=0,3 do begin
;t=200+200.*te
;print, t                                                ;max(new_lines)
;plot, fltarr(2),yrange=[0,1],ystyle=1,xstyle=1,xrange=[0,20],title='Intensity(T)=HL*BOLT(T)', xtitle='Quantum Number J, upper state', ytitle='Normalised intensity'


;INTERPOLATE
line_num(where(line_num lt 0.)) = 0.
P22_bud(where(P22_bud lt 0.)) = 0.
Q22_bud(where(Q22_bud lt 0.)) = 0.
R22_bud(where(R22_bud lt 0.)) = 0.
P11_bud(where(P11_bud lt 0.)) = 0.
Q11_bud(where(Q11_bud lt 0.)) = 0.
R11_bud(where(R11_bud lt 0.)) = 0.
P33_bud(where(P33_bud lt 0.)) = 0.
Q33_bud(where(Q33_bud lt 0.)) = 0.
R33_bud(where(R33_bud lt 0.)) = 0.
P31_bud(where(P31_bud lt 0.)) = 0.
Q31_bud(where(Q31_bud lt 0.)) = 0.
R31_bud(where(R31_bud lt 0.)) = 0.
P32_bud(where(P32_bud lt 0.)) = 0.
Q32_bud(where(Q32_bud lt 0.)) = 0.
R32_bud(where(R32_bud lt 0.)) = 0.
P21_bud(where(P21_bud lt 0.)) = 0.
Q21_bud(where(Q21_bud lt 0.)) = 0.
R21_bud(where(R21_bud lt 0.)) = 0.
P23_bud(where(P23_bud lt 0.)) = 0.
Q23_bud(where(Q23_bud lt 0.)) = 0.
R23_bud(where(R23_bud lt 0.)) = 0.
P12_bud(where(P12_bud lt 0.)) = 0.
Q12_bud(where(Q12_bud lt 0.)) = 0.
R12_bud(where(R12_bud lt 0.)) = 0.
P13_bud(where(P13_bud lt 0.)) = 0.
Q13_bud(where(Q13_bud lt 0.)) = 0.
R13_bud(where(R13_bud lt 0.)) = 0.

new_R13_bud=interpol  ( R13_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q13_bud=interpol  ( Q13_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P13_bud=interpol  ( P13_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R12_bud=interpol  ( R12_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q12_bud=interpol  ( Q12_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P12_bud=interpol  ( P12_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R23_bud=interpol  ( R23_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q23_bud=interpol  ( Q23_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P23_bud=interpol  ( P23_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R21_bud=interpol  ( R21_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q21_bud=interpol  ( Q21_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P21_bud=interpol  ( P21_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R31_bud=interpol  ( R31_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q31_bud=interpol  ( Q31_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P31_bud=interpol  ( P31_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R32_bud=interpol  ( R32_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q32_bud=interpol  ( Q32_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P32_bud=interpol  ( P32_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R11_bud=interpol  ( R11_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q11_bud=interpol  ( Q11_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P11_bud=interpol  ( P11_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R22_bud=interpol  ( R22_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q22_bud=interpol  ( Q22_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P22_bud=interpol  ( P22_bud*njp(indgen(lines),t) , line_num , new_lines)
new_R33_bud=interpol  ( R33_bud*njp(indgen(lines),t) , line_num , new_lines)
new_Q33_bud=interpol  ( Q33_bud*njp(indgen(lines),t) , line_num , new_lines)
new_P33_bud=interpol  ( P33_bud*njp(indgen(lines),t) , line_num , new_lines)

;print,             line_num , R13_bud*njp(indgen(lines),t) , indgen(max(indgen(lines)/di-miQ-mi2)) , new_int

normalise_sum =total(new_P12_bud)+total(new_Q12_bud)+total(new_R12_bud)+total(new_P13_bud)+total(new_Q13_bud)+total(new_R13_bud)+total(new_P21_bud)+total(new_Q21_bud)+total(new_R21_bud)+total(new_P31_bud)+total(new_Q31_bud)+total(new_R31_bud)+total(new_P32_bud)+total(new_Q32_bud)+total(new_R32_bud)+total(new_P23_bud)+total(new_Q23_bud)+total(new_R23_bud)+total(new_P11_bud)+total(new_Q11_bud)+total(new_R11_bud)+total(new_P22_bud)+total(new_Q22_bud)+total(new_R22_bud)+total(new_P33_bud)+total(new_Q33_bud)+total(new_R33_bud)

;normalise_sum=normalise_sum/66.7         ;66.7 is just to get the intensity to scale to 1.

new_R13_bud=new_R13_bud/normalise_sum
new_Q13_bud=new_Q13_bud/normalise_sum
new_P13_bud=new_P13_bud/normalise_sum
new_R12_bud=new_R12_bud/normalise_sum
new_Q12_bud=new_Q12_bud/normalise_sum
new_P12_bud=new_P12_bud/normalise_sum
new_R11_bud=new_R11_bud/normalise_sum
new_Q11_bud=new_Q11_bud/normalise_sum
new_P11_bud=new_P11_bud/normalise_sum

new_R23_bud=new_R23_bud/normalise_sum
;new_R23_bud(1:n_elements(new_R23_bud)-1.)=new_R23_bud(0:n_elements(new_R23_bud)-2.)
;new_R23_bud(0)=0.
new_Q23_bud=new_Q23_bud/normalise_sum
;new_Q23_bud(1:n_elements(new_Q23_bud)-1.)=new_Q23_bud(0:n_elements(new_Q23_bud)-2.)
;new_Q23_bud(0)=0.
new_P23_bud=new_P23_bud/normalise_sum
;new_P23_bud(1:n_elements(new_P23_bud)-1.)=new_P23_bud(0:n_elements(new_P23_bud)-2.)
;new_P23_bud(0)=0.
new_R21_bud=new_R21_bud/normalise_sum
;new_R21_bud(1:n_elements(new_R21_bud)-1.)=new_R21_bud(0:n_elements(new_R21_bud)-2.)
;new_R21_bud(0)=0.
new_Q21_bud=new_Q21_bud/normalise_sum
;new_Q21_bud(1:n_elements(new_Q21_bud)-1.)=new_Q21_bud(0:n_elements(new_Q21_bud)-2.)
;new_Q21_bud(0)=0.
new_P21_bud=new_P21_bud/normalise_sum
;new_P21_bud(1:n_elements(new_P21_bud)-1.)=new_P21_bud(0:n_elements(new_P21_bud)-2.)
;new_P21_bud(0)=0.
new_R22_bud=new_R22_bud/normalise_sum
;new_R22_bud(1:n_elements(new_R22_bud)-1.)=new_R22_bud(0:n_elements(new_R22_bud)-2.)
;new_R22_bud(0)=0.
new_Q22_bud=new_Q22_bud/normalise_sum
;new_Q22_bud(1:n_elements(new_Q22_bud)-1.)=new_Q22_bud(0:n_elements(new_Q22_bud)-2.)
;new_Q22_bud(0)=0.
new_P22_bud=new_P22_bud/normalise_sum
;new_P22_bud(1:n_elements(new_P22_bud)-1.)=new_P22_bud(0:n_elements(new_P22_bud)-2.)
;new_P22_bud(0)=0.

new_R32_bud=new_R32_bud/normalise_sum
;new_R32_bud(2:n_elements(new_R32_bud)-1.)=new_R32_bud(0:n_elements(new_R32_bud)-3.)
;new_R32_bud(0:1)=0.
new_Q32_bud=new_Q32_bud/normalise_sum
;new_Q32_bud(2:n_elements(new_Q32_bud)-1.)=new_Q32_bud(0:n_elements(new_Q32_bud)-3.)
;new_Q32_bud(0:1)=0.
new_P32_bud=new_P32_bud/normalise_sum
;new_P32_bud(2:n_elements(new_P32_bud)-1.)=new_P32_bud(0:n_elements(new_P32_bud)-3.)
;new_P32_bud(0:1)=0.
new_R31_bud=new_R31_bud/normalise_sum
;new_R31_bud(2:n_elements(new_R31_bud)-1.)=new_R31_bud(0:n_elements(new_R31_bud)-3.)
;new_R31_bud(0:1)=0.
new_Q31_bud=new_Q31_bud/normalise_sum
;new_Q31_bud(2:n_elements(new_Q31_bud)-1.)=new_Q31_bud(0:n_elements(new_Q31_bud)-3.)
;new_Q31_bud(0:1)=0.
new_P31_bud=new_P31_bud/normalise_sum
;new_P31_bud(2:n_elements(new_P31_bud)-1.)=new_P31_bud(0:n_elements(new_P31_bud)-3.)
;new_P31_bud(0:1)=0.
new_R33_bud=new_R33_bud/normalise_sum
;new_R33_bud(2:n_elements(new_R33_bud)-1.)=new_R33_bud(0:n_elements(new_R33_bud)-3.)
;new_R33_bud(0:1)=0.
new_Q33_bud=new_Q33_bud/normalise_sum
;new_Q33_bud(2:n_elements(new_Q33_bud)-1.)=new_Q33_bud(0:n_elements(new_Q33_bud)-3.)
;new_Q33_bud(0:1)=0.
new_P33_bud=new_P33_bud/normalise_sum
;new_P33_bud(2:n_elements(new_P33_bud)-1.)=new_P33_bud(0:n_elements(new_P33_bud)-3.)
;new_P33_bud(0:1)=0.


lines=lines_recover


end

;################################################
function njp,J,temp

    h   = 6.6606876e-34       ;[J][s]
    c   = (2.99792458e8)*1e2  ;[cm][s-2]
    k   = 1.3806503e-23       ;[J][K-1]
    Bu  = 1.98954             ;+/- .00003 N2 X ground state rotational constant
    val = exp(-( (Bu*J*(J+1.))*h*c)/(k*temp))
return,val
end
;################################################













