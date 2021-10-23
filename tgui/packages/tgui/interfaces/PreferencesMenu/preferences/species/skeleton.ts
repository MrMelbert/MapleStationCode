import { createLanguagePerk, Species } from "./base";

const Skeleton: Species = {
  description: "WIP Skeleton description!",
  features: {
    good: [{
      icon: "shield-alt",
      name: "He's Undead, Jim",
      description: "Skeletons are undead. They're immune to much of what the \
        living are vulnerable to - Disease, Radiation, Pressure Damage, \
        Temperature Damage, Toxins and Cellular damage. They are also immune \
        to piercing.",
    }, {
      icon: "skull",
      name: "Dead Men Tell No Tales",
      description: "As skeletons are dead, they don't eat, breathe, \
        process chemicals, or have DNA.",
    }, createLanguagePerk("Calcic")],
    neutral: [{
      icon: "bone",
      name: "Limber Limbs",
      description: "Skeleton limbs are very easily detatched by force, but can \
        be re-attatched similarly as easily.",
    }],
    bad: [{
      icon: "glass-cheers",
      name: "Milk Drinkers",
      description: "Skeletons can't use sutures or meshes on themselves, and \
        can't process any healing chemicals. To heal, they must drink milk!",
    }],
  },
  lore: [
    "WIP Skeleton lore!",
  ],
};

export default Skeleton;
