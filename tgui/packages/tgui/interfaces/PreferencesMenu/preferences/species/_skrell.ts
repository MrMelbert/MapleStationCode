import { createLanguagePerk, Species } from "./base";

const Skrell: Species = {
  description: "WIP Skrell!",
  features: {
    good: [{
      icon: "user-injured",
      name: "Pain Resilience",
      description: "Skrell are a bit more resilient to pain, taking \
        15% less pain overall.",
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
        regaining blood from iron, they instead must take blood from copper.",
    }],
  },
  lore: [
    "WIP Skrell!",
  ],
};

export default Skrell;
