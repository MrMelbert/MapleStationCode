import { CheckboxInput, type FeatureToggle } from '../base';

export const hear_radio_sounds: FeatureToggle = {
  name: 'Enable Radio Sounds',
  category: 'SOUND',
  description:
    'When enabled, you will hear a sound when you receive a radio message.',
  component: CheckboxInput,
};
