import { CheckboxInput, FeatureToggle } from '../base';

export const hear_radio_sounds: FeatureToggle = {
  name: 'Toggle Radio Sounds',
  category: 'SOUND',
  description: 'When toggled, you will no longer hear radio sounds.',
  component: CheckboxInput,
};
