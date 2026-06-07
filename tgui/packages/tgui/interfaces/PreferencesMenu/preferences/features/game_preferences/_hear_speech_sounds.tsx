import { CheckboxInput, type FeatureToggle } from '../base';

export const hear_speech_sounds: FeatureToggle = {
  name: 'Enable Speech Sounds',
  category: 'SOUND',
  description: 'When enabled, mobs will make sounds when they speak.',
  component: CheckboxInput,
};
