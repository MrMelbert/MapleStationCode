import {
  CheckboxInput,
  type Feature,
  type FeatureChoiced,
  FeatureColorInput,
  FeatureNumberInput,
  type FeatureNumeric,
  type FeatureToggle,
} from './base';
import { FeatureDropdownInput } from './dropdowns';

export const feature_head_tentacles: FeatureChoiced = {
  name: 'Head Tentacles',
  component: FeatureDropdownInput,
};

export const feature_synth_head_cover: FeatureChoiced = {
  name: 'Head Cover',
  component: FeatureDropdownInput,
};

export const hair_lizard: FeatureToggle = {
  name: 'Hair Lizard',
  description: 'Check to spawn as a Lizard with hair.',
  component: CheckboxInput,
};

export const hiss_length: FeatureNumeric = {
  name: 'Hiss Length',
  description: 'How long do you hissssss for?',
  component: FeatureNumberInput,
};

export const feature_lizard_horn_color: Feature<string> = {
  name: 'Horn Color',
  component: FeatureColorInput,
};

export const feature_lizard_horn_layer: FeatureChoiced = {
  name: 'Horn Layer',
  description: 'Determines what layer your horns are on.',
  component: FeatureDropdownInput,
};

export const feature_lizard_frill_layer: FeatureChoiced = {
  name: 'Frill Layer',
  description: 'Determines what layer your frills are on.',
  component: FeatureDropdownInput,
};

export const feature_synth_species: FeatureChoiced = {
  name: 'Synth Species',
  description: 'Determines what species you spawn disguised as.',
  component: FeatureDropdownInput,
};

export const feature_synth_damage_threshold: FeatureNumeric = {
  name: 'Synth Damage Threshold',
  description:
    'Determines how much damage you can take before your disguise is broken.',
  component: FeatureNumberInput,
};

export const feature_synth_blood: FeatureChoiced = {
  name: 'Synth Blood',
  description: 'Determines how your blood works.',
  component: FeatureDropdownInput,
};

export const feature_arm_wings: FeatureChoiced = {
  name: 'Arm Wings',
  component: FeatureDropdownInput,
};

export const feather_color: Feature<string> = {
  name: 'Feather Color',
  description:
    "The color of your character's feathers. \
  (Armwings, Plumage).",
  component: FeatureColorInput,
};

export const feature_avian_tail: FeatureChoiced = {
  name: 'Tail',
  component: FeatureDropdownInput,
};

export const feature_avian_ears: FeatureChoiced = {
  name: 'Plumage',
  component: FeatureDropdownInput,
};

export const feature_fish_tail: FeatureChoiced = {
  name: 'Fish Tail',
  component: FeatureDropdownInput,
};

export const feature_rat_tail: FeatureChoiced = {
  name: 'Rat Tail',
  component: FeatureDropdownInput,
};

export const feature_rat_ears: FeatureChoiced = {
  name: 'Rat Ears',
  component: FeatureDropdownInput,
};

export const feature_bat_wings: FeatureChoiced = {
  name: 'Bat Wings',
  component: FeatureDropdownInput,
};

export const feature_bat_ears: FeatureChoiced = {
  name: 'Bat Ears',
  component: FeatureDropdownInput,
};

export const feature_deer_ears: FeatureChoiced = {
  name: 'Deer Ears',
  component: FeatureDropdownInput,
};

export const feature_deer_tail: FeatureChoiced = {
  name: 'Deer Tail',
  component: FeatureDropdownInput,
};

export const feature_bunny_ears: FeatureChoiced = {
  name: 'Bunny Ears',
  component: FeatureDropdownInput,
};

export const feature_bunny_tail: FeatureChoiced = {
  name: 'Bunny Tail',
  component: FeatureDropdownInput,
};
