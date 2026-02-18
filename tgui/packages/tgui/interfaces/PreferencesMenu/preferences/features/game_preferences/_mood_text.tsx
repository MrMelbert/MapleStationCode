import { type FeatureNumeric, FeatureSliderInput } from '../base';

export const mood_text_alpha: FeatureNumeric = {
  name: 'Mood Text Transparency',
  category: 'GAMEPLAY',
  description: `Controls how transparent the text displayed on your screen
    when your character is affected by moodlet is.`,
  component: FeatureSliderInput,
};
