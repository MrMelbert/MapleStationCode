import { createLanguagePerk, Species } from "./base";

const Pod: Species = {
  description: "Podpeople are a species of peaceful plant lovers made of \
    leaves and twigs. Often, they're grown by replica pods by enterprising \
    botanists, but they're otherwise found around the galaxy where plants and \
    seeds flourish.",
  features: {
    good: [{
      icon: "leaf",
      name: "Green Thumbs",
      description: "Podpeople are friend to all plants. Hostile sentient \
        plants will not harm them and dangerous botanical produce can \
        be handled without gloves.",
    }, createLanguagePerk("Sylvan")],
    neutral: [{
      icon: "sun",
      name: "Photosynthesis",
      description: "Podpeople feed themselves and heal when exposed to light, \
        and wilt and starve when living in darkness.",
    }, {
      icon: "first-aid",
      name: "Plant Matter",
      description: "Podpeople must use plant analyzers to scan themselves \
        instead of heath analyzers.",
    }],
    bad: [{
      icon: "burn",
      name: "Leafy Skin",
      description: "As their skin and flesh is made from leaves and stems, \
        podpeople are more vulnerable to fire.",
    }, {
      icon: "user-injured",
      name: "Minor Pain Vulnerability",
      description: "Podpeople are made from thin leaves and grass, and \
        recieve 5% more pain overall.",
    }, {
      icon: "paw",
      name: "Herbivore Target",
      description: "Being made of plants and leaves, podpeople are a target \
        of herbivorous creatures such as goats.",
    }],
  },
  lore: [
    "WIP Podpeople lore!",
  ],
};

export default Pod;
