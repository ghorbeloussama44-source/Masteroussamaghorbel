macroscript SphereSegsOn category: "HowTo"
(
callbacks.removescripts id:#sphere_segs
txt ="for o in geometry do(\n"
txt +="if classof o.baseObject == Sphere then \n"
txt +="o.baseObject.segments *= 8.0\n"
txt +=")\n"
 
callbacks.addscript #preRender txt id:#sphere_segs
txt ="for o in geometry do(\n"
txt +="if classof o.baseObject == Sphere then \n"
txt +="o.baseObject.segments /= 8.0\n"
txt +=")\n"
 
callbacks.addscript #postRender txt id:#sphere_segs
)
macroscript SphereSegsOff category: "HowTo"
(
callbacks.removescripts id:#sphere_segs
)