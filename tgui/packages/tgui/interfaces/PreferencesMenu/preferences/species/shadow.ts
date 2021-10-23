import { createLanguagePerk, Species } from "./base";

const Shadow: Species = {
  description: "Shadowpeople are creatures of the dark that that burn when \
    exposed to lights. They're often found as nightmarish creatures \
    with arms sharpened and a desire to extinguish all brightness, but there \
    exists some without as much zeal.",
  features: {
    good: [{
      icon: "shield-alt",
      name: "Shrouded by Darkness",
      description: "Shadowpeople are immune to radiation and diseases.",
    }, {
      icon: "wind",
      name: "Breathless as Shadows",
      description: "Shadowpeople don't need to breathe.",
    }, createLanguagePerk("Shadowtongue")],
    neutral: [],
    bad: [{
      icon: "moon",
      name: "Fiend of the Night",
      description: "Shadowpeople burn when exposed to light and heal \
        in the darkness.",
    }],
  },
  lore: [
    "WIP Shadowperson lore!",
  ],
};

export default Shadow;
