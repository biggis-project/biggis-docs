# Firefighting

## Motivation

In the last decades the methods of firefighting have become a lot more effective. Still, the access to a sufficient
amount of water is often limited. Fighting a major fire requires several thousand liters of water per minute and so the
water tanks of firetrucks are empty in a matter of minutes. Here the real challenge begins: **finding hydrants as
quickly as possible**, which can supply a sufficient amount of water and at the same time are close by, while taking
into account:

  1. the height difference, 
  2. reducing water pressure. 

We developed a tool that can help solving this complex situation. OpenStreetMap data is used as basis data for our
calculations.  The aim of our tool is to help the fire officer in charge, to make the best decision to provide the
necessary amount of water as quickly as possible.

## Features 

After marking an incident scene on a map, the most suitable hydrant is shown on the map. In addition, the position for
the line of hoses is marked as well as the position of potentially needed mobile water pumps, providing the right
pressure in hilly surroundings.

On a side bar on the right you can interactively add the amount of water needed. The user can also choose between three
different varieties to get water, taking into account other possibilities for hydrants, hoses and pumps. After having
chosen a solution, the corresponding elevation profile will be shown on the side bar, indicating the incident scene, the
hydrant and the position and distance of the individual pumps.

It is possible to mark certain items on the map as blocked, e.g. hydrants, roads etc. leading to a new calculation of
the best solution without using the blocked item. This is very often necessary as hydrants might be blocked by a parking
car or roads are not accessible because of construction sites.
