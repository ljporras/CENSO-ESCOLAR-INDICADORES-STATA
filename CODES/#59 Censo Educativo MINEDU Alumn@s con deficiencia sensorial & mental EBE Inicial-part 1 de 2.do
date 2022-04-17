clear all
cd "D:\Censo2017"

*Importar los archivos del formato dbf a Stata
import dbase Matricula_01.DBF, clear
save         Matricula_01.dta, replace

use "Matricula_01.dta", clear
tab NROCED
tab NROCED CUADRO

*Seleccionamos solo los que estan matriculados en EBE
keep if NROCED=="8AI" 
*Cédula: 
*8AI – Educación Básica Especial Inicial Escolarizada y No Escolarizada

keep if CUADRO=="C201" 
*Identifica el número de cuadro de cada cédula: 
*201. Matrícula en educación inicial, por edad atendida y sexo, según tipo de deficiencia. 

order D*, last  //opcional, solo acomoda las variables
rename TIPDATO tipdato

egen hsum=rowtotal(D01 D02 D03 D04 D05 D06 D07 D08 D09 D10 D11 D12 D13 D14 D15 D16)
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

*TIPDATO: Tipo de deficiencia 
bysort tipdato: egen mat=sum(hsum)

*me quedo con una observacion por tipo de deficiencia
duplicates drop tipdato, force

*me quedo con las 5 categorias "generales" de tipo de deficiencia
keep if tipdato=="01" | tipdato=="08" | tipdato=="13" | tipdato=="14" | tipdato=="20"

*Sumatoria de alumn@s matriculados de cero a siete años
egen summat=sum(mat)

*tipdato 08: Deficiencia Sensorial 
gen  mat_08  =mat if tipdato=="08"
gen  ratio_08=mat_08/summat*100
tab  ratio_08

*tipdato 01: Deficiencia Mental 
gen  mat_01  =mat if tipdato=="01"
gen  ratio_01=mat_01/summat*100
tab  ratio_01