import { Species } from "./base";

const Reploid: Species = {
  description: "Reploids (short for Replica Android) are the next generation of advanced humanoid robotics. \
    They're made from an open-source design that has been changed by many manufacturers to \
    suit whatever is needed for their purposes, leading to an immense variery of Reploid models.",
  features: {
    good: [{
      icon: "burger",
      name: "No Hunger",
      description: "Reploids have no need for food, and thus do not need to eat!",
    }, {
      icon: "lungs",
      name: "No O2? No Problem!",
      description: "Reploids do not breathe. Usually this is a good thing, but keep in mind CPR requires breathing to do!",
    }, {
      icon: "radiation",
      name: "Radiation Immunity",
      description: "Reploids are immune to the effects of radiation. \
        Okay, positrons may jumble up their circuits, but that's fine, nothing to worry about.",
    }],
    neutral: [{
      icon: "screwdriver-wrench",
      name: "Unfinished Species",
      description: "This species is not finished yet and is going to recieve gameplay reworks in the future.",
    }, {
      icon: "sliders",
      name: "Highly Customizable",
      description: "Reploids are highly customizable and able to come in all shapes and sizes! Try out fun combinations, see what you can make!",
    }],
    bad: [{
      icon: "dna",
      name: "Jeanless",
      description: "Reploids do not have DNA, and are therefore unable to benefit from genetic superpowers.",
    }, {
      icon: "arrows-rotate",
      name: "No Metabolism",
      description: "Reploids do not have any metabolism to speak of. Therefore, healing from damage is much more difficult.",
    }],
  },
  lore: [
    "The original design for Replica Androids stems from a Nanotrasen research project to construct a new modular \
    synthetic lifeform. However, the design got leaked and released to the galactic internet. Now, anyone can make their \
    own version of a Reploid. There are however some secrets held by the research project to this day, \
    as their design is strikingly unlike any robotics ever made by Nanotrasen in the past. \
    Perhaps Reploids have an older ancestor which they were derived from?",
  ],
};

export default Reploid;
