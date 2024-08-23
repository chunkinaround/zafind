script <zafind>;

/*
Usage:
# Example will find all pizza ingredients starting with n
zafind n

Properties used in this script
zafindALL
ex. set zafindALL = true
When set to true will print out a list of all non standard items that fit pizzable criteria that havent been printed yet. 

#Not Implemented

zaFindMode
options: standard || unrestricted || canadv
ex. set zaFindMode = standard
Not implemented yet, will eventually do something with different location sets
when I figure out dependancies I will enable canadv mode and vprops to get location sets

relay version that prints nicer
check for fancy ingredients
sortability
whether its a special pizza ingredient
*/
boolean is_shoppable (item ingredient){
  if (craft_type(ingredient) == "star chart" || craft_type(ingredient) == "Crackpot Mystic"){
    return true;
  }
  return false;
}

boolean is_pizzable(item ingredient){
  if (is_tradeable(ingredient) && is_discardable(ingredient) && !is_npc_item(ingredient) && !is_shoppable(ingredient)) {
    return true;
  }
  return false;
}

void format_ingred_string (string input, item ingredient ){
  int specialProp = 0;
  string itemName = to_lower_case(to_string(ingredient));
  string color;
  # Clover
  if (contains_text(itemName, "green")|| contains_text(itemName, "luck") ) {
    input = input + " || lucky";
    color = "green";
    specialProp = specialProp+1;
    print(input,color);
  }
  # Dead Mimic
  if (contains_text(itemName, "cloak")) {
    input = input + " || cloaked";
    color = "navy";
  }
  # spleen item
  if (ingredient.spleen > 0) {
    input = input + " || spleen item";
    color = "blue";
    specialProp = specialProp+1;
  }
  #combat item
  if (ingredient.combat == true) {
    input = input + " || combat item";
    color = "red";
    specialProp = specialProp+1;
  }
  # familiar item
  if (to_slot(ingredient) == $slot[familiar]) {
    input = input + " || fam item";
    color = "purple";
    specialProp = specialProp+1;
  }
  #milk
  if (contains_text(itemName, "milk")|| contains_text(itemName, "cheese") ) {
    input = input + " || cheesy";
    color = "yellow";
    specialProp = specialProp+1;
  }
  #star
  if (contains_text(itemName, "star")|| contains_text(itemName, "space") || contains_text(itemName, "dot") ) {
    input = input + " || starstruck";
    color = "green";
    specialProp = specialProp+1;
  }
  if (specialProp > 1){
    color = "maroon";
  }
  print(input,color);
}

void main(string command) {

#using buffers only so its easy to buffer to file at some point in the future, also the regex seems to search them fast so idk?
buffer droppedItemPool;
string letter = to_upper_case(command);
print("============================","blue");
print("Drops from monsters","blue");
print("drop,monster,location,drop%,length,autosell");
print("============================","blue");

#need to figure out vprops location_set here 
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

#gets a list of all monster drops from the location set that start with the letter and are pizzable
#also appends all drops to a buffer for use in the crafting section later
monster [int] monster_list = get_monsters(loc);
  foreach mon in monster_list {
  float[item] drops = item_drops(monster_list[mon]);
    foreach i in drops {
    droppedItemPool = append(droppedItemPool, ",");
    droppedItemPool = append(droppedItemPool, to_string(i));
      if (  letter == to_upper_case(substring(to_string(i),0,1))  )  {
        if (is_pizzable(i)) {
        format_ingred_string(i +","+monster_list[mon]+","+loc+","+drops[i]+","+length(to_string(i))+","+autosell_price(i),i);
        }
        }
    }
  }
}


string getingred (item ing , string ingredlist, int nodelevel )
{
    #this is bad, I know its bad, Im a bad person for releasing this, feel free to fix the cs101 level of shit here
    #I didnt realize that get_ingredients didnt do multistage crafting until I was most the way through the script
    #then I pivoted and wrote this shitty recursion while distracted
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

return update2;
}
#weird one offs, due to lack of planning Im probably going to just add random shit to the droppedItemPool here so it can be used in crafting
print("============================","blue");
print("Random common things Im not sure where to put","blue");
print("item,length,autosell");
print("============================","blue");


#no idea on meat paste, dense meat stack, meat stacks, what can I use to procedurally grab these?
foreach mat in $items[meat paste, dense meat stack, meat stack,] {
    droppedItemPool = append(droppedItemPool, "," + to_string(mat) );
    #I reuse the code to check for whether it starts with the letter, is tradable and discardable multiple times, should break this out to a boolean function
  if (  letter == to_upper_case(substring(to_string(mat),0,1))  )  {
    if (is_pizzable(mat)) {
      format_ingred_string(mat+","+length(to_string(mat))+","+autosell_price(mat),mat);
      }
  }
}

/*
fam.drop_name Doesnt work the way I think it does it doesnt do anything for any of the in standard familiars, can do something when I do a nonstandard version?
foreach fam in $familiars[] {
if (  letter == to_upper_case(substring(to_string(mat),0,1))  )  {
  if (is_tradeable(mat) && is_discardable(mat) && !is_npc_item(mat)) {
    print(mat);
    }
  droppedItemPool = append(droppedItemPool, "," + to_string(mat) + ",");
}
if (to_string(fam.drop_name) != "none") {
print(fam);
print (fam.drop_name);
}
}
*/

# Summonables - something different for non standard?
foreach mat in $items[scrumptious reagent, dry noodles, coconut shell,little paper umbrella,magical ice cubes,lime,grapefruit] {
    droppedItemPool = append(droppedItemPool, "," + to_string(mat) );
if (  letter == to_upper_case(substring(to_string(mat),0,1))  )  {
  if (is_pizzable(mat)) {
      format_ingred_string(mat+","+length(to_string(mat))+","+autosell_price(mat),mat);
    }
}
}


#pulverisable
foreach mat in $items[useless powder,
                      twinkly powder,
                      hot powder,
                      cold powder,
                      spooky powder,
                      stench powder,
                      sleaze powder,
                      twinkly nuggets,
                      hot nuggets,
                      cold nuggets,
                      spooky nuggets,
                      stench nuggets,
                      sleaze nuggets,
                      twinkly wad,
                      hot wad,
                      cold wad,
                      spooky wad,
                      stench wad,
                      sleaze wad] 
{
    droppedItemPool = append(droppedItemPool, "," + to_string(mat) );

if (  letter == to_upper_case(substring(to_string(mat),0,1))  )  {
  if (is_tradeable(mat) && is_discardable(mat) && !is_npc_item(mat)) {
      #print(mat+","+length(to_string(mat))+","+autosell_price(mat));
      format_ingred_string(mat+","+length(to_string(mat))+","+autosell_price(mat),mat);
    }
}
}
print("============================","blue");
print("Cargo Pockets","blue");
print("pocket,item,length,autosell");
print("============================","blue");

foreach i in item_pockets(){
  foreach mat in pocket_items(i){
    droppedItemPool = append(droppedItemPool, "," + to_string(mat) );
    if (  letter == to_upper_case(substring(to_string(mat),0,1))  )  {
      if (is_pizzable(mat)) {
      #print(mat+","+length(to_string(mat))+","+autosell_price(mat));
      format_ingred_string(i+","+mat+","+length(to_string(mat))+","+autosell_price(mat),mat);
      }
    }
  }
} 
print("============================","blue");
print("Cargo Monsters","blue");
print("pocket,monster,item,length,autosell");
print("============================","blue");
foreach j in monster_pockets(){
  monster mon = pocket_monster(j);
  float[item] drops = item_drops(mon);
    foreach i in drops {
    droppedItemPool = append(droppedItemPool, ",");
    droppedItemPool = append(droppedItemPool, to_string(i));
      if (  letter == to_upper_case(substring(to_string(i),0,1))  )  {
        if (is_pizzable(i)) {
      format_ingred_string(j+","+mon+","+i+","+length(to_string(i))+","+autosell_price(i),i);        }
        }
    }
  
} 
foreach mon in $monsters[Burning Daughter,Astrologer of Shub-Jigguwatt,Herald of Fridgr,Chosen of Yog-Urt,Tentacle of Sssshhsssblllrrggghsssssggggrrgglsssshhssslblgl] {
  float[item] drops = item_drops(mon);
    foreach i in drops {
    droppedItemPool = append(droppedItemPool, ",");
    droppedItemPool = append(droppedItemPool, to_string(i));
      if (  letter == to_upper_case(substring(to_string(i),0,1))  )  {
        if (is_pizzable(i)) {
      format_ingred_string("bell,"+mon+","+i+","+length(to_string(i))+","+autosell_price(i),i);        }
        }
    }

}
#for testing purposes im writing this out to a text file
buffer_to_file(droppedItemPool,"itempooltest.txt");

#still using buffers only so its easy to buffer to file at some point in the future
buffer recipies;
boolean cancraft;
print("============================","blue");
print("Able to be crafted","blue");
print("Item,length,autosell::ingredients");
print("============================","blue");
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
          #shit, I meant to put this at the start so that I dont have to waste all this code note to self when refactoring this eventually
          if (is_pizzable(craftable)) {
            print(craftable +","+length(to_string(craftable))+","+autosell_price(craftable) +"::" + recipies );
            #adding this to dropped item pool to use in zafindAll section below
            droppedItemPool = append(droppedItemPool, "," + to_string(craftable) + ",");
          }
        }
      }
    }
  }

#to_boolean will default to false
if (to_boolean(get_property("zafindALL")))  {
print("============================","blue");
print("Various Items that are technically standard but I dont know if they are gettable","blue");
print("Item,length,autosell::ingredients");
print("============================","blue");
  buffer nonstandarditems;
  string standard = visit_url("standard.php");
  matcher standardmatcher = create_matcher("<span class=\"i\">(.*?)(, )?</span>",standard);
  #checks everything thats listed as non standard, not just items, I dont want to take the time to parse out just items
  while (find(standardmatcher)) {
      nonstandarditems = append(nonstandarditems, to_string(group(standardmatcher, 1)) + ",");
  }
    foreach nonstan in $items[] {
        if (  letter == to_upper_case(substring(to_string(nonstan),0,1))  ) {
          if (is_pizzable(nonstan)) {
            matcher nonStandard = create_matcher((nonstan + ","),to_string(nonstandarditems));
            matcher inPool2 = create_matcher((nonstan + ","),to_string(droppedItemPool));
            if (!find(nonStandard) && !find(inPool2))  {
              format_ingred_string(nonstan +","+length(to_string(nonstan))+","+autosell_price(nonstan),nonstan);
            }
          }
        }
    }
}
}
