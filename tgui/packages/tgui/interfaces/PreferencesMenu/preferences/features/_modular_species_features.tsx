import { CheckboxInput, FeatureChoiced, FeatureDropdownInput, FeatureToggle } from './base';

export const feature_head_tentacles: FeatureChoiced = {
  name: 'Head Tentacles',
  component: FeatureDropdownInput,
};

export const hair_lizard: FeatureToggle = {
  name: 'Hair Lizard',
  component: CheckboxInput,
};

export const feature_arm_wings: FeatureChoiced = {
  name: 'Arm Wings',
  component: FeatureDropdownInput,
};

/* export const feature_avian_tail: FeatureChoiced = {
  name: 'Tail',
  component: FeatureDropdownInput,
}; */ // temporarily disabled pending when i want it/someone else wants it

export const feature_avian_ears: FeatureChoiced = {
  name: 'Plumage',
  component: FeatureDropdownInput,
};
