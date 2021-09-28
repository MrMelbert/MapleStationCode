import { Species } from "./base";

const Synth: Species = {
  description: "WIP Synth description!",
  features: {
    good: [{
      icon: "robot",
      name: "Robot Rock",
      description: "Synths are robotic instead of organic, and as such may be \
        affected by or immune to some things normal humanoids are or aren't.",
    }, {
      icon: "user-secret",
      name: "Incognito Mode",
      description: "Synths are secretly synthetic androids that disguise \
        as another species.",
    }, {
      icon: "shield-alt",
      name: "Silicon Supremecy",
      description: "Being synthetic, Synths gain many resistances that come \
        with silicons. They're immune to viruses, dismemberment, having \
        limbs disabled, and they don't need to eat or breath.",
    },{
      icon: "user-injured",
      name: "Major Pain Resilience",
      description: "Being synthetic, Synths are very \
        resistant to pain. They recieve 50% less pain overall.",
    }, {
      icon: "language",
      name: "Language Processor ",
      description: "Synths can understand and speak a wide variety of \
        additional languages, including Encoded Audio Language, the language \
        of silicon and synthetics.",
    }],
    neutral: [{
      icon: "theater-masks",
      name: "Full Copy",
      description: "Synths take on all the traits of species they disguise as, \
        both positive and negative.",
    }],
    bad: [{
      icon: "users-cog",
      name: "Error: Disguise Failure",
      description: "When Synthetics take enough damage, their disguise will \
        begin to falter and fail. That is, if this feature was actually \
        implemented, but it doesn't work!",
    }],
  },
  lore: [
    "WIP Synth lore!",
  ],
};

export default Synth;
