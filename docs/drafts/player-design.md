# Player Design

## Player Overview

Uber eats employee that is cybernetically enhanced through mobile gacha and skill.

## Core Abilities

- **Dodge roll**
- **Melee attack** 
- **Spin attack parry** 
- **Ranged weapons**
- **Physical empowerment**

## UI

- **Health bar**: 
	- Hit points for survivability
- **Stamina bar**:
	- Stamina points for dodge roll/parry mechanic
- **Compute Network bar**:
	- Dynamic bar leading up to slot machine spin
- **Gacha machine**: 
	- Slot machine that appears into view upon filling up the compute bar
- **Unblocked Chain Combo counter**:
	- Has different effects and transitions based on combo count
- **Selected Weapon**: 
	- Icon of selected arnament 
- **Ammo count**:
	- Remaining ammo for weapon
- **Targetting reticle for aim** 

 
## Movement System

- **Omni-directional movement** - Can move in any direction at fixed speed, constrained by space
- **Dodge roll** - Can roll in direction of movement, constrained by stamina bar
- **Melee movement** - A small amount of distance covered by melee attack, constrained by type of attack

## Combat Mechanics

### General 

- **Health**:
	- Fixed amount of health points
	- Game over when out of health
- **Stamina**: 
	- Fixed amount of stamina points
	- Decreases upon use of dodge roll/parry mechanic
	- Upon hitting 0, those abilities become unresponsive
	- Increases on successful strikes 
	- Slow regeneration back to full over time
- **Unblocked Chain Combo Counter** 
	- Measure of combo count/on hit count
	- Unaffected by missed bullets 
	- Taking a hit will reduce counter
	- Each 'XX' has its own title of glory, rankings below:
		- Leftover pizza
		- Soggy french fry
		- Might get a tip
		- High on cheese 
		- Too Fast(Food) for you
		- Holy Macaroni 
		- ???
- **Melee**:
	- Simple melee attacks that contain some movement towards the direction of the attack
- **Ranged weapon**:
	- May be procured from gacha
	- Different ranged weapons with unique properties, utilising the targeting icon
- **Spin parry**:
	- Spin attack that deflects a ranged attack and reverses path of projectile
	- May also deflect a melee attack and stagger enemy if possible
	- Small window that requires precise timing
	- Has a cool down 
	- Requires stamina
- **Compute Network**:
	- Dynamic points that start from 0
	- Increases upon successful combo strikes/hits and succesful parry 
	- Has a cap which upon reaching must be reset in order to start accumulating again
	- Full points of the Compute Network invoke the **core combat mechanic**

### Core combat mechanic - Gacha Compute Network

Gift from the heavens(or stolen from evil corp) that dramatically changes your impact in combat. 
Once you have reached the required amount of compute, the network will calculate and distribute the rewards directly to you. Keep *overclocking* to build up your unblocked chain and improve your reward.

- The slot machine takes 5-10 seconds to spin
- Player *Unblocked Chain Combo* counter directly affects results
- Based on a preset modifier, there may be a higher change of getting melee/ranged
- Based on phase, may make a buff more likely to land upon

#### Ranged enhancement

Your bag feels heavier, you reach into the Drinks compartment on the side, and pull out a new ranged arnament. 

- **Deadly mixer gun**: 
	- Cook left mixer in your bag
	- Spin the mixer and the brains of ur enemies 
	- Drill shaped hitbox
	- Deals a high amount of damage
	- Vanishes after usage for some time
- **Discount Laser gun**:
	- Uber eats guy is a star wars fan
	- Deal small amount of damage
	- Has limited ammo
- **Garbage dump**:
	- Throw out expired food from your bag
	- Differently shaped projectiles, follow a looping certain order and may be differing in damage
	- Has limited ammo

#### Physical enhancement

- **Unlimited stamina**:
	- Flashing stamina, roll/parry at whim
- **Dance Of Death**:
	- Omni directional spinning slash
	- Active for some time
	- Gain invincibility at same time
- **Spirit of the samurai**:
	- Spirit watching over you
	- Window to parry increases moderately 

## Visual Design

- **Character** - Non descript silhouette with Uber Eats delivery pack on back
- **Melee** - Bag slap 
- **Physical empowerment**:
	- **Dance Of Death**:
- **Guns**:
- **Health bar** -
- **Stamina bar** -
- **Compute network bar** - 
- **Combo counter** - 
- **Compute network slot machine**:
	- Buffer spinning animation for each column separately
	- **Three Skulls** - Three boneheads with uber eats cap (Player dies(jk, remove))

## Sound Design

- **Footsteps** - 
- **Melee attack** - bag slap?
- **Physical empowerment**:
	- **Dance Of Death**:
- **Guns**:
- **Dodge** - Sound of wind
- **Parry attack** - Blade draw
- **Compute network Slot machine**  
	
