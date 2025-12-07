import {
  CheckboxInput,
  type Feature,
  FeatureSliderInput,
  type FeatureToggle,
} from '../base';

export const darkened_flash: FeatureToggle = {
  name: 'Enable darkened flashes',
  category: 'ACCESSIBILITY',
  description: `
    When toggled, being flashed will show a dark screen rather than a
    bright one.
  `,
  component: CheckboxInput,
};

export const screen_shake_darken: FeatureToggle = {
  name: 'Darken screen shake',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, experiencing screen shake will darken your screen.
    `,
  component: CheckboxInput,
};

export const distance_text_shrinking: FeatureToggle = {
  name: 'Distance-based speech size',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, speech from distant sources will appear smaller.
    `,
  component: CheckboxInput,
};

export const runechat_text_names: FeatureToggle = {
  name: 'Runechat-colored names',
  category: 'ACCESSIBILITY',
  description: `
      When toggled, names in chat will be colored according to the speaker's runechat color.
    `,
  component: CheckboxInput,
};

export const min_recoil_multiplier: Feature<number> = {
  name: 'Cosmetic Recoil Strength',
  category: 'ACCESSIBILITY',
  description: `
      Modifies the strength of cosmetic recoil's effect on your camera.
      0 will disable cosmetic recoil entirely, though mechanical recoil will be unaffected.
    `,
  component: FeatureSliderInput,
};
