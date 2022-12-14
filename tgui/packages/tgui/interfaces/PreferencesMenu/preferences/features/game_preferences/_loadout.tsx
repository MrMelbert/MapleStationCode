import { Feature, FeatureValueProps } from '../base';
import { Button, Stack } from '../../../../../components';

export const loadout_list: Feature<undefined, undefined> = {
  name: 'Access Loadout Manager',
  component: (props: FeatureValueProps<undefined, undefined>) => {
    const { act } = props;

    return (
      <Stack>
        <Stack.Item>
          <Button content="Open" onClick={() => act('open_loadout_manager')} />
        </Stack.Item>
      </Stack>
    );
  },
};
