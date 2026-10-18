import type { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const character_height: FeatureChoiced = {
  name: 'Character Size',
  description:
    "Direct modifier to your character's size, from 0.7x to 1.5x. \
    Effects not shown in character setup.",
  component: FeatureDropdownInput,
};

export const character_height_modern: FeatureChoiced = {
  name: 'Character Height',
  description:
    "A more subtle modifier to your character's height, adding or \
    removing a few pixels in certain locations. \
    Effects shown in character setup.",
  component: FeatureDropdownInput,
};
