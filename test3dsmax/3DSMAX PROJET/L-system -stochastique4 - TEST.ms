
global axiome
struct structregle(lettre,mot,nbprob,sommeprob,prob,minprob,maxprob)
struct structorientation(corx,cory,corz,tetax,tetay,tetaz,nameliaison)
struct structdeflettre(lettre,type,hauteur,longueur,largeur,adresse,posx,posy,posz,rotx,roty,rotz)
struct structcroiss(lettrec,long,varlong,rayonbas,varrayonbas,rayonhaut,varrayonhaut)
struct structang(lettrea,ang,varang)
global phyllotaxieactif
global enregistrephyllotaxieactifx
enregistrephyllotaxieactifx=0
global enregistrephyllotaxieactify
enregistrephyllotaxieactify=0
global enregistrephyllotaxieactifz
enregistrephyllotaxieactifz=0
phyllotaxieactif=0
global angbranch
global angphyllo
global matricerotx
global matriceroty
global matricerotz
global ancquattransform
global frequence
frequence=#()
global frequenceetat
frequenceetat=#()
global frequencetotal
frequencetotal=0
global quattransform

matricerotx=#()
matriceroty=#()
matricerotz=#()
global vectk
global vectj
vectk=#()
vectj=#()
angbranch=0
angphyllo=0
global ageplante
global variablecrois
global variableang
variablecrois=#()
variableang=#()
global ageaxiome
global reg
global reg0
global t
global ancienw
reg0=#()
reg=#()
global matrans
--matrans=#(#(1,0,0,0),#(0.2,0.6,0.1,0.1),#(0,0.013,0.88,0.107),#(0,0,0.75,0.25))
--matrans=#(#(1,0),#(0,1))
--debmatrans=#(0,0,1,0)
--debmatrans=#(1,1)
matrans=#()
debmatrans=#()
global nombrereg
nombrereg=0
global commande
global addcom
global formobjitem
commande=#()
global enregistrequaternion
enregistrequaternion=#(quat 0 0 0 1)
ancquattransform=quat 0 0 0 1
quattransform=quat 0 0 0 1
global enregistreorientation
global ang
global varang
global somprob
global ranreg
global resLsys
global tpas
global tlimite
global delta
global paramang
global paramlong
global paramepb
global parameps
delta=1.25
tpas=100
resLsys=""
ang=0
varang=0
enregistreorientation=#(structorientation 0 0 0 0 0 0 "")

fn multi debm matr=
(
mul=#()
for i=1 to debm.count do
(
mul[i]=0
for j=1 to debm.count do
(
if j==i then
(if matr[j][i]==undefined then (matr[j][i]=1))
else
(if matr[j][i]==undefined then (matr[j][i]=0))
mul[i]=mul[i]+debm[j]*matr[j][i]
)
)
mul
)

fn calculeprob reg3=
(
local reg3
for j=1 to reg3.count do
(
reg3[j].sommeprob=undefined
reg3[j].prob=undefined
reg3[j].minprob=undefined
reg3[j].maxprob=undefined
)
for j=1 to reg3.count do
(
somprob=0

for k=1 to reg3.count do
(
if reg3[j].lettre==reg3[k].lettre then
(
somprob=somprob+reg3[k].nbprob
)
)
reg3[j].sommeprob=somprob
)
for j=1 to reg3.count do
(
if reg3[j].sommeprob!=0 then
(
reg3[j].prob=reg3[j].nbprob *100 /reg3[j].sommeprob
)
)
for j=1 to reg3.count do
(
somprob=0
if reg3[j].minprob==undefined then
(
reg3[j].minprob=0
)
if reg3[j].maxprob==undefined then
(somprob=reg3[j].prob
reg3[j].maxprob=somprob

for k=j+1 to reg3.count do
(
if reg3[j].lettre==reg3[k].lettre then
(
print "oui"

reg3[k].minprob=somprob
somprob=somprob+reg3[k].prob
reg3[k].maxprob=somprob
)
)
)
)
)


fn verificationcommande orientation deblettre paramang=
(

if deblettre=="[" then
(
ori=structorientation orientation.corx orientation.cory orientation.corz orientation.tetax orientation.tetay orientation.tetaz orientation.nameliaison
enregistrequaternion[enregistrequaternion.count+1]=quattransform
enregistreorientation[enregistreorientation.count+1]=ori
)
if deblettre=="]" then
(
phyllotaxieactif=0
quattransform=enregistrequaternion[enregistrequaternion.count]
orientation.corx=enregistreorientation[enregistreorientation.count].corx
orientation.cory=enregistreorientation[enregistreorientation.count].cory
orientation.corz=enregistreorientation[enregistreorientation.count].corz
orientation.tetax=enregistreorientation[enregistreorientation.count].tetax
orientation.tetay=enregistreorientation[enregistreorientation.count].tetay
orientation.tetaz=enregistreorientation[enregistreorientation.count].tetaz
orientation.nameliaison=enregistreorientation[enregistreorientation.count].nameliaison
if enregistrequaternion.count==1 then
(
)
else
(
enregistrequaternion.count=enregistrequaternion.count-1
)
if enregistreorientation.count==1 then
(
)
else
(
enregistreorientation.count=enregistreorientation.count-1
)
)
if deblettre=="!" then
(
angphyllo=0
phyllotaxieactif=1
enregistrephyllotaxieactifx=orientation.tetax
enregistrephyllotaxieactify=orientation.tetay
enregistrephyllotaxieactifz=orientation.tetaz
angphyllo=angphyllo+ paramang 
)
if deblettre=="@" then
(
angphyllo=mod angphyllo 360
phyllotaxieactif=1
enregistrephyllotaxieactifx=orientation.tetax
enregistrephyllotaxieactify=orientation.tetay
enregistrephyllotaxieactifz=orientation.tetaz
angphyllo=angphyllo+ paramang 
)
if deblettre=="#" then
(
phyllotaxieactif=1
enregistrephyllotaxieactifx=orientation.tetax
enregistrephyllotaxieactify=orientation.tetay
enregistrephyllotaxieactifz=orientation.tetaz
angbranch=angbranch+paramang 

)
if deblettre=="+" then
(
orientation.tetax=orientation.tetax + paramang 
)
if deblettre=="-" then
(
orientation.tetax=orientation.tetax - paramang
)
if deblettre=="&" then
(
orientation.tetay=orientation.tetay + paramang
)
if deblettre=="^" then
(
print "iccccccccccciiiiiii ^"
orientation.tetay=orientation.tetay - paramang
)
if deblettre==">" then
(
orientation.tetaz=orientation.tetaz + paramang
)
if deblettre=="<" then
(
orientation.tetaz=orientation.tetaz - paramang
)
)

fn calcullongueur let n exact=
(


t=n 

h=0
varh=0
varh3=0
varh2=0
for i=1 to variablecrois.count do(

if variablecrois[i].lettrec==let then
(

h=execute(variablecrois[i].long) 
varh=execute(variablecrois[i].varlong) 


)

)
if exact==1 then
(
varh=0
)
--varh2=varh*1000
--varh3=(random 0 varh2)-(random 0 varh2)
h=h+varh
h
)
fn calculrayonbas let n exact=
(
t=n
h=0
varh=0
varh3=0
varh2=0
for i=1 to variablecrois.count do(

if variablecrois[i].lettrec==let then
(
h=execute(variablecrois[i].rayonbas)
varh=execute(variablecrois[i].varrayonbas)

)

)
if exact==1 then
(
varh=0
)
--varh2=varh*1000
--varh3=(random 0 varh2)-(random 0 varh2)
h=h+varh
h
)
fn calculrayonhaut let n exact=
(
t=n
h=0
varh=0
varh3=0
varh2=0
for i=1 to variablecrois.count do(

if variablecrois[i].lettrec==let then
(
h=execute(variablecrois[i].rayonhaut)
varh=execute(variablecrois[i].varrayonhaut)

)

)
if exact==1 then
(
varh=0
)
--varh2=varh*1000
--varh3=(random 0 varh2)-(random 0 varh2)
h=h+varh
h
)
fn calculang let n exact=
(
t=n
h=0
varh=0
varh3=0
varh2=0
for i=1 to variableang.count do(
if variableang[i].lettrea==let then
(
h=execute(variableang[i].ang)
varh=execute(variableang[i].varang)
)
)
if exact==1 then
(
varh=0
)
--varh2=varh*1000
--varh3=(random 0 varh2)-(random 0 varh2)
h=h+varh
h
)

fn Ajustelong let l nb s=
(
nh=0
th=0
nb=1000
n=0

while ((nb-n)>1) do((d1=calcullongueur let n 1);(d2=calcullongueur let nb 1);(d1=d1-l);(d2=d2-l);(nb2=(nb+n)/2 as integer);(d3=calcullongueur let nb2 1);(d3=d3-l); if (d1*d3>0) then(n=nb2)else(nb=nb2))

d2=calcullongueur let nb 1
if (abs(d2-l)>0.1) then
(
th=0

)
else
(
th=1
nh=nb
)


if th==0 then
(
h=l
)
else
(
h=calcullongueur let (nh+s) 0
while (h<l) do
(
h=calcullongueur let (nh+s) 0
)
)
h
)

fn AjusteRayonbas let l nb s=
(
th=0
nh=0
nb=1000
n=0

while ((nb-n)>1) do((d1=calculrayonbas let n 1);(d2=calculrayonbas let nb 1);(d1=d1-l);(d2=d2-l);(nb2=(nb+n)/2 as integer);(d3=calculrayonbas let nb2 1);(d3=d3-l); if (d1*d3>0) then(n=nb2)else(nb=nb2))

d2=calculrayonbas let nb 1
if (abs(d2-l)>0.1) then
(
th=0

)
else
(
th=1
nh=nb
)


if th==0 then
(
h=l
)
else
(
h=calculrayonbas let (nh+s) 0
while (h<l) do
(
h=calculrayonbas let (nh+s) 0
)
)
h
)
fn AjusteRayonhaut let l nb s=
(
th=0
nh=0
nb=1000
n=0

while ((nb-n)>1) do((d1=calculrayonhaut let n 1);(d2=calculrayonhaut let nb 1);(d1=d1-l);(d2=d2-l);(nb2=(nb+n)/2 as integer);(d3=calculrayonhaut let nb2 1);(d3=d3-l); if (d1*d3>0) then(n=nb2)else(nb=nb2))

d2=calculrayonhaut let nb 1
if (abs(d2-l)>0.1) then
(
th=0

)
else
(
th=1
nh=nb
)


if th==0 then
(
h=l
)
else
(
h=calculrayonhaut let (nh+s) 0
while (h<l) do
(
h=calculrayonhaut let (nh+s) 0
)
print h
print "2"
)
h

)



fn Longueur t =
(
h=(20/(1+(20/ (10^(t)))))

h
)

fn epaisseurbase t =
(
eb=(1.5/(1+(1.5/((10)^(t)))))

eb
)
fn epaisseursommet t=
(
es=(1/(1+(1/((10)^(t)))))

es
)


fn evolstruct nombreiter Spname Coname orientation=
(

tdebut=(tlimite-(nombreiter*tpas))
tdebut2=tdebut+tpas
for t=0 to tdebut by tpas do
(
execute("select $"+Coname)
at time t $.height=0
at time t $.radius1=0
at time t $.radius2=0
execute("select $"+Spname)
at time t $.pos=[0,0,0]
at time t $.radius=0

)

for t=tdebut2 to tlimite by tpas do
(
tpos=(t-tdebut)
tpos2=tpos/tpas
h=(Longueur tpos2)
eb=(epaisseurbase tpos2)
es=(epaisseursommet tpos2) 
execute("select $"+Coname)
at time t $.height=h
at time t $.radius1=eb
at time t $.radius2=es
execute("select $"+Spname)
at time t $.pos=[0,0,h]
at time t $.radius=es

)
execute("$"+Spname+".parent=$"+Coname)
execute("select $"+Coname)
at time tdebut2 rotate $ (angleaxis orientation.tetax [1,0,0])
at time tdebut2  rotate $ (angleaxis orientation.tetay [0,1,0])
at time tdebut2  rotate $ (angleaxis orientation.tetaz [0,0,1])

)








fn definitionprogrammeur orientation deblettre nombreiter paramlong paramepb parameps=
(
if deblettre=="F" then
(
Sphere radius:parameps smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[orientation.corx,orientation.cory,orientation.corz+paramlong] isSelected:on
$.wirecolor=blue
Spname=$.name
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:paramlong radius1:paramepb radius2:parameps mapcoords:on pos:[orientation.corx,orientation.cory,orientation.corz] isSelected:on
$.wirecolor=blue
Coname=$.name
--------------
execute("$"+Spname+".parent=$"+Coname)
if phyllotaxieactif==0 then
(
rotate $ (angleaxis orientation.tetax [1,0,0])
rotate $ (angleaxis orientation.tetay [0,1,0])
rotate $ (angleaxis orientation.tetaz [0,0,1])
)
if phyllotaxieactif==1 then
(
rotate $ (angleaxis enregistrephyllotaxieactifx [1,0,0])
rotate $ (angleaxis enregistrephyllotaxieactify [0,1,0])
rotate $ (angleaxis enregistrephyllotaxieactifz [0,0,1])
vectk=#(0,0,1)
vectj=#(0,1,0)
matricerotx=#(#(1,0,0),#(0,cos enregistrephyllotaxieactifx,sin enregistrephyllotaxieactifx),#(0,-sin enregistrephyllotaxieactifx,cos enregistrephyllotaxieactifx))
matriceroty=#(#(cos enregistrephyllotaxieactify,0,-sin enregistrephyllotaxieactify),#(0,1,0),#(sin enregistrephyllotaxieactify,0,cos enregistrephyllotaxieactify))
matricerotz=#(#(cos enregistrephyllotaxieactifz,sin enregistrephyllotaxieactifz,0),#(-sin enregistrephyllotaxieactifz,cos enregistrephyllotaxieactifz,0),#(0,0,1))
vectk=multi vectk matricerotx
vectk=multi vectk matriceroty
vectk=multi vectk matricerotz
vectj=multi vectj matricerotx
vectj=multi vectj matriceroty
vectj=multi vectj matricerotz
print enregistrephyllotaxieactifx
print enregistrephyllotaxieactify
print enregistrephyllotaxieactifz
print angbranch
print angphyllo
chvectj=vectj[1] as string+" "+vectj[2] as string+" "+vectj[3] as string
chvectk=vectk[1] as string+" "+vectk[2] as string+" "+vectk[3] as string
print chvectj
print chvectk
print "Phylloooooooooooooooooooooooooooooooooooooo"
rotate $ (angleaxis angbranch [vectj[1],vectj[2],vectj[3]])
rotate $ (angleaxis angphyllo [vectk[1],vectk[2],vectk[3]])

vect1=quat vectk[1] vectk[2] vectk[3] 0
vect1.angle=angphyllo
vectconjugate1=conjugate vect1
vect2=quat vectj[1] vectj[2] vectj[3] 0
vect2.angle=angbranch
vectconjugate2=conjugate vect2
vect3=quat vectk[1] vectk[2] vectk[3] 0
vect4=quat vectj[1] vectj[2] vectj[3] 0
vectresultk=vect1*vect2*vect3*vectconjugate2*vectconjugate1
vectresultj=vect1*vect2*vect4*vectconjugate2*vectconjugate1
ancquattransform=quattransform
quattransform=vect1*vect2*ancquattransform
vecteulerz=quat 0 0 1 0
--vectresult3=vectresultk*vecteulerz
--vectresult3.angle=180-vectresult3.angle/2
--vectresult4=conjugate vectresult3
--vectresult2=quat (-vectresultk.y) vectresultk.x 0 0
--vectresult2.angle=-acos vectresultk.z
vecteuler=quattoeuler quattransform order:6

print angphyllo
print angbranch
print vectresultj
print vectresultk
print vecteuler
print vectresult3
print vectresult2
print "euuuuuuuuuuuulllllllller"
print quattransform
print ancquattransform
quatvect=vect1*vect2
print quatvect

orientation.tetax=-vecteuler.z
orientation.tetay=-vecteuler.y
orientation.tetaz=-vecteuler.x
angbranch=0
--angphyllo=mod angphyllo 360
--angphyllo=0
)
phyllotaxieactif=0
-------------------
--max time start
--sliderTime = 0f
--animationRange=interval 0 tlimite
--animate on
--(
--evolstruct nombreiter Spname Coname orientation
--)
--if orientation.nameliaison!="" then
--(
--execute("$"+Coname+".parent=$"+orientation.nameliaison)
--)
execute("select $"+Spname)

orientation.corx=$.pos.x
orientation.cory=$.pos.y
orientation.corz=$.pos.z
--orientation.nameliaison=$.name

)
if deblettre=="X" then
(
Sphere radius:0.1 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[orientation.corx,orientation.cory,orientation.corz+2] isSelected:on
$.wirecolor=green
Spname=$.name
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:2 radius1:0.15 radius2:0.1 mapcoords:on pos:[orientation.corx,orientation.cory,orientation.corz] isSelected:on
$.wirecolor=green
Coname=$.name
--------------
execute("$"+Spname+".parent=$"+Coname)
rotate $ (angleaxis orientation.tetax [1,0,0])
rotate $ (angleaxis orientation.tetay [0,1,0])
rotate $ (angleaxis orientation.tetaz [0,0,1])
-------------------
--max time start
--sliderTime = 0f
--animationRange=interval 0 tlimite
--animate on
--(
--evolstruct nombreiter Spname Coname orientation
--)
--if orientation.nameliaison!="" then
--(
--execute("$"+Coname+".parent=$"+orientation.nameliaison)
--)
execute("select $"+Spname)

orientation.corx=$.pos.x
orientation.cory=$.pos.y
orientation.corz=$.pos.z
--orientation.nameliaison=$.name

)
if deblettre=="Y" then
(
Sphere radius:0.1 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[orientation.corx,orientation.cory,orientation.corz+3] isSelected:on
$.wirecolor=yellow
Spname=$.name
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:3 radius1:0.15 radius2:0.1 mapcoords:on pos:[orientation.corx,orientation.cory,orientation.corz] isSelected:on
$.wirecolor=yellow
Coname=$.name
execute("$"+Spname+".parent=$"+Coname)
rotate $ (angleaxis orientation.tetax [1,0,0])
rotate $ (angleaxis orientation.tetay [0,1,0])
rotate $ (angleaxis orientation.tetaz [0,0,1])
execute("select $"+Spname)

orientation.corx=$.pos.x
orientation.cory=$.pos.y
orientation.corz=$.pos.z

)
if deblettre=="Z" then
(
Sphere radius:0.1 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[orientation.corx,orientation.cory,orientation.corz+4] isSelected:on
$.wirecolor=red
Spname=$.name
Cone smooth:on heightsegs:5 capsegs:1 sides:24 height:4 radius1:0.15 radius2:0.1 mapcoords:on pos:[orientation.corx,orientation.cory,orientation.corz] isSelected:on
$.wirecolor=red
Coname=$.name
execute("$"+Spname+".parent=$"+Coname)
rotate $ (angleaxis orientation.tetax [1,0,0])
rotate $ (angleaxis orientation.tetay [0,1,0])
rotate $ (angleaxis orientation.tetaz [0,0,1])
execute("select $"+Spname)

orientation.corx=$.pos.x
orientation.cory=$.pos.y
orientation.corz=$.pos.z

)
)


fn importobject orientation deblettre i nombreiter=
(

hx=execute commande[i].posx
hy=execute commande[i].posy
hz=execute commande[i].posz


Sphere radius:0 smooth:on segs:32 chop:0 slice:off sliceFrom:0 sliceTo:0 mapcoords:on recenter:off pos:[orientation.corx+hx,orientation.cory+hy,orientation.corz+hz] isSelected:on
$.wirecolor=green
Spname=$.name
hadresse=commande[i].adresse
mergemaxfile hadresse #select #autoRenameDups #renameMtlDups
$.pos=[orientation.corx,orientation.cory,orientation.corz]
Coname=$.name
scale $[execute commande[i].longueur,execute commande[i].largeur,execute commande[i].hauteur]
hx=execute commande[i].rotx
hy=execute commande[i].roty
hz=execute commande[i].rotz
rotate $ (angleaxis hx [1,0,0])
rotate $ (angleaxis hy [0,1,0])
rotate $ (angleaxis hz [0,0,1])
execute("$"+Spname+".parent=$"+Coname)
rotate $ (angleaxis orientation.tetax [1,0,0])
rotate $ (angleaxis orientation.tetay [0,1,0])
rotate $ (angleaxis orientation.tetaz [0,0,1])
execute("select $"+Spname)

orientation.corx=$.pos.x
orientation.cory=$.pos.y
orientation.corz=$.pos.z
max hide selection
for o in objects do (scale o[delta,delta,1])

)


fn dessineobjet orientation deblettre nombreiter paramlong paramepb parameps=
(
if commande.count==0 then
(definitionprogrammeur orientation deblettre nombreiter paramlong paramepb parameps)

for i=1 to commande.count do
(

if commande[i].lettre==deblettre then
(
if commande[i].type=="definie par le programeur" then
(definitionprogrammeur orientation deblettre nombreiter paramlong paramepb parameps)
if commande[i].type=="Cône" then
()
if commande[i].type=="import object" then
( 
importobject orientation deblettre i nombreiter

)
)
else
(
definitionprogrammeur orientation deblettre nombreiter paramlong paramepb parameps
)

)

--objectcône orientation deblettre


)

fn dessineLsystem orientation debut nombreiter debmatrans ranreg=
(
for w=1 to debmatrans.count do
(
if debmatrans[w]!=0 then
(
ancienw=w
)
)

if (nombreiter==ageplante) then
(
nvdebmatrans=debmatrans
)
else
(
nvdebmatrans=multi debmatrans matrans
)

print "nvdebmatrans"
print nvdebmatrans
for j=1 to reg.count do
(
--reg[j].nbprob=100*nvdebmatrans[j]
if frequence[ancienw]==undefined then
(
frequence[ancienw]=#()
)
if frequence[ancienw][j]==undefined then
(
frequence[ancienw][j]=1
)
if frequenceetat[ancienw]==undefined then
(
frequenceetat[ancienw]=1
)


if frequenceetat[ancienw]==1 then
(
reg[j].nbprob=100*nvdebmatrans[j]
)
else
(
reg[j].nbprob=200*nvdebmatrans[j]-100*(frequence[ancienw][j]-1)/(frequenceetat[ancienw]-1) as float
)

)
calculeprob reg
distreg=#()
for j=1 to reg.count do
(
distreg[j]=#()
distreg[j][1]=reg[j].minprob
distreg[j][2]=reg[j].maxprob
distreg[j][3]=reg[j].lettre
distreg[j][4]=reg[j].mot
)

--nvdebmatrans=multi debmatrans matrans
print orientation 
print debut
print nombreiter
for i=1 to debut.count do
(
trouvelettre=0
deblettre=debut[i]
param1=""
param2=""
param3=""

if i<debut.count then
(
if debut[i+1]=="(" then
(

nbpara=1
k=i+2
while debut[k]!=")" do
(

if debut[k]=="|" then
(
nbpara=nbpara+1
print nbpara
k=k+1
)
else
(
if nbpara==1 then
(
param1=param1+debut[k]
print param1
)
if nbpara==2 then
(
param2=param2+debut[k]
print param2
)
if nbpara==3 then
(
param3=param3+debut[k]
print param3
)
k=k+1
)
)
)
)

if param1=="" then
(
paramang=undefined
paramlong=undefined
paramepb=undefined
parameps=undefined

)
else
(
if param2=="" then
(
paramang=param1 as float
paramlong=undefined
paramepb=undefined
parameps=undefined
i=i+3+param1.count
)
else
(
paramang=undefined
paramlong=param1 as float
paramepb=param2 as float
parameps=param3 as float
i=i+5+param1.count
)
)

if (nombreiter>0) then
(
nvranreg=random 1 100

for j=1 to reg.count do
(

if distreg[j][1]<nvranreg and nvranreg<=distreg[j][2] then
(
print "random"
print nvranreg
print "min"
print distreg[j][1]
print "max"
print distreg[j][2]

if distreg[j][3]==deblettre then
(
nviter=nombreiter-1
nvdebut=distreg[j][4]
trouvelettre=1
for w=1 to nvdebmatrans.count do
(
nvdebmatrans[w]=0
)
nvdebmatrans[j]=1


print j
print ancienw
if frequenceetat[ancienw]==undefined then
(
frequencetotal=frequencetotal+1
frequenceetat[ancienw]=1
)
if frequenceetat[j]==undefined then
(
frequencetotal=frequencetotal+1
frequenceetat[j]=1
)
if frequence[j]==undefined then
(
frequence[j]=#()
)

if frequence[j][ancienw]==undefined then
(

frequence[j][ancienw]=1
)
if frequence[ancienw]==undefined then
(
frequence[ancienw]=#()
)
if frequence[ancienw][ancienw]==undefined then
(

frequence[ancienw][ancienw]=1
)
if frequence[ancienw][j]==undefined then
(

frequence[ancienw][j]=1
)
if matrans[j][ancienw]==0 then
(
alphajj2=1
)
else
(

--alphajj2=(frequence[j][ancienw]*matrans[ancienw][j])/(frequence[ancienw][j]*matrans[j][ancienw]) as float
alphajj2=1
)
--alphajj2=((matrans[ancienw][j]*frequencetotal)/frequenceetat[j])^2 as float
if alphajj2>1 then
(
alphajj2=1
)

tirhazard=random 1 100


if (nombreiter==0) then
(
)
else
(
if alphajj2*100<tirhazard then
(
nvdebmatrans=debmatrans
--frequence[j][ancienw]=frequence[j][ancienw]+1
frequence[ancienw][ancienw]=frequence[ancienw][ancienw]+1
frequencetotal=frequencetotal+1
frequenceetat[ancienw]=frequenceetat[ancienw]+1
print j
print "to"
print ancienw
)
else
(
frequence[ancienw][j]=frequence[ancienw][j]+1
frequencetotal=frequencetotal+1
frequenceetat[j]=frequenceetat[j]+1
print ancienw
print "to"
print j
)
print "lalalalalala"
print frequence
print i
print nvdebut
print nviter
print debut 
print debut[i]
print deblettre
print nombreiter

dessineLsystem orientation nvdebut nviter nvdebmatrans nvranreg
)

)
)
)
if trouvelettre==0 then
(
if (paramang==undefined) then
(
paramang=calculang deblettre (ageaxiome+ageplante-nombreiter+1) 0
)
verificationcommande orientation deblettre paramang
resLsys=resLsys+deblettre
nvnbiter=nombreiter+1
print deblettre
print paramlong
print ageaxiome
print nvnbiter
if (paramlong==undefined) then
(
paramlong1=calcullongueur deblettre nvnbiter 0
)
else
(
paramlong1=Ajustelong deblettre paramlong ageaxiome nvnbiter
)
print deblettre
print paramepb
print ageaxiome
print nvnbiter
if (paramepb==undefined) then
(
paramepb1=calculrayonbas deblettre nvnbiter 0
)
else
(
paramepb1=Ajusterayonbas deblettre paramepb ageaxiome nvnbiter
)

print deblettre
print parameps
print ageaxiome
print nvnbiter
if (parameps==undefined) then
(
parameps1=calculrayonhaut deblettre nvnbiter 0
)
else
(
parameps1=Ajusterayonhaut deblettre parameps ageaxiome nvnbiter
)

print paramlong1
print paramepb1
print parameps1
dessineobjet orientation deblettre nvnbiter paramlong1 paramepb1 parameps1
Print nombreiter
print "2"
)

)

else

(
print "param"
print paramang

if (paramang==undefined) then
(
paramang=calculang deblettre (ageaxiome+ageplante-nombreiter+1) 0
)
verificationcommande orientation deblettre paramang
resLsys=resLsys+deblettre
--nvnbiter=nombreiter+1
nvnbiter=nombreiter
print paramlong
print paramepb
print parameps
if (paramlong==undefined) then
(
paramlong1=calcullongueur deblettre nvnbiter 0
)
else
(
paramlong1=Ajustelong deblettre paramlong ageaxiome nvnbiter
)

if (paramepb==undefined) then
(
paramepb1=calculrayonbas deblettre nvnbiter 0
)
else
(
paramepb1=Ajusterayonbas deblettre paramepb ageaxiome nvnbiter
)

if (parameps==undefined) then
(
parameps1=calculrayonhaut deblettre nvnbiter 0
)
else
(
parameps1=Ajusterayonhaut deblettre parameps ageaxiome nvnbiter
)

print paramlong1
print paramepb1
print parameps1
dessineobjet orientation deblettre nvnbiter paramlong1 paramepb1 parameps1
print nombreiter 
print "1"
)


)
)
rollout seeprobreg "Probabiliter initiale des régles"
(
edittext textprobreg "probabiliter initiale" fieldwidth:300 height:300

)

rollout seematrans "Matrice de transition"
(
edittext textseematrans "Matrice" fieldwidth:300 height:300
button changemat "changer Matrice"
on changemat Pressed do
(
valmat=textseematrans.text as string
chvalmat=""
a=1 
b=1
for i=1 to valmat.count do
(

if valmat[i]==" " then
(
print "espace"
print a
print b
print chvalmat
matrans[a][b]=chvalmat as float
chvalmat=""
b=b+1
)
if valmat[i]=="\n" then
(
print "entrer"
print a
print b
print chvalmat
matrans[a][b]=chvalmat as float
chvalmat=""
a=a+1
b=1
)
if valmat[i]!=" " then 
(
if valmat[i]!="\n" then
(
chvalmat=chvalmat+valmat[i]
)
)


)


)

)

rollout changemecanisme "croissance géométrique"
(
edittext textlettre "lettre commande"
edittext evlongueur "évolution longueur"
edittext varlongueur "Variation longueur"
edittext evrayonbas "évolution rayon bas"
edittext varrayonbas "Variation rayon bas"
edittext evrayonhaut "évolution rayon haut"
edittext varrayonhaut "Variation rayon haut"
button ajoutcrois "Ajout croissance"
edittext textlettrea "lettre orientation"
edittext evangle "évolution angle"
edittext varangle "Variation angle"
button ajoutorien "Ajout régle angulaire"
edittext textfonctionnement "fonctionnement ajouter" fieldWidth:500 height:200
on ajoutcrois Pressed do(
countvariablecrois=variablecrois.count +1
variablecrois[countvariablecrois]= structcroiss textlettre.text evlongueur.text varlongueur.text evrayonbas.text varrayonbas.text evrayonhaut.text varrayonhaut.text
i=countvariablecrois
textfonctionnement.text=textfonctionnement.text+variablecrois[i].lettrec+" "+variablecrois[i].long+" "+variablecrois[i].varlong+" "+variablecrois[i].rayonbas+" "+variablecrois[i].varrayonbas+" "+variablecrois[i].rayonhaut+" "+variablecrois[i].varrayonhaut+"\n" 
)
on ajoutorien pressed do(
countvariableang=variableang.count+1
variableang[countvariableang]=structang textlettrea.text evangle.text varangle.text
i=countvariableang
textfonctionnement.text=textfonctionnement.text+variableang[i].lettrea+" "+variableang[i].ang+" "+variableang[i].varang
)

)
rollout Lsystem "0L-system Stochastique"
(
button deflettre "definition lettre"
edittext textaxiome "axiome" fieldWidth:300 height:50
button addaxiome "axiome"
edittext textlettre "Lettre"
edittext textmot "mot"
edittext textnbprob "nbprob"


button addregle "regle"
button seemat "matrice de transition"
button seeprobini "probabiliter initiale regle"
button mecanisme "croissance géométrique"
button clearallregle "clear"
edittext textnombreiter "NBiteration"
edittext textageaxiom "Age axiome"
edittext textangle "ANGLE"
edittext textvarang " variation ANGLE + et -"
edittext textscalecroiss "scale de croissance"
button simule "simule"
edittext ensembleregle "ensemblereg" fieldWidth:300 height:100
edittext resultLsys "resultLsys" fieldWidth:300 height:200
on seeprobini Pressed do(
createdialog seeprobreg 400 500
chprobreg=""
for i=1 to nombrereg do
(
calculeprob reg0

chprobreg=chprobreg+"Regle"+i as string+"-->"+reg0[i].prob as string+"%"+"\n"
)
seeprobreg.textprobreg.text=chprobreg
)
on mecanisme Pressed do(
createdialog changemecanisme 700 500
changemecanisme.evlongueur.text="8/(1+7.85*EXP(-0.0075*t) )"
changemecanisme.varlongueur.text="0.34*(((random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100))/100 as float -6)"
changemecanisme.evrayonbas.text="1.9/(1+25.02*EXP(-0.0338*t) )"
changemecanisme.varrayonbas.text="0.07*(((random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100))/100 as float -6)"
changemecanisme.evrayonhaut.text="1.3/(1+18.89*EXP(-0.0385*t) )"
changemecanisme.varrayonhaut.text="0.06*(((random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100))/100 as float -6)"
changemecanisme.evangle.text="38"
changemecanisme.varangle.text="22*(((random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100)+(random 0 100))/100 as float -6)"

chfonc=""
for i=1 to variablecrois.count do
(
chfonc=chfonc+variablecrois[i].lettrec+" "+variablecrois[i].long+" "+variablecrois[i].varlong+" "+variablecrois[i].rayonbas+" "+variablecrois[i].varrayonbas+" "+variablecrois[i].rayonhaut+" "+variablecrois[i].varrayonhaut+"\n" 
)
for i=1 to variableang.count do
(
chfonc=chfonc+variableang[i].lettrea+" "+variableang[i].ang+" "+variableang[i].varang
)
changemecanisme.textfonctionnement.text=chfonc
)
on seemat Pressed do(
createdialog seematrans 400 500
chmat=""
for i=1 to nombrereg do
(
for j=1 to nombrereg do
(
chmat=chmat+matrans[i][j] as string+ " "
)
chmat=chmat+"\n"
)
seematrans.textseematrans.text=chmat
)
on addaxiome Pressed do(

axiome=textaxiome.text

)
rollout defilettre "definition lettre"
(
edittext addlettredef "lettre"
combobox formeobj "forme" items:#("definie par le programeur","Cône", "import object")
edittext textposx "pos x"
edittext textposy "pos y"
edittext textposz "pos z"
edittext texthauteur "scale z"
edittext textlongueur "scale x"
edittext textlargeur "scale y"
edittext textrotx "rot x"
edittext textroty "rot y"
edittext textrotz "rot z"
edittext textadresse "adresse"

button adddef "add definition"
on formeobj selected i do
(formobjitem=formeobj.items[i]
textadresse.text="C:\Users\OUSSAMA\Documents\3dsMax\scenes\feuilletest.max")
--textadresse.text="C:\Users\OUSSAMA\Documents\3dsMax\scenes\entrenoeudtest.max")
on adddef Pressed do
(
print "ok add def"
addcom=structdeflettre "" "" "" "" "" "" "" "" "" "" "" ""

addcom.lettre=addlettredef.text 

addcom.type=formobjitem
addcom.hauteur=texthauteur.text 
addcom.longueur=textlongueur.text
addcom.largeur=textlargeur.text 
addcom.adresse=textadresse.text
addcom.posx=textposx.text
addcom.posy=textposy.text
addcom.posz=textposz.text
addcom.rotx=textrotx.text
addcom.roty=textroty.text
addcom.rotz=textrotz.text

commande[commande.count+1]=addcom
)

)



on deflettre Pressed do
(
free commande
createdialog defilettre 400

)
on addregle Pressed do(

nombrereg=nombrereg+1
tnbprob=execute textnbprob.text
reg[nombrereg]=structregle textlettre.text textmot.text
reg0[nombrereg]=structregle textlettre.text textmot.text

debmatrans[nombrereg]=tnbprob
for j=1 to reg0.count do
(
reg0[j].nbprob=debmatrans[j]
)
matrans[nombrereg]=#()
matrans[nombrereg][nombrereg]=1
for i=1 to nombrereg-1 do
(
matrans[i][nombrereg]=0
)
for i=1 to nombrereg-1 do
(
matrans[nombrereg][i]=0
)
ensembleregle.text=ensembleregle.text+"Regle"+nombrereg as string+":"+textlettre.text+"-->"+textmot.text+"\n"
)
on clearallregle Pressed do(

nombrereg=0
free matrans
free debmatrans
free reg
free reg0
free resLsys
free commande
free variableang
free variablecrois
ensembleregle.text=""
resultLsys.text=""
)
on simule Pressed do(
start=timeStamp()
resLsys=""
angphyllo=0
angbranch=0
enregistreorientation=#(structorientation 0 0 0 0 0 0 "")
enregistrequaternion=#(quat 0 0 0 1)
ancquattransform=quat 0 0 0 1
quattransform=quat 0 0 0 1
ageaxiome=textageaxiom.text as integer
nombreiter=textnombreiter.text as integer
ang=textangle.text as integer
varang=textvarang.text as integer
frequence=#()
frequenceetat=#()
frequencetotal=0
debut=axiome
ageplante=textnombreiter.text as integer
tlimite=(ageplante+1)*tpas
paramang=0
phyllotaxieactif=0
enregistrephyllotaxieactifx=0
enregistrephyllotaxieactify=0
enregistrephyllotaxieactifz=0
orientation=structorientation 0 0 0 0 0 0 ""
delta=textscalecroiss.text as float
dessineLsystem orientation debut nombreiter debmatrans 0

resultLsys.text=resLsys

end = timeStamp()
format "Processing took % seconds\n" ((end - start) / 1000.0)
)
)
createdialog Lsystem 400 700