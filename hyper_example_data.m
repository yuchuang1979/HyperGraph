% load zoo.txt
% 1. animal name:      Unique for each instance
% 2. hair		Boolean
% 3. feathers		Boolean
% 4. eggs		Boolean
% 5. milk		Boolean
% 6. airborne		Boolean
% 7. aquatic		Boolean
% 8. predator		Boolean
% 9. toothed		Boolean
% 10. backbone		Boolean
% 11. breathes		Boolean
% 12. venomous		Boolean
% 13. fins		Boolean
% 14. legs		Numeric (set of values: {0,2,4,5,6,8})
% 15. tail		Boolean
% 16. domestic		Boolean
% 17. catsize		Boolean
% 18. type		Numeric (integer values in range [1,7])


% 1 (41) aardvark, antelope, bear, boar, buffalo, calf, cavy, cheetah, deer, dolphin, elephant, fruitbat, giraffe, girl, goat, 
% gorilla, hamster, hare, leopard, lion, lynx, mink, mole, mongoose, opossum, oryx, platypus, polecat, pony,
% porpoise, puma, pussycat, raccoon, reindeer, seal, sealion, squirrel, vampire, vole, wallaby,wolf
% 2 (20) chicken, crow, dove, duck, flamingo, gull, hawk, kiwi, lark, ostrich, parakeet, penguin, pheasant, rhea, skimmer, skua, sparrow, swan, vulture, wren
% 3 (5)  pitviper, seasnake, slowworm, tortoise, tuatara
% 4 (13) bass, carp, catfish, chub, dogfish, haddock, herring, pike, piranha, seahorse, sole, stingray, tuna
% 5 (4)  frog_a, frog_b, newt, toad
% 6 (8)  flea, gnat, honeybee, housefly, ladybird, moth, termite, wasp
% 7 (10) clam, crab, crayfish, lobster, octopus, scorpion, seawasp, slug, starfish, worm





fid = fopen('D:/work/hyper/zoo.txt', 'r');

ind = 1;
attributes = [];

while 1
    t1 = fgetl(fid);
    fuhao = findstr(t1,',');
    if length(fuhao) == 0
        break;
    end
    afeature = str2num(t1(fuhao(1)+1:end));
    attributes = [attributes;afeature(1:end-1)];
    nameLabels(ind).name = t1(1:fuhao(1)-1);
    nameLabels(ind).label = afeature(end);
    ind = ind+1;
end




save attributes attributes
save nameLabels nameLabels