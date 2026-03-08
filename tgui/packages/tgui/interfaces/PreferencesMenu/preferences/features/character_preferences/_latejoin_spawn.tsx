import { FeatureChoiced } from '../base';
import { FeatureDropdownInput } from '../dropdowns';

export const preferred_latejoin_spawn: FeatureChoiced = {
  name: 'Latejoin Preference',
  description:
    'Determines the method of arrivals when joining midround. \
    This indicates preference - it does not guarantee a specific spawn point, \
    particularly for maps which may not support all options.',
  component: FeatureDropdownInput,
};
