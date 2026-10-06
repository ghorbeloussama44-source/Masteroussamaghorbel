fn inistruct p q k=(
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:20 radius1:1 radius2:1 mapcoords:on pos:[0,0,0] isSelected:on

Sphere radius:0.5 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[0,0,20] isSelected:on
$Sphere001.parent=$Cone001
select #($Cone001,$Sphere001)
ch="S"+p as string +"_"+q as string+"_"+k as string+"_001"
group selection name:ch
ch="ENT"+p as string +"_"+q as string+"_"+k as string+"_001"
$Cone001.name=ch
ch="NOEUD"+p as string +"_"+q as string+"_"+k as string+"_001"
$Sphere001.name=ch
)
----------------------------------------------------------------------------------------------
fn reu p q=
(
if (p==1) and (q==2) then return 1
	if (p==1) and (q==3) then return 2
	if (p==2) and (q==3) then return 2

)
--------------------------------------------------------------

fn beu p q=
(
return 1
)
--------------------------------------------------------------------
fn iniTabp nomtab p q k=
(

execute(nomtab+"["+p as string+"]=#()")

)
fn iniTabq nomtab p q k=
(

execute(nomtab+"["+p as string+"]["+q as string+"]=#()")


)
fn iniTabk nomtab p q k=
(


execute(nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]=undefined")

)
fn iniTab nomtab p q k=
(

iniTabp nomtab p q k
iniTabq nomtab p q k
iniTabk nomtab p q k

)
fn ecriretab nomtab p q k ch=
(
cond1=execute("("+nomtab+"["+p as string+"]==undefined)")
if cond1 then (
iniTabp  nomtab p q k
)
cond2=execute("("+nomtab+"["+p as string+"]["+q as string+"]==undefined)")
if cond2 then (
iniTabq  nomtab p q k
)
print ch
ch2=nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]=\""+ch+"\""
print ch2
execute(ch2)
)

fn consulttab nomtab p q k=
(
cond1=execute("("+nomtab+"["+p as string+"]==undefined)")
if cond1 then (
iniTabp  nomtab p q k
)
cond2=execute("("+nomtab+"["+p as string+"]["+q as string+"]==undefined)")
if cond2 then (
iniTabq  nomtab p q k
)
ch2=nomtab+"["+p as string+"]["+q as string+"]["+k as string+"]"
print ch2
 return execute(ch2)
)


--TAB3=#()
--ch="ouiii"
--nomtab="TAB3"
--p=1
--q=2
--k=3
--c=ecriretab nomtab p q k ch


--ecriretab "TAB3" 2 4 5 ch
--ecriretab "TAB3" 1 1 3 ch
---------------------------------------------------------------------------------------------------------------







fn ini_S_base m=(
k=1
for i=1 to m do
(
Tab_S_base[i]=#()
for j=i to m do
(
Tab_S_base[i][j]=#()
inistruct i j 1
ch="S"+i as string +"_"+j as string+"_1_001"
print ch
Tab_S_base[i][j][k]=#()
Tab_S_base[i][j][k]=ch
)
)
)
------------------------------------------------------------------------------------------------
fn Copie_S_base groupename=(
clearselection()
ch="select $"+groupename
execute(ch)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
print nnl[1].name
return nnl[1].name
)
------------------------------------------------------------------------------------------------
fn Copie_mSb_base groupename=(
clearselection()
ch="select $"+groupename
execute(ch)
maxOps.cloneNodes $ cloneType:#copy newNodes:&nnl
select nnl
print nnl[1].name

)
------------------------------------------------------------------------------------------------
fn select_S_clone i j k=(
ch="S"+i as string +"_"+j as string+"_"+k as string+"_001"
if (Tab_S_base[i][j][k]!=undefined) then
 (Copie_S_base ch)
else
(Construire_S i j k)
)
-----------------------------------------------------------------------------------------------

fn select_mSb_clone i j k=(
ch="mSb"+i as string +"_"+j as string+"_"+k as string+"_001"
if (Tab_mSb_base[i][j][k]!=undefined) then
 (Copie_mSb_base ch)
else
(b=beu i j
Construire_mSb i j k b)
)
-----------------------------------------------------------------------------------------------
fn Construire_mSb p q k b=(
if (b==0) then (ch1=select_S_clone p q k)
else
(
bo=b-1
Construire_mSb p q k bo
ko=k-1
ch2=select_S_clone q q ko
ch1=Concat ch1 ch2
)
brep=beu p q
if (brep==b)then (
ch="mSb"+p as string +"_"+q as string+"_"+k as string+"_001"
execute(ch+"=ch1")
Tab_mSb_base[p][q][k]=ch
)
-------------------------------------------------------------------------------------------------
fn Construire_S p q k=(
ko=k-1
if (p>q)then (return)
if (p<q)then (
inistruct p q k
ch="S"+p as string +"_"+q as string+"_"+k as string+"_001"
print ch
Tab_S_base[i][j][k]=#()
Tab_S_base[i][j][k]=ch
)

)
-------------------------------------------------------------------------------------------------

Tab_S_base=#(#(#()))
--Tab_S_clone=#(#(#(#())))
Tab_mSb_base=#(#(#()))
ini_S_base 3



































-----------------------------------------------------------------------------------------------
fn Construire_mSb p q k b=(
if (b==0) then (ch1=select_S_clone p q k)
else
(
bo=b-1
Construire_mSb p q k bo
ko=k-1
ch2=select_S_clone q q ko
ch1=Concat ch1 ch2
)
brep=beu p q
if (brep==b)then (
ch="mSb"+p as string +"_"+q as string+"_"+k as string+"_001"
execute(ch+"=ch1")
nomtab="Tab_mSb_base"
ecriretab nomtab p q k ch
)
-------------------------------------------------------------------------------------------------
fn Construire_S p q k=(
if (p>q)then (
ch="undefined"

nomtab="Tab_S_base"
ecriretab nomtab p q k ch

)
if (p<q)then (
inistruct p q k
ch="S"+p as string +"_"+q as string+"_"+k as string+"_001"
print ch
nomtab="Tab_S_base"
ecriretab nomtab p q k ch
)

)
-------------------------------------------------------------------------------------------------


















-----------------------------------------------------------------------------------------------
fn Construire_mSbr p q k rs=
(
br=beu p q
if (rs==1) then (
cc2=select_mSb_clone p q k br
print "cc2"
print cc2
)
else
(
if (rs==2) then 
(
ro=rs-1
select_mSbr_clone p q k ro
--Construire_mSb p q k ro
print "cc2"
print cc2
ch2=select_mSb_clone p q k br
ch3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_001"
execute("concat2 \""+cc2 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
)
else
(
ro=rs-1
select_mSbr_clone p q k ro
--Construire_mSb p q k ro
ko=k-1
ch2=select_mSb_clone p q k br
ch3="mSbr"+p as string +"_"+q as string+"_"+k as string+"_001"
execute("concat2 \""+ch3 as string+"\" \""+ch2 as string+"\" \""+ch3 as string+"\"")
)





)
rep=reu p q
if (rep==rs)then (
ch="mSbr"+p as string +"_"+q as string+"_"+k as string+"_001"
--execute(ch+"=ch3")
nomtab="Tab_mSbr_base"
ecriretab nomtab p q k ch
)

------------------------------------------------------------------------------------------------
