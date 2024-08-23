# zafind
Script to assist with finding pizza ingredients

just type zafind.ash and the letter you want to search for pizza ingredients.

# Example
zafind.ash n

This will print out 3 sections first, items that drop in ascension relevant zones (determined by zones I had visited in a standard ascension)
```
> zafind n

============================
Drops     from monsters
drop,monster,location,drop%,length,autosell
============================
neverending     wallet chain,biker,The Neverending Party,0,24,60
noticeable pumps,party     girl,The Neverending Party,0,16,60
ninja hot pants,Demoninja,The Dark     Elbow of the Woods,5,15,75
```
Second sections is Random common things Im not sure where to put which includes things that are summonable using some standard skills examples include little paper umbrellas (summonable using Advanced Cocktailcrafting) or limes (summonable using Prevent Scurvy and Sobriety)
```
zafind l
...
...
============================
Random     common things Im not sure where to put
item,length,autosell
============================
little     paper umbrella,21,35
lime,4,60
```

The third section is items that are able to be crafted using items that drop in the game or are npc items, examples include gnollish autoplunger (a great G ingredient)
```
zafind g
...
...
============================
Able to be crafted
Item,length,autosell::ingredients
============================
Gnollish autoplunger,20,160::Gnollish plunger,cog,spring,sprocket,meat stack,empty meat tank,
ghuol egg quiche,16,46::Gnollish pie tin,flat dough,ghuol egg,
```
 Finally there is a 4th hidden mode that only works if you set a property. You can enable it using 
 `set zafindALL = true`.  This will print all standard items that start with the letter that havent been listed yet. I use this primarily for troubleshooting, but you may need to use it to cover all the crazy edge cases and try and keep up with TES. 
 
```
============================
Various Items that are technically standard but I dont know if they are gettable
Item,length,autosell::ingredients
============================
gnoll lips,10,11
gnoll teeth,11,12
gnoll-tooth necklace,20,85
giant moxie weed,16,125
```

# Branches
Due to KoLMafia stuff I dont understand the actual script is in the release branch.

# Installation
`git checkout https://github.com/chunkinaround/zafind.git Release`
