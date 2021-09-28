import { createLanguagePerk, Species } from "./base";

const Skrell: Species = {
  description: "WIP Skrell description!",
  features: {
    good: [{
      icon: "user-injured",
      name: "Pain Resilience",
      description: "Skrell are a bit more resilient to pain, taking \
        20% less pain overall.",
    }, {
      icon: "utensils",
      name: "Weight Watchers",
      description: "No matter how much they eat, Skrell can never become \
        overweight.",
    }, createLanguagePerk("Skrellian")],
    neutral: [],
    bad: [{
      icon: "wine-bottle",
      name: "Light Drinkers",
      description: "Skrell naturally don't get along with alcohol \
        and find themselves getting inebriated very easily.",
    }, {
      icon: "tint",
      name: "\"S\"pecial Blood",
      description: "Skrell have a unique \"S\" type blood. Instead of \
        regaining blood from iron, they regenerate it from copper.",
    }],
  },
  lore: [
    "WIP Skrell lore!",
  ],
};

export default Skrell;
