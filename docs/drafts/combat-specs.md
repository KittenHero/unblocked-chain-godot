# Combat system requirements
(TODO)

- [ ] Character stats:
  - max HP
  - attack
  - crit rate
  - crit damage
  - defense
  - move speed
  - animation speed --- should not reduce iframes and counter window

- [ ] Attack Data:
  - an attack has motion values
  - each collider of each frame of an attack may have separate motion values
  	- use a resource to share values
  - motion value has damage, knockback, hitstops, and a data container for custom properties
  - attack damage is determined by motion value X base stats X modifiers / enemy stats X Enemy modifiers

- [ ] Damage calc:
  - attack X motion value X crit modifier X damage buff / damage mitigation X defense

- [ ] Hit stop:
  - hit stop affects only the entities involved in the collision
  - triggers after damage calculation (same frame)
  - camera will listen and react to death blows and hitstops with values above .3s

- [ ] Conditional status (buffs/debuffs):
  - Buffs modifies characters base abilities
  - buff icons
  - buffs may trigger an effect on activation and deactivation
  - buffs may affect certain (predefined) calculations

- [ ] Weapons
  - equipping weapon changes overrides the characters set of available states
  - if no weapon is equipped, the base states are restored
  - equipping weapons may change character stats (attack, defense, crit rate, etc)

- [ ] More states:
  - tumble: when knocked back by an attack, duration depends on the attack, cannot act, holding movement can influence direction (DI)
  - restrained: cannot act, mash to end early
  - knocked down: cannot act, ends on timer
  - dodge: i-frame triggered by animation, i-frame duration controlled by script (can be affected by weapon?)



~~Sword of brilliant valor & Shield of magnificent honor (Stanley reference)~~
