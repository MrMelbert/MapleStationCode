import { type Feature, FeatureColorInput } from '../base';

export const runechat_color: Feature<string> = {
  name: 'Runechat Color',
  description:
    "The color of your character's runechat messages \
    (above head chat messages). Set to #AAAAAA to randomize color.",
  component: FeatureColorInput,
};
