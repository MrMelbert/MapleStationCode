import { CheckboxInput, type FeatureToggle } from '../base';

export const hear_radio_sounds: FeatureToggle = {
  name: 'Toggle Radio Sounds',
  category: 'SOUND',
  description: 'When unchecked, you will no longer hear radio sounds.',
  component: CheckboxInput,
};
