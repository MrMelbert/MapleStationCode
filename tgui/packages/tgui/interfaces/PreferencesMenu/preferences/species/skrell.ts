import { createLanguagePerk, Species } from "./base";

const Skrell: Species = {
  description: "WIP Skrell description!",
  features: {
    good: [{
      icon: "user-injured",
      name: "Pain Resilience",
      description: "Skrell are a bit more resilient to pain, taking \
        20% less pain overall.",
    }, createLanguagePerk("Skrellian")],
    neutral: [{
      icon: "wine-bottle",
      name: "Light Drinkers",
      description: "Skrell naturally don't get along with alcohol \
        and find themselves getting inebriated very easily.",
    }],
    bad: [{
      icon: "tint",
      name: "Abnormal Blood",
      description: "Skrell have a unique \"S\" type blood. Instead of \
        regaining blood from iron, they instead must take copper for blood.",
    }],
  },
  lore: [
    "WIP Skrell lore!",
  ],
};

export default Skrell;
