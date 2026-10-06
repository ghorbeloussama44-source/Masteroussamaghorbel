
fn inistruct p q k=
(
-- "inistruct"
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:20 radius1:1 radius2:1 mapcoords:on pos:[0,0,0] isSelected:on

Sphere radius:0.5 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[0,0,20] isSelected:on
$Sphere001.parent=$Cone001
select #($Cone001,$Sphere001)
ch1="S"+p as string +"_"+q as string+"_"+k as string+"_001"
group selection name:ch1
ch2="ENT"+p as string +"_"+q as string+"_"+k as string+"_001"
$Cone001.name=ch2
ch3="NOEUD"+p as string +"_"+q as string+"_"+k as string+"_001"
$Sphere001.name=ch3
execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
)
----------------------------------------------------------------------------------------------

--------------------------------------------------------------


--------------------------------------------------------------------
fn iniTabp nomtab p q k=
(
-- "iniTabp"
execute(nomtab+"["+p as string+"]=#()")

)
fn iniTabq nomtab p q k=
(
-- "iniTabq"
execute(nomtab+"["+p as string+"]["+q as string+"]=#()")


)
fn iniTabk nomtab p q k=
(
--

execute(nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]=undefined")

)
fn iniTab nomtab p q k=
(
-- "iniTab"
iniTabp nomtab p q k
iniTabq nomtab p q k
iniTabk nomtab p q k

)
fn ecriretab nomtab p q k ch=
(
-- "ecriretab"
cond1=execute("("+nomtab+"["+p as string+"]==undefined)")
if cond1 then (
iniTabp  nomtab p q k
)
cond2=execute("("+nomtab+"["+p as string+"]["+q as string+"]==undefined)")
if cond2 then (
iniTabq  nomtab p q k
)
-- ch
ch2=nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]=\""+ch+"\""
-- ch2
execute(ch2)
)

fn consulttab nomtab p q k=
(
-- "consulttab"
cond1=execute("("+nomtab+"["+p as string+"]==undefined)")
if cond1 then (
iniTabp  nomtab p q k
)
cond2=execute("("+nomtab+"["+p as string+"]["+q as string+"]==undefined)")
if cond2 then (
iniTabq  nomtab p q k
)
ch2=nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]"
-- ch2
 return execute(ch2)
)


--TAB3=#()
--ch="ouiii"
--nomtab="TAB3"
--p=1
--q=2
--k=3
--c=ecriretab nomtab p q k ch

--consulttab "TAB3" 2 2 2
--ecriretab "TAB3" 2 4 5 ch
--ecriretab "TAB3" 1 1 3 ch
---------------------------------------------------------------------------------------------------------------

fn nombre ch=
(
-- "nombre"
local nb
nb=ch[ch.count-2]+ch[ch.count-1]+ch[ch.count]
nb as integer
)
fn racine ch=
(
-- "racine"
chx as string
chx=""+ch as string+""

-- chx
chx[chx.count]=""
chx[chx.count]=""
chx[chx.count]=""
chx[chx.count]=""
chx as string
)
------------------------------------------------------------------------------------------------------------





fn ini_S_base m=
(
-- "ini_S_base"
k=1
for i=1 to m do
(

for j=i to m do
(

inistruct i j 1
ch="S"+i as string +"_"+j as string+"_1_001"
-- ch

nomtab="Tab_S_base"
ecriretab nomtab i j k ch
)
)
)

------------------------------------------------------------------------------------------------
fn Copie_S_base groupename=
(
-- "Copie_S_base"
-- groupename
local ch1
local ch2
local ch3
clearselection()
ch1=execute(groupename+".nomstructure")
-- groupename
-- ch1
nb1=nombre ch1
ch1s=racine ch1
-- groupename
-- ch1s
-- nb1
ch2=execute(groupename+".elementbase")
nb2=nombre ch2
ch2s=racine ch2
-- ch2s
-- nb2
ch3=execute(groupename+".elementsommet")
nb3=nombre ch3
ch3s=racine ch3
-- ch3s
-- nb3
ch="select $"+ch1
-- ch
execute(ch)

for i=1 to $.count do
(
if ($[i].name==ch1) then (indice1=i)
if ($[i].name==ch2) then (indice2=i)
if ($[i].name==ch3) then (indice3=i)

)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
-- nnl[1].name
ch1=nnl[indice1].name
ch2=nnl[indice2].name
ch3=nnl[indice3].name



-- ch2
-- ch1
-- ch3

execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
ch1
)
------------------------------------------------------------------------------------------------
fn Copie_mSb_base groupename=
(
-- "Copie_mSb_base"
local ch1
local ch2
local ch3
clearselection()
ch1=execute(groupename+".nomstructure")
nb1=nombre ch1
ch1s=racine ch1
ch2=execute(groupename+".elementbase")
nb2=nombre ch2
ch2s=racine ch2
ch3=execute(groupename+".elementsommet")
nb3=nombre ch3
ch3s=racine ch3
ch="select $"+ch1
execute(ch)

for i=1 to $.count do
(
-- "element de groupe"
-- $[i].name
-- ch1
-- ch2
-- ch3
if ($[i].name==ch1) then (indice1=i)
if ($[i].name==ch2) then (indice2=i)
if ($[i].name==ch3) then (indice3=i)
-- indice1
-- indice2
-- indice3

)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
-- nnl[1].name
ch1=nnl[indice1].name
ch2=nnl[indice2].name
ch3=nnl[indice3].name

-- ch2
-- ch1
-- ch3

execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
ch1
)
-------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
fn Copie_mSbr_base groupename=
(
-- "Copie_mSbr_base"
local ch1
local ch2
local ch3
clearselection()
ch1=execute(groupename+".nomstructure")
nb1=nombre ch1
ch1s=racine ch1
ch2=execute(groupename+".elementbase")
nb2=nombre ch2
ch2s=racine ch2
ch3=execute(groupename+".elementsommet")
nb3=nombre ch3
ch3s=racine ch3
ch="select $"+ch1
execute(ch)
for i=1 to $.count do
(
if ($[i].name==ch1) then (indice1=i)
if ($[i].name==ch2) then (indice2=i)
if ($[i].name==ch3) then (indice3=i)

)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
-- nnl[1].name
ch1=nnl[indice1].name
ch2=nnl[indice2].name
ch3=nnl[indice3].name

-- ch2
-- ch1
-- ch3

execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
ch1
)
-------------------------------------------------------------------------------------------------
fn Copie_R_base groupename=
(
-- "Copie_R_base"
local ch1
local ch2
local ch3
clearselection()
ch1=execute(groupename+".nomstructure")
nb1=nombre ch1
ch1s=racine ch1
ch2=execute(groupename+".elementbase")
nb2=nombre ch2
ch2s=racine ch2
ch3=execute(groupename+".elementsommet")
nb3=nombre ch3
ch3s=racine ch3
ch="select $"+ch1
execute(ch)
for i=1 to $.count do
(
if ($[i].name==ch1) then (indice1=i)
if ($[i].name==ch2) then (indice2=i)
if ($[i].name==ch3) then (indice3=i)

)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
-- nnl[1].name
ch1=nnl[indice1].name
ch2=nnl[indice2].name
ch3=nnl[indice3].name

-- ch2
-- ch1
-- ch3

execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
ch1
)
--------------------------------------------------------------------
fn Copie_T_base groupename=
(
-- "Copie_T_base"
local ch1
local ch2
local ch3
clearselection()
ch1=execute(groupename+".nomstructure")
nb1=nombre ch1
ch1s=racine ch1
ch2=execute(groupename+".elementbase")
nb2=nombre ch2
ch2s=racine ch2
ch3=execute(groupename+".elementsommet")
nb3=nombre ch3
ch3s=racine ch3
ch="select $"+ch1
execute(ch)
for i=1 to $.count do
(
if ($[i].name==ch1) then (indice1=i)
if ($[i].name==ch2) then (indice2=i)
if ($[i].name==ch3) then (indice3=i)

)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
-- nnl[1].name
ch1=nnl[indice1].name
ch2=nnl[indice2].name
ch3=nnl[indice3].name

-- ch2
-- ch1
-- ch3

execute(ch1+"=elementstructure \""+ch1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
ch1
)
--------------------------------------------------------------------------------------------------------
fn concat1 e1 e2 aaa=
( 

ch=e2+".nomstructure"
che2=execute(ch)
ch=e1+".nomstructure"
che1=execute(ch)

-- "concat1"
-- "concat e2"
-- e2
ch=e2+".elementsommet"
-- "concat che2sommet"
-- ch

fff=execute(ch)
-- "concat e2 sommet"
-- fff	
ch=e2+".elementbase"
-- "concat che2base"
-- ch
	ddd=execute(ch)
-- "concat e2 base"
-- ddd
-- "concat e1"
-- e1
ch=e1+".elementsommet"
-- "concat che1sommet"
-- ch
	ccc=execute(ch)
-- "concat e1 sommet"
-- ccc
ch=e1+".elementbase"
-- "concat che1base"
-- ch
bbb=execute(ch)
-- "concat e1 base"
-- bbb
	
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
if (angX==90) then (angX=-90)else (angX=90)
execute("rotate $"+ddd as string+" (angleaxis 45 [1,0,0])")
execute("$"+ddd as string+".parent=$"+ccc as string)
-- "concat groupname"
-- aaa
-- "concat selection"
ch="select #($"+che1 as string+",$"+che2 as string+")"
-- ch


execute(ch)
group selection name:aaa
	
ch=aaa+"=elementstructure \""+aaa as string+"\" \""+bbb as string+"\" \""+ccc as string+"\""
-- "concat structure"
-- ch
execute(ch)

	
)

-----------------------------------------------------------------------------------------------
--------------------------------------------------------------------
fn concat2 e1 e2 aaa=
( -- "concat2"
ch=e2+".nomstructure"
che2=execute(ch)
ch=e1+".nomstructure"
che1=execute(ch)


-- "concat e2"
-- e2
ch=e2+".elementsommet"
-- "concat che2sommet"
-- ch

fff=execute(ch)
-- "concat e2 sommet"
-- fff	
ch=e2+".elementbase"
-- "concat che2base"
-- ch
	ddd=execute(ch)
-- "concat e2 base"
-- ddd
-- "concat e1"
-- e1
ch=e1+".elementsommet"
-- "concat che1sommet"
-- ch
	ccc=execute(ch)
-- "concat e1 sommet"
-- ccc
ch=e1+".elementbase"
-- "concat che1base"
-- ch
bbb=execute(ch)
-- "concat e1 base"
-- bbb
if (angZ==0) then (angZ=180)else (angZ=0)	
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
execute("rotate $"+ddd as string+" (angleaxis "+angZ as string+" [0,0,1])")
execute("rotate $"+ddd as string+" (angleaxis 0 [1,0,0])")
execute("$"+ddd as string+".parent=$"+ccc as string)
-- "concat groupname"
-- aaa
-- "concat selection"
ch="select #($"+che1 as string+",$"+che2 as string+")"
-- ch

execute(ch)
group selection name:aaa
	
ch=aaa+"=elementstructure \""+aaa as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)

	

)


-----------------------------------------------------------------------------------------------
--------------------------------------------------------------------
fn concat3 e1 e2 aaa=
( -- "concat3"
ch=e2+".nomstructure"
che2=execute(ch)
ch=e1+".nomstructure"
che1=execute(ch)


-- "concat e2"
-- e2
ch=e2+".elementsommet"
-- "concat che2sommet"
-- ch

fff=execute(ch)
-- "concat e2 sommet"
-- fff	
ch=e2+".elementbase"
-- "concat che2base"
-- ch
	ddd=execute(ch)
-- "concat e2 base"
-- ddd
-- "concat e1"
-- e1
ch=e1+".elementsommet"
-- "concat che1sommet"
-- ch
	ccc=execute(ch)
-- "concat e1 sommet"
-- ccc
ch=e1+".elementbase"
-- "concat che1base"
-- ch
bbb=execute(ch)
-- "concat e1 base"
-- bbb
if (angZ==0) then (angZ=180)else (angZ=0)	
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
execute("rotate $"+ddd as string+" (angleaxis "+angZ as string+" [0,0,1])")
execute("rotate $"+ddd as string+" (angleaxis 0 [1,0,0])")
-- "concat groupname"
-- aaa
-- "concat selection"
ch="select #($"+che1 as string+",$"+che2 as string+")"
-- ch

execute(ch)
group selection name:aaa
	
ch=aaa+"=elementstructure \""+aaa as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)

	

)


-----------------------------------------------------------------------------------------------
fn Construire_S p q k=
(
local p
local q
local k
-- "Construire_S"

if (p>q)then (
ch="undefined"
nomtabS="Tab_S_base"
ecriretab nomtabS p q k ch
ch
)
if (p<q)then (
inistruct p q k
ch="S"+p as string +"_"+q as string+"_"+k as string+"_001"
-- ch
nomtabS="Tab_S_base"
ecriretab nomtabS p q k ch
ch
)
if (p==q)then (

tauxp=(consulttab "Tab_tauxp_base" p 1 1) as integer
mup=(consulttab "Tab_mup_base" p 1 1) as integer
if (p==dimensionauto)then
(
inistruct p q k
)
else
(
if (k==1) then
(
inistruct p q k
)
if (k>tauxp) then 
(
ko=k-tauxp
ch2=(select_S_clone mup mup ko)
cc3=(select_T_clone p k)
ch3="S"+p as string +"_"+q as string+"_"+k as string+"_001"
print "assembler TS"
print  cc3
print ch2
print ch3
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
)
if (k>1) and (k<(tauxp+1)) then
(

ko=k-1
ch2=(select_S_clone p p ko)
cc2=(select_R_clone p k)
ch3="S"+p as string +"_"+q as string+"_"+k as string+"_001"
print " concat ici"
cc2="R"+p as string+"_"+k as string+"_001"
print "assembler RS"
print  cc2
print ch2
print ch3
execute("concat2 \""+cc2 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
)

)
ch="S"+p as string +"_"+q as string+"_"+k as string+"_001"
-- ch
nomtabS="Tab_S_base"
ecriretab nomtabS p q k ch
ch
)
-- ch
print "S construit"
print ch
ch
)
-------------------------------------------------------------------------------------------------
fn select_S_clone i j k=
(
-- "Select_S_clone"
chS="S"+i as string +"_"+j as string+"_"+k as string+"_001"
-- chS
nomtabS="Tab_S_base"
d=consulttab nomtabS i j k
if (d!=undefined) then
 (Copie_S_base chS)
else
(Construire_S i j k)
-- "S construit"
-- chS
)

-------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------
fn Construire_mSb p q k mb=
(
local cc1
local ch2
local ch3
local p 
local q 
local k
local mb

local ko
-- "Construire_mSb"
brep=(consulttab "Tab_bpq_base" p q 1 )as integer
if (mb==0) then (
-- "icccccccccccccccccccccccccccccccccccccccccccccccccccccciiiiiiiiiiiiiiiiiii"
chm="mSb"+p as string +"_"+q as string+"_"+k as string+"_"+mb as string+"_001"
cc1=select_S_clone p q k
chcc=cc1+".elementbase"
bbb=execute(chcc)
chcc=cc1+".elementsommet"
fff=execute(chcc)
chcc=cc1+".nomstructure"
chcc1=execute(chcc)
-- cc1
-- chcc
-- chcc1
chc="select $"+chcc1 as string
-- chc
execute(chc)
group selection name:chm
-- chm
ch=chm+"=elementstructure \""+chm as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)
chm="mSb"+p as string +"_"+q as string+"_"+k as string+"_"+mb as string+"_001"
chm
-- chm
return chm
)

if (mb<brep) and (mb>0) then 
(

-- "Construire_mSb bo"
bo=(mb-1)
-- bo
-- "select_mSb_clone"
cc1=Construire_mSb p q k bo
ko=(k-1)
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir1"
-- "cc1"
-- cc1
ch2=select_S_clone q q ko
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir2"
-- "ch2"
-- ch2
ch3="mSb"+p as string +"_"+q as string+"_"+k as string+"_"+mb as string+"_001"
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir3"
-- "cc1"
-- cc1
-- "ch2"
-- ch2
-- "ch3"
-- ch3
execute("concat1 \""+cc1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
return ch3
)
if (brep==mb)then (
bo=(mb-1)
cc1=Construire_mSb p q k bo
ko=(k-1)
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir4"
-- "cc1"
-- cc1
-- "ch2"
-- ch2
-- "ch3"
-- ch3
ch2=select_S_clone q q ko
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir5"
-- "cc1"
-- cc1
-- "ch2"
-- ch2
-- "ch3"
-- ch3
ch3="mSb"+p as string +"_"+q as string+"_"+k as string+"_001"
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir6"
-- "cc1"
-- cc1
-- "ch2"
-- ch2
-- "ch3"
-- ch3
execute("concat1 \""+cc1 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- "voooooooooooooooiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiir7"
-- "cc1"
-- cc1
-- "ch2"
-- ch2
-- "ch3"
-- ch3

nomtabmSb="Tab_mSb_base"
ecriretab nomtabmSb p q k ch3
-- ch3
return ch3
)
if (brep<mb) then
(
Construire_mSb p q k brep

)
)
------------------------------------------------------------------------------------------------
fn select_mSb_clone i j k bmS=
(
local nomtabmSb
-- "select_mSb_clone"
chmSb="mSb"+i as string +"_"+j as string+"_"+k as string+"_001"
nomtabmSb="Tab_mSb_base"
d=consulttab nomtabmSb i j k
if (d!=undefined) then
 (Copie_mSb_base chmSb)
else
(
Construire_mSb i j k bmS)
)

-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------


fn Construire_mSbr p q k rs=
(

local ko
-- "Construire_mSbr"
br=(consulttab "Tab_bpq_base" p q 1) as integer
rep=(consulttab "Tab_rpq_base" p q 1) as integer
if (rs==1) then (
-- "icccccccccccccccccccccccccccccccccccccccccccccccccccccciiiiiiiiiiiiiiiiiii"
chmSbr3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_"+rs as string+"_001"
cc3=(select_mSb_clone p q k br)
chcc=cc3+".elementbase"
bbb=execute(chcc)
chcc=cc3+".elementsommet"
fff=execute(chcc)
ch=cc3+".nomstructure"
chcc3=execute(ch)
chc3="select $"+chcc3 as string
execute(chc3)
group selection name:chmSbr3
-- chmSbr3
ch=chmSbr3+"=elementstructure \""+chmSbr3 as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)
chmSbr3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_"+rs as string+"_001"
chmSbr3
-- chmSbr3
return chmSbr3
)

if (rs<rep) and (rs>1) then 
(

-- "Construire_mSbr bo"
ro=(rs-1)
-- ro
-- "select_mSbr_clone"
cc3=(Construire_mSbr p q k ro)
ko=(k-1)
-- "cc2"
-- cc3
ch2=(select_mSb_clone p q k br)
ch3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_"+rs as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
return ch3
)
if (rs==rep)then (
ro=(rs-1)
-- ro
-- "select_mSbr_clone"
cc3=(Construire_mSbr p q k ro)
ko=(k-1)
-- "cc3"
-- cc3
ch2=(select_mSb_clone p q k br)
ch3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
nomtabmSbr="Tab_mSbr_base"
ecriretab nomtabmSbr p q k ch3
-- ch3
return ch3
)
if (rep<rs) then
(
(Construire_mSbr p q k brep)

)
)


-------------------------------------------------------------------------------------------------------


fn select_mSbr_clone i j k bmSr=
(
-- "select_mSbr_clone"
chmSbr="mSbr"+i as string +"_"+j as string+"_"+k as string+"_001"
nomtabmSbr="Tab_mSbr_base"
d=consulttab nomtabmSbr i j k
if (d!=undefined) then
 (Copie_mSbr_base chmSbr)
else
(
Construire_mSbr i j k bmSr)
)
------------------------------------------------------------------------------------------------

fn Construire_R p k indice=
(
-- "Construire_R"
-- "p"
-- p
-- "k"
-- k
-- "indice"
-- indice

local qo
qo=(indice) as integer
indicef=dimensionauto
-- "indicef"
-- indicef
indicei=p+1
-- "indicei"
-- indicei
rep=(consulttab "Tab_rpq_base" p qo 1) as integer
if (indice==indicei) then (
if (indicei==indicef) then (
-- "icccccccccccccccccccccccccccccccccccccccccccccccccccccciiiiiiiiiiiiiiiiiii"
chmSbr3="R"+p as string +"_"+k as string+"_001"
cc3=(select_mSbr_clone p qo k rep)
chcc=cc3+".elementbase"
bbb=execute(chcc)
chcc=cc3+".elementsommet"
fff=execute(chcc)
ch=cc3+".nomstructure"
chcc3=execute(ch)
chc3="select $"+chcc3 as string
execute(chc3)
group selection name:chmSbr3
-- chmSbr3
ch=chmSbr3+"=elementstructure \""+chmSbr3 as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)
chmSbr3="R"+p as string +"_"+k as string+"_001"
chmSbr3
-- "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR111111111111111111111111111111111111111"
-- chmSbr3

return chmSbr3
)
else
(
-- "icccccccccccccccccccccccccccccccccccccccccccccccccccccciiiiiiiiiiiiiiiiiii"
chmSbr3="R"+p as string +"_"+k as string+"_"+indice as string+"_001"
cc3=(select_mSbr_clone p qo k rep)
chcc=cc3+".elementbase"
bbb=execute(chcc)
chcc=cc3+".elementsommet"
fff=execute(chcc)
ch=cc3+".nomstructure"
chcc3=execute(ch)
chc3="select $"+chcc3 as string
execute(chc3)
group selection name:chmSbr3
-- chmSbr3
ch=chmSbr3+"=elementstructure \""+chmSbr3 as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)
chmSbr3="R"+p as string +"_"+k as string+"_"+indice as string+"_001"
chmSbr3
-- "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRR222222222222222222222222222222222222222222222"
-- chmSbr3
nomtabmSbr="Tab_R_base"
ecriretab nomtabmSbr p 1 k chmSbr3
-- chmSbr3
return chmSbr3
)


)

if (indice<indicef) and (indice>indicei) then 
(

-- "Construire_R bo"
indiceo=(indice-1)
-- indiceo
-- "select_R_clone"
cc3=(Construire_R p k indiceo)
-- "cc3"
-- cc3
qo=(indice) as integer
rep=(consulttab "Tab_rpq_base" p qo 1) as integer
ch2=(select_mSbr_clone p qo k rep)
ch3="R"+p as string +"_"+k as string+"_"+indice as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
return ch3
)
if (indice==indicef)then (
ro=(rs-1)
-- ro
-- "select_R_clone"
indiceo=(indice-1)
cc3=(Construire_R p k indiceo)
ko=(k-1)
-- "cc3"
-- cc3
qo=(indice) as integer
rep=(consulttab "Tab_rpq_base" p qo 1) as integer
ch2=(select_mSbr_clone p qo k rep)
ch3="R"+p as string +"_"+k as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
nomtabmSbr="Tab_R_base"
ecriretab nomtabmSbr p 1 k ch3
-- ch3
return ch3
)
if (indicef<indice) then
(
(Construire_R p k indicef)

)
)

---------------------------------------------------------------------------------------------
fn select_R_clone i k =
(
-- "select_R_clone"
chR="R"+i as string +"_"+k as string+"_001"
-- chR
nomtabmSbr="Tab_R_base"
d=consulttab nomtabmSbr i 1 k
if (d!=undefined) then
 (Copie_R_base chR)
else
(
indicef=(dimensionauto) as integer
-- "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR"
-- indicef
Construire_R i k indicef)
-- "R construit"
-- chR
)

---------------------------------------------------------------------------------------------

fn Construire_T p k indice=
(
-- "Construire_T"
tauxp=(consulttab "Tab_tauxp_base" p 1 1) as integer
indicef=(k) as integer
indicei=k-tauxp+1

if (indice==indicei) then (
-- "icccccccccccccccccccccccccccccccccccccccccccccccccccccciiiiiiiiiiiiiiiiiii"
chmSbr3="T"+p as string +"_"+k as string+"_"+indice as string+"_001"
ko=(indice)
cc3=(select_R_clone p ko)
chcc=cc3+".elementbase"
bbb=execute(chcc)
chcc=cc3+".elementsommet"
fff=execute(chcc)
ch=cc3+".nomstructure"
chcc3=execute(ch)
chc3="select $"+chcc3 as string
execute(chc3)
group selection name:chmSbr3
-- chmSbr3
ch=chmSbr3+"=elementstructure \""+chmSbr3 as string+"\" \""+bbb as string+"\" \""+fff as string+"\""
-- "concat structure"
-- ch
execute(ch)
chmSbr3="T"+p as string +"_"+k as string+"_"+indice as string+"_001"
chmSbr3
-- chmSbr3
return chmSbr3
)

if (indice<indicef) and (indice>indicei) then 
(

-- "Construire_T bo"
indiceo=(indice-1)
-- indiceo
-- "select_T_clone"
cc3=(Construire_T p k indiceo)
-- "cc3"
-- cc3
ko=indice
ch2=(select_R_clone p ko)
ch3="T"+p as string +"_"+k as string+"_"+indice as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
return ch3
)
if (indice==indicef)then (
indiceo=(indice-1)
-- indiceo
-- "select_T_clone"
cc3=(Construire_T p k indiceo)

-- "cc3"
-- cc3
ko=indice
ch2=(select_R_clone p ko)
ch3="T"+p as string +"_"+k as string+"_001"
execute("concat2 \""+cc3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
-- ch3
nomtabmSbr="Tab_R_base"
ecriretab nomtabmSbr p q k ch3
-- ch3
return ch3
)
if (indicef<indice) then
(
(Construire_T p k indicef)

)
)
-------------------------------------------------------------------------------------------------------
fn select_T_clone i k =
(
-- "select_R_clone"
chR="T"+i as string +"_"+k as string+"_001"
nomtabmSbr="Tab_T_base"
d=consulttab nomtabmSbr i 1 k
if (d!=undefined) then
 (Copie_T_base chR)
else
(
tauxp=(consulttab "Tab_tauxp_base" i 1 1) as integer
indicef=(k) as integer
-- "TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT"
-- indicef
Construire_T i k indicef)
)

---------------------------------------------------------------------------------------------
global p
global q
global k
global rs
rs=2
global ro
global brep
global br
global bo
global indice1
global indice2
global indice3
global dimensionauto
global indicef
global indicei

dimensionauto=3 as integer

indice1=1 as integer
indice2=2 as integer
indice3=3 as integer
global cc1
cc1="test"
global rep
global cc2
cc2="test2"
global angX
angX=90
global angZ
angZ=0


struct elementstructure (nomstructure,elementbase, elementsommet)
Tab_rpq_base=#()
Tab_bpq_base=#()
Tab_tauxp_base=#()
Tab_mup_base=#()
p=1
q=1
k=1
ch="5"
ecriretab "Tab_tauxp_base" p q k ch
p=2
q=1
k=1
ch="3"
ecriretab "Tab_tauxp_base" p q k ch
p=3
q=1
k=1
ch="1"
ecriretab "Tab_tauxp_base" p q k ch
p=1
q=1
k=1
ch="2"
ecriretab "Tab_mup_base" p q k ch
p=2
q=1
k=1
ch="3"
ecriretab "Tab_mup_base" p q k ch
p=3
q=1
k=1
ch="3"
ecriretab "Tab_mup_base" p q k ch
p=1
q=2
k=1
ch="1"
ecriretab "Tab_rpq_base" p q k ch
p=1
q=3
k=1
ch="2"
ecriretab "Tab_rpq_base" p q k ch
p=2
q=3
k=1
ch="2"
ecriretab "Tab_rpq_base" p q k ch
p=1
q=2
k=1
ch="1"
ecriretab "Tab_bpq_base" p q k ch
p=1
q=3
k=1
ch="1"
ecriretab "Tab_bpq_base" p q k ch
p=2
q=3
k=1
ch="1"
ecriretab "Tab_bpq_base" p q k ch
Tab_S_base=#()
Tab_mSb_base=#()
Tab_mSbr_base=#()
Tab_R_base=#()
Tab_T_base=#()
--ini_S_base 3
--select_S_clone 1 1 2
--select_S_clone 2 2 2
--select_S_clone 3 3 2
--select_S_clone 1 2 1
--select_S_clone 1 3 1
--select_S_clone 2 3 1
--select_mSb_clone 1 3 2 1
--select_mSb_clone 1 2 2 1
--cc3=select_mSbr_clone 1 2 2 1
--ccnv=select_mSbr_clone 1 3 2 2
--ch3="R"+p as string +"_"+k as string+"_001"
--execute("concat2 \""+cc3 as string+"\" \""+ccnv as string+"\" \""+ch3 as string+"\"")

--select_S_clone 2 2 2
select_T_clone 2 4
