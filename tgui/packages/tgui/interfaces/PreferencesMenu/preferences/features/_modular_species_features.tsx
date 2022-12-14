import { CheckboxInput, FeatureChoiced, FeatureDropdownInput, FeatureToggle } from './base';

export const feature_head_tentacles: FeatureChoiced = {
  name: 'Head Tentacles',
  component: FeatureDropdownInput,
};

export const hair_lizard: FeatureToggle = {
  name: 'Hair Lizard',
  component: CheckboxInput,
};
