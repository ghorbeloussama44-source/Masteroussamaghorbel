


global p
global q
global k

fn gotname_cone p q k=(print ("ENT"+p as string+"_"+q as string+"_"+k as string))

fn gotname_sphere p q k=(print ("Noeud"+p as string+"_"+q as string+"_"+k as string)	)
fn gotname_structure p q k=(print ("STRUCTURE"+p as string+"_"+q as string+"_"+k as string)	)
fn gotname_METAM p q k j=(
	"MET"+p as string+"_"+q as string+"_"+k as string+"_"+j as string
	)
fn gotname_S p q k i j=(
		"S"+p as string+"_"+q as string+"_"+k as string+"_"+i as string+"_"+j as string
		)
fn gotname_R_det p q k i j=(
	"R"+p as string+"_"+q as string+"_"+k as string+"_"+i as string+"_"+j as string
	)
fn gotname_R_moy p q k j=(print ("R"+p as string+"_"+q as string+"_"+k as string+"_"+j as string))
fn gotname_R_all p q k=(print("Rall"+p as string+"_"+q as string+"_"+k as string))








fn draw_primitive_cone p q L ebase esommet=(
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:L radius1:ebase radius2:esommet mapcoords:on pos:[0,0,0] isSelected:on
)


fn draw_primitive_sphere p q L ebase esommet=(
Sphere radius:esommet smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[0,0,L] isSelected:on
)

fn draw_primitive_structure p q L ebase esommet=(


draw_primitive_cone p q L ebase esommet

draw_primitive_sphere p q L ebase esommet
$Sphere001.parent=$Cone001
$COne001.wirecolor=(color (random 0 255) (random 0 255) (random 0 255))
$Sphere001.wirecolor=$Cone001.wirecolor
k=0
$Cone001.name=gotname_cone p q k

$Sphere001.name=gotname_sphere p q k
)


fn draw_allprimitive_structure nomb=( 
local bn
local cn
local an

for i =1 to nomb do (
for j =i to nomb do (
draw_primitive_structure i j 10 1 1
k=0
bn=gotname_cone i j k
cn=gotname_sphere i j k
an=gotname_structure i j k
chc=(an+"=elementstructure \""+an as string+"\" \""+bn as string+"\" \""+cn as string+"\"")
print chc
execute(chc)
if (tab!=undefined) then
(execute("tab[tab.count+1]="+an))
else
(execute("tab=#("+an+")"))




)
)
)

-----------------------------------------------------------------
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
fn concat1 e1 e2 aaa=
( ch=e2+".elementsommet"
fff=execute(ch)
	
	--f=e2.elementsommet
ch=e2+".elementbase"
	ddd=execute(ch)
	--d=e2.elementbase
ch=e1+".elementsommet"
	ccc=execute(ch)

	--c=e1.elementsommet
ch=e1+".elementbase"
bbb=execute(ch)
	--b=e1.elementbase
	
	--d.pos.x=c.pos.x
	--d.pos.y=c.pos.y
	--d.pos.z=c.pos.z
	--d.parent=c
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
execute("rotate $"+ddd as string+" (angleaxis 90 [1,0,0])")
execute("$"+ddd as string+".parent=$"+ccc as string)
--execute("e3=elementstructure \""+aaa+"\" \""+bbb+"\" \""+ccc+"\"")
	e3=elementstructure aaa bbb ccc
	return e3
)
fn concat2 e1 e2 aaa=
( ch=e2+".elementsommet"
fff=execute(ch)
	
	--f=e2.elementsommet
ch=e2+".elementbase"
	ddd=execute(ch)
	--d=e2.elementbase
ch=e1+".elementsommet"
	ccc=execute(ch)

	--c=e1.elementsommet
ch=e1+".elementbase"
bbb=execute(ch)
	--b=e1.elementbase
	
	--d.pos.x=c.pos.x
	--d.pos.y=c.pos.y
	--d.pos.z=c.pos.z
	--d.parent=c
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
execute("$"+ddd as string+".parent=$"+ccc as string)
--execute("e3=elementstructure \""+aaa+"\" \""+bbb+"\" \""+ccc+"\"")
	e3=elementstructure aaa bbb fff
	return e3
)

fn concat12 e1 e2 aaa=
( ch=e2+".elementsommet"
fff=execute(ch)
	
	--f=e2.elementsommet
ch=e2+".elementbase"
	ddd=execute(ch)
	--d=e2.elementbase
ch=e1+".elementsommet"
	ccc=execute(ch)

	--c=e1.elementsommet
ch=e1+".elementbase"
bbb=execute(ch)
	--b=e1.elementbase
	
	--d.pos.x=c.pos.x
	--d.pos.y=c.pos.y
	--d.pos.z=c.pos.z
	--d.parent=c
execute("$"+ddd as string+".pos.x=$"+ccc as string+".pos.x")
execute("$"+ddd as string+".pos.y=$"+ccc as string+".pos.y")	
execute("$"+ddd as string+".pos.z=$"+ccc as string+".pos.z")
execute("$"+ddd as string+".parent=$"+ccc as string)
--execute("e3=elementstructure \""+aaa+"\" \""+bbb+"\" \""+ccc+"\"")
	e3=elementstructure aaa bbb ccc
	return e3
)
---------------------------------------------------------------------
fn draw_elemR p q k g j=(


(ko=k-1)
(a=gotname_structure p q ko)
	(b=execute(a+".elementbase"))   
     (c=execute(a+".elementsommet"))	
(execute("select #($"+c as string+",$"+b as string+")"))
(maxOps.cloneNodes $ cloneType:#instance newNodes:&aa)
(Me=gotname_METAM p q k j)
(Mename=gotname_METAM p q k j)
(aaname=aa[2].name)
(aaname2=aa[1].name)
(execute(Me+"=elementstructure Mename aaname aaname2"))
for i=1 to g do
(
(a=gotname_structure q q ko)
(b=execute(a+".elementbase"))

(c=execute(a+".elementsommet"))	
(execute("select #($"+c as string+",$"+b as string+")"))
(maxOps.cloneNodes $ cloneType:#instance newNodes:&bb)
(Se=gotname_S p q k i j)
	(Sename=gotname_S p q k i j)
(bbname=bb[2].name)
(bbname2=bb[1].name)
(execute(Se+"=elementstructure Sename bbname bbname2"))
(Rename=gotname_R_det p q k i j)
(Re=gotname_R_det p q k i j)
print Rename
print Sename
print Mename
print Re
execute(Re+"=concat1 \""+Mename+"\" \""+Sename+"\" \""+Rename+"\"")
if (tab!=undefined) then
(tab[tab.count+1]=Se
tab[tab.count+1]=Me
tab[tab.count+1]=Rename)

if (j>1) then
(
sd=j-1
Rallnv=gotname_R_moy p q k j
Rname=gotname_R_det p q k i j
Rallanc=gotname_R_moy p q k sd
--Rallnv=concat1 Rallnv Rname Rallnv
--execute(Rallnv+"=concat1 Rallnv Rname Rallnv")
execute(Rallnv+"=concat12 \""+Rallanc+"\" \""+Rname+"\" \""+Rallnv+"\"")
if (tab!=undefined) then
(tab[tab.count+1]=Rallnv)

)
else
(Rallnv=gotname_R_moy p q k j
execute(Rallnv+"="+Rename)
)
)
)
-----------------------------------------------------------------------
------------------------------------------------------------------------
fn drawR p k =
(
h=3
sdd=p+1
for q=sdd to h do 
(
g=beu p q
f=reu p q
for j=1 to 2 do
(

draw_elemR p q k g j

Rallelem=gotname_R_moy p q k j
print "salut"
print Rallelem
sooo=execute(Rallelem)

print sooo

)
print sdd
print q
print (q>sdd)

if (q==sdd) then
(
print "entrer2"
print sooo

print Rallelem
Rallelem=gotname_R_moy p q k 2
print Rallelem

Rall=gotname_R_all p q k
print Rall
print Rallelem
ch=(Rall+"="+Rallelem)
print ch
execute(Rall+"="+Rallelem)
print "Bonjour"
print Rall


)
if (q>sdd) then
(
print "entrer1"
sd=q-1
Rall=gotname_R_all p q k
Ralla=gotname_R_all p sd k
Rallelem=gotname_R_moy p q k 2
print Rallelem

execute(Rall+"=concat2 \""+Ralla+"\" \""+Rallelem+"\" \""+Rall+"\"")
print "Boboboobooob"
print Rall

if (tab!=undefined) then
(tab[tab.count+1]=Rallelem)


)


)

)
--execute("R_"+p+"_"+k+"=concat2 "+"R_"+p+"_"+k+" "+"R_"+p+"_"+k+" "+"R_"+p+"_"+k)

--if (Rallanc2!=undefined) then
--(Rall=concat1 Rallanc2 Rall Sall)
--Rallanc2=Rall
--execute("R_"+p+"_"+k+"=concat2 "+"R_"+p+"_"+k+" "+"R_"+p+"_"+k+" "+"R_"+p+"_"+k)








struct elementstructure (nomstructure,elementbase, elementsommet)
draw_allprimitive_structure 3

--draw_elemR 1 3 1 1 1