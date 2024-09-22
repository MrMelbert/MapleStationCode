import {
  FeatureChoiced,
  FeatureDropdownInput,
  FeatureIconnedDropdownInput,
  FeatureWithIcons,
} from '../base';

export const limp_cane: FeatureWithIcons<string> = {
  name: 'Limp Aid',
  component: FeatureIconnedDropdownInput,
};

export const limp_intensity: FeatureChoiced = {
  name: 'Limp Intensity',
  component: FeatureDropdownInput,
};

export const limp_side: FeatureChoiced = {
  name: 'Limp Side',
  component: FeatureDropdownInput,
};
