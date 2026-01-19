import { type Feature, FeatureColorInputNullable } from '../base';

export const runechat_color: Feature<string> = {
  name: 'Runechat Color',
  description:
    "The color of your character's voice. \
     Right click to hvae it randomize it every round.",
  component: FeatureColorInputNullable,
};
