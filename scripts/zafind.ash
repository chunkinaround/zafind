import <canadv.ash>

void main(string command) {
buffer droppedItemPool;
string letter = to_upper_case(command);
foreach loc in $locations[The Neverending Party,
The Haunted Kitchen,
The Haunted Billiards Room,
The Haunted Library,
The Spooky Forest,
The Dark Heart of the Woods,
The Dark Elbow of the Woods,
The Dark Neck of the Woods,
Friar Ceremony Location,
Infernal Rackets Backstage,
The Laugh Floor,
The Outskirts of Cobb's Knob,
Guano Junction,
The Beanbat Chamber,
The Batrat and Ratbat Burrow,
The Haunted Bedroom,
The Boss Bat's Lair,
Cobb's Knob Harem,
The Daily Dungeon,
The Bandit Crossroads,
Throne Room,
Wartime Hippy Camp,
Sonofa Beach,
The Haunted Gallery,
The Haunted Bathroom,
The Haunted Ballroom,
The Typical Tavern Cellar,
Noob Cave,
The Defiled Alcove,
The Defiled Nook,
The Hatching Chamber,
The Shore\, Inc. Travel Agency,
The Defiled Niche,
The Defiled Cranny,
Haert of the Cyrpt,
Mist-Shrouded Peak,
The Penultimate Fantasy Airship,
The Castle in the Clouds in the Sky (Basement),
The Castle in the Clouds in the Sky (Ground Floor),
The Black Forest,
The Castle in the Clouds in the Sky (Top Floor),
The Smut Orc Logging Camp,
Twin Peak,
A-Boo Peak,
Oil Peak,
The Haunted Wine Cellar,
The Haunted Laundry Room,
The Haunted Boiler Room,
Summoning Chamber,
The Hidden Temple,
The Hidden Park,
An Overgrown Shrine (Northwest),
An Overgrown Shrine (Northeast),
An Overgrown Shrine (Southwest),
An Overgrown Shrine (Southeast),
A Massive Ziggurat,
The Arid\, Extra-Dry Desert,
A Mob of Zeppelin Protesters,
The Hidden Apartment Building,
The Oasis,
The Hidden Office Building,
The Hidden Bowling Alley,
The Hidden Hospital,
The Copperhead Club,
Lair of the Ninja Snowmen,
The VERY Unquiet Garves,
The Red Zeppelin,
Inside the Palindome,
The Upper Chamber,
The Middle Chamber,
The Lower Chambers,
Next to that Barrel with Something Burning in it,
Out by that Rusted-Out Car,
Over Where the Old Tires Are,
Near an Abandoned Refrigerator,
The Feeding Chamber,
The Royal Guard Chamber,
The Filthworm Queen's Chamber,
The Hole in the Sky,
The Battlefield (Frat Uniform),
The Themthar Hills,
Frat House,
Fastest Adventurer Contest,
The Hedge Maze,
Tower Level 1,
Tower Level 2,
Tower Level 3,
Tower Level 4,
Tower Level 5,
The Naughty Sorceress' Chamber] {
monster [int] monster_list = get_monsters(loc);
  foreach mon in monster_list {
  int[item] drops = item_drops(monster_list[mon]);
    foreach i in drops {
    droppedItemPool = append(droppedItemPool, ",");
    droppedItemPool = append(droppedItemPool, to_string(i));
      if (  letter == to_upper_case(substring(to_string(i),0,1))  )  {
        if (is_tradeable(i) && is_discardable(i) && !is_npc_item(i)) {
        #print(i + " drops from Monster: " + monster_list[mon] + " at locations:"+ loc + " with a drop rate of " + drops[i]);
        print(i +","+monster_list[mon]+","+loc+","+drops[i]);
        }
        }
    }
  }
}
string getingred (item ing , string ingredlist, int nodelevel )
{
    #this is bad, I know its bad, Im way out of practice, feel free to fix the cs100 level of shit here
    nodelevel = nodelevel + 1;
    string updatedList;
    string update2;
    #print("Starting tree for " + to_string(ing));
    int [item] ingredients = get_ingredients(ing);
    if (ingredients.count() == 0) {
     #print("This is a core ingredient " + to_string(ing));
     if (ingredlist == ""){
         update2 = to_string(ing) ;
     } else {
        update2 = ingredlist + ","+ to_string(ing) ;
     }
     update2 = ingredlist + ","+ to_string(ing) ;
    } else {
        foreach ingredient in ingredients {

            #print(to_string(ingredient));
            int [item] l2ingredients = get_ingredients(ingredient);
            if(l2ingredients.count() > 1) {
                foreach l2ingredient in l2ingredients {
                update2 = update2 + getingred(l2ingredient, ingredlist, nodelevel);
                }

            } else {
                update2 = (update2 +"," +to_string(ingredient));
                #print("updated list value This is a core ingredient else" + update2);
            }
    }

}
#weird one offs
    droppedItemPool = append(droppedItemPool, ",");
    droppedItemPool = append(droppedItemPool, "," + "meat stack"+ ",");

	buffer_to_file(droppedItemPool,"itempooltest.txt");
#print("returnvalue: " + update2);
return update2;
}
buffer recipies;
boolean cancraft;
print("Able to be crafted","blue");
  foreach craftable in $items[] {
    if (  letter == to_upper_case(substring(to_string(craftable),0,1))  ) {
      set_length(recipies ,0 );
      int [item] ingredients = get_ingredients(craftable);
      if(ingredients.count() > 0) {
        cancraft = True;
        #print ("craftable:" + craftable);
        string[int] components = split_string(substring(getingred(craftable,"",0),1),",");

        foreach component in components {
          item itemcomp = to_item(components[component]);
          #print(components[component]);
          matcher inPool = create_matcher(("," + components[component]+ ","),to_string(droppedItemPool));
         #print(components[component]+":findinpool:"+find(inPool)+":isnpcitem:"+is_npc_item(itemcomp));
          if (find(inPool)||is_npc_item(itemcomp)){
          recipies = append(recipies, to_string(components[component])+",");
          } else {
          		cancraft = False;
              #print("setting to false");
               append(recipies, to_string(components[component])+"false,");
          }

  			}
        if (cancraft) {
        print(craftable + ":" + recipies );
        }
      }
    }
  }
}
