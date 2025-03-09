import { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const ready_anominity: FeatureChoiced = {
  name: 'Ready Anominity',
  component: FeatureDropdownInput,
  category: 'GHOST',
  description:
    'Allows you to anonymously ready up in the lobby. \
    Note, important jobs are never hidden.',
};
