import {
  type FeatureChoiced,
  FeatureNumberInput,
  type FeatureNumeric,
  FeatureSliderInput,
} from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const mood_text_alpha: FeatureNumeric = {
  name: 'Mood Text Transparency',
  category: 'GAMEPLAY',
  description: `Controls the transparency of moodlet screen text popups.`,
  component: FeatureSliderInput,
};

export const mood_text_cap: FeatureNumeric = {
  name: 'Mood Text Cap',
  category: 'GAMEPLAY',
  description: `Controls how many moodlet screen text popups can be visible at once.
    Setting this to 0 will disable moodlet text popups entirely.`,
  component: FeatureNumberInput,
};

export const mood_text_location: FeatureChoiced = {
  name: 'Mood Text Location',
  category: 'GAMEPLAY',
  description: `Controls where moodlet screen text popups appear on the screen.`,
  component: FeatureDropdownInput,
};
