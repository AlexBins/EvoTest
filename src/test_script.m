world = World(0, 0, 0);
rc = RectangularElement(0, 0, 1.125, 0.75, 0);
cc = CircularElement(0, 0, 1);
world.AddElement(rc);
%world.AddElement(cc);
world.Street = Street([-3, 0.5; 3, 0.5],[0,0],[0,0]);
world.PlaceElement(rc, 0.5, 1, 0.75 / 2 + 0.1);

world.Display();