import { CheckboxInput, FeatureToggle } from '../base';

export const default_shake_when_helping: FeatureToggle = {
  name: 'Default Shake When Helping',
  category: 'GAMEPLAY',
  description:
    'When clicking on a downed humanoid, you will always shake them, \
    rather than opening the help wheel. To do CPR or check their pulse, \
    you will need to use the *cpr or *check commands.',
  component: CheckboxInput,
};
