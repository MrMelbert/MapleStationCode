import { CheckboxInput, type FeatureToggle } from '../base';

export const hear_speech_sounds: FeatureToggle = {
  name: 'Toggle Speech Sounds',
  category: 'SOUND',
  description: 'When unchecked, you will no longer hear speech sounds.',
  component: CheckboxInput,
};
