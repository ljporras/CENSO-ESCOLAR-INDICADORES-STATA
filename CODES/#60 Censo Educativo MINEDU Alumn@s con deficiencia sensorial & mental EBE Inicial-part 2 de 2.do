Hola a tod@s, en este video comparto la segunda parte del ejercicio en Stata utilizando el Censo Educativo del 2017. Incluye la sintaxis para estimar dos indicadores a nivel nacional. 
1. Porcentaje de alumn@s con deficiencia sensorial - Educación Básica Especial (EBE) Inicial Escolarizada y No Escolarizada 
2. Porcentaje de alumn@s con deficiencia mental - Educación Básica Especial (EBE) Inicial Escolarizada y No Escolarizada 

Fuente:
MINEDU-ESCALE
Gracias a Gustavo Espinoza Peralta por compartir la sintaxis.
***************
clear all
cd "E:\Censo2017"

use         Matricula_01.dta, clear

*Seleccionamos solo los que estan matriculados en EBE
keep if NROCED=="8AI" 
*Cédula: 
*8AI – Educación Básica Especial Inicial Escolarizada y No Escolarizada

keep if CUADRO=="C201" 
*Identifica el número de cuadro de cada cédula: 
*201. Matrícula en educación inicial, por edad atendida y sexo, según tipo de deficiencia. 

*Tipo de gestion
gen		gestion=1 if substr(GES_DEP,1,1)=="A" | GES_DEP==""
replace gestion=2 if substr(GES_DEP,1,1)=="B"
lab def	gestion_num 1 "Publico" 2 "Privado" 
lab val gestion gestion_num

*Crear variable demografica
gen		area=1 if AREA_MED=="1" 
replace area=2 if AREA_MED=="2" 
lab var area "Ambito"
lab def	area_num 1 "Urbano" 2 "Rural" 
lab val area area_num

*D01: Alumnos hombres de cero años
*D02: Alumnos mujeres de cero años
*D03: Alumnos hombres de un año
*D04: Alumnos mujeres de un año
*D05: Alumnos hombres de dos años
*D06: Alumnos mujeres de dos años
*D07: Alumnos hombres de tres años
*D08: Alumnos mujeres de tres años
*D09: Alumnos hombres de cuatro años
*D10: Alumnos mujeres de cuatro años
*D11: Alumnos hombres de cinco años
*D12: Alumnos mujeres de cinco años
*D13: Alumnos hombres de seis años
*D14: Alumnos mujeres de seis años
*D15: Alumnos hombres de siete años
*D16: Alumnos mujeres de siete años

*total matriculados
egen hsum=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16)

*Tipo de gestion
egen hsum_pu=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16) if gestion==1
egen hsum_pr=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16) if gestion==2

*Sexo 
egen hsum_h=rowtotal(D01 D03 D05 D07 D09 D11 D13 D15)
egen hsum_m=rowtotal(D02 D04 D06 D08 D10 D12 D14 D16) 

*Area de residencia
egen hsum_u=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16) if area==1
egen hsum_r=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16) if area==2

*Area de residencia y sexo
egen hsum_u_m=rowtotal(D02 D04 D06 D08 D10 D12 D14 D16) if area==1
egen hsum_u_h=rowtotal(D01 D03 D05 D07 D09 D11 D13 D15) if area==1

egen hsum_r_m=rowtotal(D02 D04 D06 D08 D10 D12 D14 D16) if area==2
egen hsum_r_h=rowtotal(D01 D03 D05 D07 D09 D11 D13 D15) if area==2

*Me quedo con las 5 categorias "generales" de tipo de deficiencia
rename TIPDATO tipdato
keep if tipdato=="01" | tipdato=="08" | tipdato=="13" | tipdato=="14" | tipdato=="20"

*TIPDATO: Tipo de deficiencia 
bysort tipdato: egen mat=sum(hsum)
bysort tipdato: egen mat_pu=sum(hsum_pu)
bysort tipdato: egen mat_pr=sum(hsum_pr)

bysort tipdato: egen mat_m=sum(hsum_m)
bysort tipdato: egen mat_h=sum(hsum_h)

bysort tipdato: egen mat_u=sum(hsum_u)
bysort tipdato: egen mat_r=sum(hsum_r)

bysort tipdato: egen mat_u_m=sum(hsum_u_m)
bysort tipdato: egen mat_u_h=sum(hsum_u_h)

bysort tipdato: egen mat_r_m=sum(hsum_r_m)
bysort tipdato: egen mat_r_h=sum(hsum_r_h)

keep mat* tipdato

*me quedo con una observacion por tipo de deficiencia
duplicates drop

*Sumatoria de alumn@s matriculados de cero a siete años
egen summat  =sum(mat)

egen summat_pu=sum(mat_pu)
egen summat_pr=sum(mat_pr)

egen summat_m=sum(mat_m)
egen summat_h=sum(mat_h)

egen summat_u=sum(mat_u)
egen summat_r=sum(mat_r) 

egen summat_u_m=sum(mat_u_m)
egen summat_u_h=sum(mat_u_h)

egen summat_r_m=sum(mat_r_m) 
egen summat_r_h=sum(mat_r_h) 

********************************************************************
*tipdato 08: Deficiencia Sensorial 
gen  mat_08      =mat if tipdato=="08"
gen  ratio_08    =mat_08/summat *100

gen  mat_pu_08    =mat_pu     if tipdato=="08"
gen  ratio_pu_08  =mat_pu_08/summat_pu *100

gen  mat_pr_08    =mat_pr     if tipdato=="08"
gen  ratio_pr_08  =mat_pr_08/summat_pr *100

gen  mat_m_08    =mat_m     if tipdato=="08"
gen  ratio_m_08  =mat_m_08/summat_m *100

gen  mat_h_08    =mat_h     if tipdato=="08"
gen  ratio_h_08  =mat_h_08/summat_h *100

gen  mat_u_08    =mat_u     if tipdato=="08"
gen  ratio_u_08  =mat_u_08/summat_u *100

gen  mat_r_08    =mat_r     if tipdato=="08"
gen  ratio_r_08  =mat_r_08/summat_r *100

gen  mat_u_h_08    =mat_u_h     if tipdato=="08"
gen  ratio_u_h_08  =mat_u_h_08/summat_u_h *100

gen  mat_r_h_08    =mat_r_h     if tipdato=="08"
gen  ratio_r_h_08  =mat_r_h_08/summat_r_h *100

gen  mat_u_m_08    =mat_u_m     if tipdato=="08"
gen  ratio_u_m_08  =mat_u_m_08/summat_u_m *100

gen  mat_r_m_08    =mat_r_m     if tipdato=="08"
gen  ratio_r_m_08  =mat_r_m_08/summat_r_m *100

*etiquetando las variables
label var ratio_08 "Deficiencia sensorial"
label var ratio_pu_08 "Def. sensorial - G.Publica"
label var ratio_pr_08 "Def. sensorial - G.Privada"
label var ratio_m_08 "Def. sensorial - Femenino"
label var ratio_h_08 "Def. sensorial - Masculino"
label var ratio_u_08 "Def. sensorial - Urbana"
label var ratio_r_08 "Def. sensorial - Rural"
label var ratio_u_m_08 "Def. sensorial - Urbana Femenino"
label var ratio_u_h_08 "Def. sensorial - Urbana Masculino"
label var ratio_r_m_08 "Def. sensorial - Rural Femenino"
label var ratio_r_h_08 "Def. sensorial - Rural Masculino"

*resultados
tab  ratio_08
tab  ratio_pu_08
tab  ratio_pr_08
tab  ratio_m_08
tab  ratio_h_08
tab  ratio_u_08
tab  ratio_r_08
tab  ratio_u_m_08
tab  ratio_u_h_08
tab  ratio_r_m_08
tab  ratio_r_h_08

********************************************************************
*tipdato 01: Deficiencia Mental 
gen  mat_01      =mat if tipdato=="01"
gen  ratio_01    =mat_01/summat *100

gen  mat_pu_01    =mat_pu     if tipdato=="01"
gen  ratio_pu_01  =mat_pu_01/summat_pu *100

gen  mat_pr_01    =mat_pr     if tipdato=="01"
gen  ratio_pr_01  =mat_pr_01/summat_pr *100

gen  mat_m_01    =mat_m     if tipdato=="01"
gen  ratio_m_01  =mat_m_01/summat_m *100

gen  mat_h_01    =mat_h     if tipdato=="01"
gen  ratio_h_01  =mat_h_01/summat_h *100

gen  mat_u_01    =mat_u     if tipdato=="01"
gen  ratio_u_01  =mat_u_01/summat_u *100

gen  mat_r_01    =mat_r     if tipdato=="01"
gen  ratio_r_01  =mat_r_01/summat_r *100

gen  mat_u_h_01    =mat_u_h     if tipdato=="01"
gen  ratio_u_h_01  =mat_u_h_01/summat_u_h *100

gen  mat_r_h_01    =mat_r_h     if tipdato=="01"
gen  ratio_r_h_01  =mat_r_h_01/summat_r_h *100

gen  mat_u_m_01    =mat_u_m     if tipdato=="01"
gen  ratio_u_m_01  =mat_u_m_01/summat_u_m *100

gen  mat_r_m_01    =mat_r_m     if tipdato=="01"
gen  ratio_r_m_01  =mat_r_m_01/summat_r_m *100

*etiquetando las variables
label var ratio_01 "Deficiencia mental"
label var ratio_pu_01 "Def. mental - G.Publica"
label var ratio_pr_01 "Def. mental - G.Privada"
label var ratio_m_01 "Def. mental - Femenino"
label var ratio_h_01 "Def. mental - Masculino"
label var ratio_u_01 "Def. mental - Urbana"
label var ratio_r_01 "Def. mental - Rural"
label var ratio_u_m_01 "Def. mental - Urbana Femenino"
label var ratio_u_h_01 "Def. mental - Urbana Masculino"
label var ratio_r_m_01 "Def. mental - Rural Femenino"
label var ratio_r_h_01 "Def. mental - Rural Masculino"

*resultados
tab  ratio_01
tab  ratio_pu_01
tab  ratio_pr_01
tab  ratio_m_01
tab  ratio_h_01
tab  ratio_u_01
tab  ratio_r_01
tab  ratio_u_m_01
tab  ratio_u_h_01
tab  ratio_r_m_01
tab  ratio_r_h_01